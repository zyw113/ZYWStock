//
//  ZYWCandleChartView.m
//  ZYWChart
//
//  Created by 张有为 on 2016/12/17.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZYWCandleChartView.h"
#import "ZYWCalcuteTool.h"

/// 均线周期, 与 ZYWMALineColors 一一对应
static const NSUInteger ZYWMAPeriods[] = {5, 10, 25};
static const NSUInteger ZYWMALineCount = sizeof(ZYWMAPeriods) / sizeof(ZYWMAPeriods[0]);

static const NSInteger ZYWDefaultMinDisplayCount = 10;
static const NSInteger ZYWDefaultMaxDisplayCount = 100;

/// 日期文字图层的尺寸
static const CGFloat ZYWDateLayerWidth  = 60.f;
static const CGFloat ZYWDateLayerHeight = 15.f;

static inline BOOL ZYWIsZero(CGFloat value)
{
    return fabs(value) <= 0.00001;
}

@interface ZYWCandleChartView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIScrollView *superScrollView;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;

/// 可视区域数据, 复用同一份容器, 滚动过程中不产生新对象
@property (nonatomic, strong) NSMutableArray<__kindof ZYWCandleModel *> *displayModels;
@property (nonatomic, strong) NSMutableArray<ZYWCandlePostionModel *> *postionModels;

/// 全量数据的均线缓存, 数据源变化时计算一次, 布局为 [线条][下标]
@property (nonatomic, strong) NSMutableData *maValues;

/// 常驻图层, 只在数据变化时更新 path, 不再逐帧创建销毁
@property (nonatomic, strong) CAShapeLayer *riseLayer;
@property (nonatomic, strong) CAShapeLayer *fallLayer;
@property (nonatomic, strong) CAShapeLayer *gridLayer;
@property (nonatomic, strong) NSArray<CAShapeLayer *> *maLayers;
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *dateLayers;

@property (nonatomic, assign) CGFloat timeLayerHeight;
@property (nonatomic, assign) CGFloat contentOffset;

/// 缩放过程中的锚点: 手指下方的K线下标与它在可视区域内的横坐标
@property (nonatomic, assign) CGFloat zoomAnchorIndex;
@property (nonatomic, assign) CGFloat zoomAnchorViewportX;
@property (nonatomic, assign) NSInteger zoomBeginDisplayCount;
@property (nonatomic, assign) BOOL zooming;

@end

@implementation ZYWCandleChartView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _leftMargin = 2;
    _rightMargin = 2;
    _topMargin = 20;
    _bottomMargin = 0;
    _lineWidth = 1;
    _minHeight = 1;
    _timeLayerHeight = ZYWDateLayerHeight;
    _displayCount = 25;
    _candleSpace = 2;
    _minDisplayCount = ZYWDefaultMinDisplayCount;
    _maxDisplayCount = ZYWDefaultMaxDisplayCount;
    _zoomEnabled = YES;

    _displayModels = [NSMutableArray array];
    _postionModels = [NSMutableArray array];
    _dateLayers = [NSMutableArray array];

    [self setupLayers];
}

/// 图层只创建一次, 之后每帧仅更新 path
- (void)setupLayers
{
    _gridLayer = [CAShapeLayer layer];
    _gridLayer.contentsScale = UIScreen.mainScreen.scale;
    _gridLayer.fillColor = UIColor.clearColor.CGColor;
    _gridLayer.strokeColor = [UIColor colorWithHexString:@"ededed"].CGColor;
    [self.layer addSublayer:_gridLayer];

    //配色沿用工程原有约定: 收盘低于开盘用 RoseColor, 高于开盘用 DropColor
    _fallLayer = [CAShapeLayer layer];
    _fallLayer.contentsScale = UIScreen.mainScreen.scale;
    _fallLayer.fillColor = RoseColor.CGColor;
    _fallLayer.strokeColor = RoseColor.CGColor;
    [self.layer addSublayer:_fallLayer];

    _riseLayer = [CAShapeLayer layer];
    _riseLayer.contentsScale = UIScreen.mainScreen.scale;
    _riseLayer.fillColor = DropColor.CGColor;
    _riseLayer.strokeColor = DropColor.CGColor;
    [self.layer addSublayer:_riseLayer];

    NSArray<UIColor *> *maColors = @[UIColor.cyanColor, UIColor.magentaColor, UIColor.orangeColor];
    NSMutableArray<CAShapeLayer *> *maLayers = [NSMutableArray arrayWithCapacity:ZYWMALineCount];
    for (NSUInteger index = 0; index < ZYWMALineCount; index++)
    {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.contentsScale = UIScreen.mainScreen.scale;
        layer.lineCap = kCALineCapRound;
        layer.lineJoin = kCALineJoinRound;
        layer.fillColor = UIColor.clearColor.CGColor;
        layer.strokeColor = maColors[index].CGColor;
        [self.layer addSublayer:layer];
        [maLayers addObject:layer];
    }
    _maLayers = maLayers.copy;

    [self applyLineWidth];
}

- (void)applyLineWidth
{
    CGFloat hairline = 1.f / UIScreen.mainScreen.scale;
    _gridLayer.lineWidth = _lineWidth;
    _riseLayer.lineWidth = hairline * 1.5f;
    _fallLayer.lineWidth = hairline * 1.5f;
    for (CAShapeLayer *layer in _maLayers)
    {
        layer.lineWidth = _lineWidth;
    }
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self applyLineWidth];
}

#pragma mark - 数据源

- (void)setDataArray:(NSArray<__kindof ZYWCandleModel *> *)dataArray
{
    _dataArray = [dataArray copy];
    [self rebuildMACache];
}

/// 均线在数据源变化时整体算一次, 滚动时只做查表
- (void)rebuildMACache
{
    NSUInteger count = _dataArray.count;
    if (count == 0)
    {
        self.maValues = nil;
        return;
    }

    NSMutableData *closes = [NSMutableData dataWithLength:count * sizeof(CGFloat)];
    CGFloat *closeValues = closes.mutableBytes;
    [_dataArray enumerateObjectsUsingBlock:^(ZYWCandleModel *model, NSUInteger index, BOOL *stop) {
        closeValues[index] = model.close;
    }];

    NSMutableData *maValues = [NSMutableData dataWithLength:ZYWMALineCount * count * sizeof(CGFloat)];
    CGFloat *values = maValues.mutableBytes;
    for (NSUInteger line = 0; line < ZYWMALineCount; line++)
    {
        ZYWComputeSMA(closeValues, count, ZYWMAPeriods[line], values + line * count);
    }
    self.maValues = maValues;
}

- (NSArray<__kindof ZYWCandleModel *> *)currentDisplayArray
{
    return self.displayModels;
}

- (NSArray<ZYWCandlePostionModel *> *)currentPostionArray
{
    return self.postionModels;
}

#pragma mark - 滚动与手势

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (![self.superview isKindOfClass:UIScrollView.class])
    {
        return;
    }

    UIScrollView *scrollView = (UIScrollView *)self.superview;
    self.superScrollView = scrollView;
    scrollView.delegate = self;
    [scrollView.panGestureRecognizer addTarget:self action:@selector(handlePanGesture:)];

    if (!self.pinchGesture)
    {
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        self.pinchGesture.delegate = self;
    }
    [scrollView addGestureRecognizer:self.pinchGesture];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.contentOffset = scrollView.contentOffset.x;
    if (self.zooming)
    {
        //缩放过程中由缩放流程统一重绘, 避免同一帧画两次
        return;
    }
    [self drawKLine];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state != UIGestureRecognizerStateEnded)
    {
        return;
    }

    //给定一个临界初始值(负数)
    if (self.superScrollView.contentOffset.x > -5)
    {
        return;
    }

    if ([self.delegate respondsToSelector:@selector(displayMoreData)])
    {
        //记录上一次的偏移量
        self.previousOffsetX = self.superScrollView.contentSize.width - self.superScrollView.contentOffset.x;
        [self.delegate displayMoreData];
    }
}

/// 捏合缩放: 以手指中心所在的K线为锚点连续改变可视根数, 锚点在屏幕上的位置保持不变
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture
{
    if (!self.isZoomEnabled || self.dataArray.count == 0 || !self.superScrollView)
    {
        return;
    }

    switch (pinchGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            CGFloat step = [self candleStep];
            if (ZYWIsZero(step))
            {
                return;
            }
            CGPoint focalPoint = [pinchGesture locationInView:self.superScrollView];
            self.zoomBeginDisplayCount = self.displayCount;
            self.zoomAnchorIndex = (focalPoint.x - self.leftMargin) / step;
            self.zoomAnchorViewportX = focalPoint.x - self.superScrollView.contentOffset.x;
            self.superScrollView.scrollEnabled = NO;
        }break;

        case UIGestureRecognizerStateChanged:
        {
            CGFloat scale = pinchGesture.scale;
            if (isnan(scale) || isinf(scale) || scale <= 0.f)
            {
                return;
            }

            NSInteger targetCount = lround(self.zoomBeginDisplayCount / scale);
            targetCount = MAX(self.minDisplayCount, MIN(self.maxDisplayCount, targetCount));
            if (targetCount == self.displayCount)
            {
                return;
            }
            [self applyDisplayCount:targetCount];
        }break;

        default:
        {
            self.superScrollView.scrollEnabled = YES;
        }break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //手指已经在拖动时也要能捏合, 否则捏合会被 scrollView 的 pan 挡掉
    return (gestureRecognizer == self.pinchGesture &&
            otherGestureRecognizer == self.superScrollView.panGestureRecognizer);
}

- (void)applyDisplayCount:(NSInteger)displayCount
{
    self.displayCount = displayCount;
    [self calcuteCandleWidth];

    self.zooming = YES;
    [self updateContentWidth];

    CGFloat step = [self candleStep];
    CGFloat maxOffset = MAX(0.f, self.superScrollView.contentSize.width - self.superScrollView.width);
    CGFloat offsetX = self.zoomAnchorIndex * step + self.leftMargin - self.zoomAnchorViewportX;
    offsetX = MIN(MAX(offsetX, 0.f), maxOffset);
    self.superScrollView.contentOffset = CGPointMake(offsetX, 0);

    self.contentOffset = self.superScrollView.contentOffset.x;
    [self drawKLine];
    self.zooming = NO;
}

#pragma mark - 布局

- (CGFloat)candleStep
{
    return self.candleWidth + self.candleSpace;
}

- (CGFloat)contentWidth
{
    if (self.dataArray.count == 0)
    {
        return self.superScrollView.width;
    }
    CGFloat width = self.dataArray.count * self.candleWidth +
                    (self.dataArray.count - 1) * self.candleSpace +
                    self.leftMargin + self.rightMargin;
    return MAX(width, self.superScrollView.width);
}

- (void)calcuteCandleWidth
{
    if (self.displayCount <= 0)
    {
        return;
    }
    self.candleWidth = (self.superScrollView.width - (self.displayCount - 1) * self.candleSpace -
                        self.leftMargin - self.rightMargin) / self.displayCount;
}

/// 只更新宽度, 不改变滚动位置
- (void)updateContentWidth
{
    CGFloat contentWidth = [self contentWidth];
    if (isnan(contentWidth) || isinf(contentWidth))
    {
        return;
    }

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(contentWidth));
    }];
    self.superScrollView.contentSize = CGSizeMake(contentWidth, 0);
    [self layoutIfNeeded];
}

/// 更新宽度并停留在最右侧
- (void)updateWidth
{
    [self updateContentWidth];
    self.superScrollView.contentOffset = CGPointMake(MAX(0.f, self.superScrollView.contentSize.width - self.superScrollView.width), 0);
}

- (CGFloat)leftPostion
{
    CGFloat offsetX = MAX(self.contentOffset, 0.f);
    CGFloat maxOffset = self.superScrollView.contentSize.width - self.superScrollView.width;
    return MIN(offsetX, MAX(maxOffset, 0.f));
}

- (NSInteger)currentStartIndex
{
    CGFloat step = [self candleStep];
    if (ZYWIsZero(step) || self.dataArray.count == 0)
    {
        return 0;
    }
    NSInteger index = (NSInteger)(self.leftPostion / step);
    return MIN(MAX(index, 0), (NSInteger)self.dataArray.count - 1);
}

- (NSInteger)visibleCount
{
    //多画一根, 保证滚动到两根K线之间时右侧不会留出空白
    NSInteger count = (NSInteger)self.dataArray.count - self.currentStartIndex;
    return MAX(MIN(self.displayCount + 1, count), 0);
}

/// K线在 scrollView 内容坐标系中的横坐标, 与下标一一对应,
/// 不随滚动偏移做二次换算, 保证拖动时K线与手指严格同步
- (CGFloat)xPositionForIndex:(NSInteger)index
{
    return self.leftMargin + index * [self candleStep];
}

#pragma mark - 可视区域计算

- (void)updateDisplayModels
{
    NSInteger startIndex = self.currentStartIndex;
    NSInteger endIndex = startIndex + self.visibleCount;

    [self.displayModels removeAllObjects];
    for (NSInteger index = startIndex; index < endIndex; index++)
    {
        ZYWCandleModel *model = self.dataArray[index];
        model.localIndex = index;
        [self.displayModels addObject:model];
    }
}

- (void)updateValueRange
{
    CGFloat maxValue = -CGFLOAT_MAX;
    CGFloat minValue = CGFLOAT_MAX;
    for (ZYWCandleModel *model in self.displayModels)
    {
        minValue = MIN(minValue, model.low);
        maxValue = MAX(maxValue, model.high);
    }

    //价格波动过小时撑开上下限, 避免K线挤成一条直线
    if (maxValue - minValue < 0.5)
    {
        maxValue += 0.5;
        minValue -= 0.5;
    }

    self.maxY = maxValue;
    self.minY = minValue;
    self.scaleY = (self.height - self.topMargin - self.bottomMargin - self.timeLayerHeight) / (maxValue - minValue);
}

/// 位置模型整体复用, 滚动过程中不再逐帧 alloc
- (void)updatePostionModels
{
    NSUInteger count = self.displayModels.count;
    while (self.postionModels.count < count)
    {
        [self.postionModels addObject:[ZYWCandlePostionModel new]];
    }
    if (self.postionModels.count > count)
    {
        [self.postionModels removeObjectsInRange:NSMakeRange(count, self.postionModels.count - count)];
    }

    NSInteger startIndex = self.currentStartIndex;
    for (NSUInteger index = 0; index < count; index++)
    {
        ZYWCandleModel *model = self.displayModels[index];
        CGFloat left = [self xPositionForIndex:startIndex + index];

        ZYWCandlePostionModel *postion = self.postionModels[index];
        postion.openPoint = CGPointMake(left, (self.maxY - model.open) * self.scaleY);
        postion.closePoint = CGPointMake(left, (self.maxY - model.close) * self.scaleY);
        postion.highPoint = CGPointMake(left, (self.maxY - model.high) * self.scaleY);
        postion.lowPoint = CGPointMake(left, (self.maxY - model.low) * self.scaleY);
        postion.date = model.date;
        postion.isDrawDate = model.isDrawDate;
        postion.localIndex = model.localIndex;
    }
}

#pragma mark - 绘制

- (void)drawKLine
{
    if (self.dataArray.count == 0 || self.superScrollView.width <= 0)
    {
        return;
    }

    [self updateDisplayModels];
    if (self.displayModels.count == 0)
    {
        return;
    }

    if ([self.delegate respondsToSelector:@selector(displayScreenleftPostion:startIndex:count:)])
    {
        [self.delegate displayScreenleftPostion:self.leftPostion startIndex:self.currentStartIndex count:self.visibleCount];
    }

    if ([self.delegate respondsToSelector:@selector(displayLastModel:)])
    {
        [self.delegate displayLastModel:self.displayModels.lastObject];
    }

    [self updateValueRange];
    [self updatePostionModels];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self updateCandleLayers];
    [self updateMALayers];
    [self updateGridAndDateLayers];
    [CATransaction commit];
}

- (void)updateCandleLayers
{
    CGMutablePathRef risePath = CGPathCreateMutable();
    CGMutablePathRef fallPath = CGPathCreateMutable();

    for (ZYWCandlePostionModel *postion in self.postionModels)
    {
        //y 值越大价格越低, 开盘点低于收盘点(y 更大)即为上涨
        BOOL isRising = postion.openPoint.y > postion.closePoint.y;
        [self appendCandlePath:isRising ? risePath : fallPath postion:postion];
    }

    self.riseLayer.path = risePath;
    self.fallLayer.path = fallPath;

    CGPathRelease(risePath);
    CGPathRelease(fallPath);
}

- (void)appendCandlePath:(CGMutablePathRef)path postion:(ZYWCandlePostionModel *)postion
{
    CGFloat openPrice = postion.openPoint.y + self.topMargin;
    CGFloat closePrice = postion.closePoint.y + self.topMargin;
    CGFloat highPrice = postion.highPoint.y + self.topMargin;
    CGFloat lowPrice = postion.lowPoint.y + self.topMargin;
    CGFloat x = postion.openPoint.x;
    CGFloat height = MAX(fabs(closePrice - openPrice), self.minHeight);
    CGFloat y = MIN(openPrice, closePrice);

    //开盘价等于收盘价时画一条最小高度的横线
    CGRect body = ZYWIsZero(closePrice - openPrice) ? CGRectMake(x, closePrice - height, self.candleWidth, height)
                                                    : CGRectMake(x, y, self.candleWidth, height);
    CGPathAddRect(path, NULL, body);

    CGFloat centerX = x + self.candleWidth / 2.f;
    CGFloat bodyTop = MIN(openPrice, closePrice);
    CGFloat bodyBottom = MAX(openPrice, closePrice);

    //上影线
    if (!ZYWIsZero(bodyTop - highPrice))
    {
        CGPathMoveToPoint(path, NULL, centerX, bodyTop);
        CGPathAddLineToPoint(path, NULL, centerX, highPrice);
    }

    //下影线
    if (!ZYWIsZero(lowPrice - bodyBottom))
    {
        CGPathMoveToPoint(path, NULL, centerX, lowPrice);
        CGPathAddLineToPoint(path, NULL, centerX, bodyBottom);
    }
}

- (void)updateMALayers
{
    NSUInteger totalCount = self.dataArray.count;
    if (self.maValues.length < ZYWMALineCount * totalCount * sizeof(CGFloat))
    {
        return;
    }

    const CGFloat *maValues = self.maValues.bytes;
    NSInteger startIndex = self.currentStartIndex;
    NSUInteger count = self.postionModels.count;

    for (NSUInteger line = 0; line < ZYWMALineCount; line++)
    {
        const CGFloat *values = maValues + line * totalCount;
        CGMutablePathRef path = CGPathCreateMutable();
        for (NSUInteger index = 0; index < count; index++)
        {
            ZYWCandlePostionModel *postion = self.postionModels[index];
            CGFloat x = postion.openPoint.x + self.candleWidth / 2.f;
            CGFloat y = (self.maxY - values[startIndex + index]) * self.scaleY + self.topMargin;
            if (index == 0)
            {
                CGPathMoveToPoint(path, NULL, x, y);
            }
            else
            {
                CGPathAddLineToPoint(path, NULL, x, y);
            }
        }
        self.maLayers[line].path = path;
        CGPathRelease(path);
    }
}

/// 网格线与日期: 网格合并成一条 path, 日期文字图层按需复用
- (void)updateGridAndDateLayers
{
    CGFloat axisY = self.height - self.timeLayerHeight - self.bottomMargin;
    CGFloat visibleLeft = self.leftPostion;
    CGFloat visibleRight = visibleLeft + self.superScrollView.width;

    CGMutablePathRef gridPath = CGPathCreateMutable();
    //底部坐标轴
    CGPathMoveToPoint(gridPath, NULL, visibleLeft, axisY);
    CGPathAddLineToPoint(gridPath, NULL, visibleRight, axisY);
    //中间的分隔线
    CGPathMoveToPoint(gridPath, NULL, visibleLeft, self.height / 2.f);
    CGPathAddLineToPoint(gridPath, NULL, visibleRight, self.height / 2.f);

    NSUInteger usedLayerCount = 0;
    for (ZYWCandlePostionModel *postion in self.postionModels)
    {
        if (!postion.isDrawDate)
        {
            continue;
        }

        CGFloat separatorX = postion.highPoint.x + self.candleWidth / 2.f - self.lineWidth / 2.f;
        CGPathMoveToPoint(gridPath, NULL, separatorX, 1 * heightradio);
        CGPathAddLineToPoint(gridPath, NULL, separatorX, axisY);

        CATextLayer *textLayer = [self dateLayerAtIndex:usedLayerCount++];
        if (![textLayer.string isEqual:postion.date])
        {
            textLayer.string = postion.date;
        }
        textLayer.bounds = CGRectMake(0, 0, ZYWDateLayerWidth, self.timeLayerHeight);
        textLayer.position = CGPointMake(postion.highPoint.x + self.candleWidth,
                                         self.height - self.timeLayerHeight / 2.f - self.bottomMargin);
        textLayer.hidden = NO;
    }

    for (NSUInteger index = usedLayerCount; index < self.dateLayers.count; index++)
    {
        self.dateLayers[index].hidden = YES;
    }

    self.gridLayer.path = gridPath;
    CGPathRelease(gridPath);
}

- (CATextLayer *)dateLayerAtIndex:(NSUInteger)index
{
    if (index < self.dateLayers.count)
    {
        return self.dateLayers[index];
    }

    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = UIScreen.mainScreen.scale;
    layer.fontSize = 12.f;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = UIColor.grayColor.CGColor;
    [self.layer addSublayer:layer];
    [self.dateLayers addObject:layer];
    return layer;
}

#pragma mark - 填充与刷新

- (void)stockFill
{
    [self.superScrollView layoutIfNeeded];
    [self calcuteCandleWidth];
    [self updateWidth];
    [self drawKLine];
}

- (void)reload
{
    if (self.dataArray.count == 0)
    {
        [self updateContentWidth];
        return;
    }

    CGFloat previousContentWidth = self.superScrollView.contentSize.width;
    [self updateContentWidth];
    //右拉加载后保持原来那根K线仍在手指位置
    self.superScrollView.contentOffset = CGPointMake(self.superScrollView.contentSize.width - previousContentWidth, 0);
    [self drawKLine];
}

#pragma mark - 长按获取坐标

- (CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion
{
    if (self.postionModels.count == 0)
    {
        return CGPointZero;
    }

    CGFloat step = [self candleStep];
    //先按坐标直接定位到可视数组中的下标, 再在邻近范围内做精确匹配
    NSInteger startIndex = ZYWIsZero(step) ? 0 : (NSInteger)((xPostion - self.leftMargin) / step) - self.currentStartIndex;
    for (NSInteger index = MAX(startIndex - 1, 0); index < (NSInteger)self.postionModels.count; index++)
    {
        ZYWCandlePostionModel *postion = self.postionModels[index];
        CGFloat minX = postion.highPoint.x - (self.candleSpace + self.candleWidth / 2);
        CGFloat maxX = postion.highPoint.x + (self.candleSpace + self.candleWidth / 2);

        if (xPostion > minX && xPostion < maxX)
        {
            if ([self.delegate respondsToSelector:@selector(longPressCandleViewWithIndex:kLineModel:)])
            {
                [self.delegate longPressCandleViewWithIndex:index kLineModel:self.displayModels[index]];
            }
            return CGPointMake(postion.highPoint.x, postion.openPoint.y);
        }
    }

    //手指落在可视区域两端之外时吸附到首尾两根K线
    ZYWCandlePostionModel *lastPostion = self.postionModels.lastObject;
    if (xPostion >= lastPostion.closePoint.x)
    {
        return CGPointMake(lastPostion.highPoint.x, lastPostion.openPoint.y);
    }

    ZYWCandlePostionModel *firstPostion = self.postionModels.firstObject;
    if (firstPostion.closePoint.x >= xPostion)
    {
        return CGPointMake(firstPostion.highPoint.x, firstPostion.openPoint.y);
    }

    return CGPointZero;
}

@end
