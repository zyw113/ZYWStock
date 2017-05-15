//
//  ZYWCandleChartView.m
//  ZYWChart
//
//  Created by 张有为 on 2016/12/17.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZYWCandleChartView.h"
#import "KVOController.h"
#import "ZYWCandlePostionModel.h"
#import "ZYWCalcuteTool.h"

static inline bool isEqualZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

@interface ZYWCandleChartView () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *superScrollView;
@property (nonatomic,strong) FBKVOController *KVOController;
@property (nonatomic,strong) NSMutableArray *modelArray;
@property (nonatomic,strong) NSMutableArray *modelPostionArray;
@property (nonatomic,strong) CAShapeLayer *lineChartLayer;
@property (nonatomic,strong) CAShapeLayer *ma5LineLayer;
@property (nonatomic,strong) CAShapeLayer *ma10LineLayer;
@property (nonatomic,strong) CAShapeLayer *ma25LineLayer;
@property (nonatomic,strong) CAShapeLayer *timeLayer;
@property (nonatomic,strong) NSMutableArray *maPostionArray;
@property (nonatomic,assign) CGFloat timeLayerHeight;

@end

@implementation ZYWCandleChartView

#pragma mark setter

-(NSMutableArray*)modelPostionArray
{
    if (!_modelPostionArray)
    {
        _modelPostionArray = [NSMutableArray array];
    }
    return _modelPostionArray;
}

-(NSMutableArray*)currentDisplayArray
{
    if (!_currentDisplayArray)
    {
        _currentDisplayArray = [NSMutableArray array];
    }
    return _currentDisplayArray;
}

-(NSMutableArray*)currentPostionArray
{
    if (!_currentPostionArray)
    {
        _currentPostionArray = [NSMutableArray array];
    }
    return _currentPostionArray;
}

-(NSMutableArray*)maPostionArray
{
    if (!_maPostionArray)
    {
        _maPostionArray = [NSMutableArray array];
    }
    return _maPostionArray;
}

#pragma mark KVO

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    _superScrollView = (UIScrollView*)self.superview;
    _superScrollView.delegate = self;
    [self addListener];
}

-(void)addListener
{
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.KVOController = KVOController;
    __weak typeof(self) this = self;
    [self.KVOController observe:_superScrollView keyPath:ContentOffSet options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if (self.kvoEnable)
        {
            this.contentOffset = this.superScrollView.contentOffset.x;
            [this drawKLine];
        }
    }];
}

#pragma mark privateMethod

-(void)calcuteMaxAndMinValue
{
    self.maxY = CGFLOAT_MIN;
    self.minY  = CGFLOAT_MAX;
    NSInteger idx = 0;
    for (NSInteger i = idx; i < self.currentDisplayArray
         .count; i++)
    {
        ZYWCandleModel * entity = [self.currentDisplayArray objectAtIndex:i];
        self.minY = self.minY < entity.low ? self.minY : entity.low;
        self.maxY = self.maxY > entity.high ? self.maxY : entity.high;
        
        if (self.maxY - self.minY < 0.5)
        {
            self.maxY += 0.5;
            self.minY  -=  0.5;
        }
    }
    self.scaleY = (self.height - self.topMargin - self.bottomMargin - self.timeLayerHeight) / (self.maxY-self.minY);
}

-(void)calcuteMaLinePostion
{
    [self.maPostionArray removeAllObjects];
    NSMutableArray *maLines = [[NSMutableArray alloc] init];
    NSMutableArray *array = (NSMutableArray*)[[self.currentDisplayArray reverseObjectEnumerator] allObjects];
    [maLines addObject:computeMAData(array,5)];
    [maLines addObject:computeMAData(array,10)];
    [maLines addObject:computeMAData(array,25)];
    for (NSInteger i = 0;i<maLines.count;i++)
    {
        ZYWLineData *lineData = [maLines objectAtIndex:i];
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger j = 0;j <lineData.data.count; j++)
        {
            ZYWLineUntil *until = lineData.data[j];
            CGFloat xPosition = self.leftPostion + ((self.candleWidth  + self.candleSpace) * j) + self.candleWidth/2;
            CGFloat yPosition = ((self.maxY - until.value) *self.scaleY);
            ZYWLineModel *model = [ZYWLineModel  initPositon:xPosition yPosition:yPosition color:lineData.color];
            [array addObject:model];
        }
        [self.maPostionArray addObject:array];
    }
}

#pragma mark publicMethod

-(void)setKvoEnable:(BOOL)kvoEnable
{
    _kvoEnable = kvoEnable;
}

-(NSInteger)currentStartIndex
{
    CGFloat scrollViewOffsetX = self.leftPostion < 0 ? 0 : self.leftPostion;

    NSInteger leftArrCount = (scrollViewOffsetX) / (self.candleWidth+self.candleSpace);
    
    if (leftArrCount > self.dataArray.count)
    {
        _currentStartIndex = self.dataArray.count - 1;
    }
    
    else if (leftArrCount == 0)
    {
        _currentStartIndex = 0;
    }
    
    else
    {
        _currentStartIndex =  leftArrCount ;
    }
    return _currentStartIndex;
}

- (CGFloat)leftPostion
{
    CGFloat scrollViewOffsetX = _contentOffset <  0  ?  0 : _contentOffset;
    if (_contentOffset + self.superScrollView.width >= self.superScrollView.contentSize.width)
    {
        scrollViewOffsetX = self.superScrollView.contentSize.width - self.superScrollView.width;
    }
    return scrollViewOffsetX;
}

- (void)initCurrentDisplayModels
{
    NSInteger needDrawKLineCount = self.displayCount;
    NSInteger currentStartIndex = self.currentStartIndex;
    NSInteger count = (currentStartIndex + needDrawKLineCount) >self.dataArray.count ? self.dataArray.count :currentStartIndex+needDrawKLineCount;
    
    [self.currentDisplayArray removeAllObjects];
    
    if (currentStartIndex < count)
    {
        for (NSInteger i = currentStartIndex; i <  count ; i++)
        {
            ZYWCandleModel *model = self.dataArray[i];
            [self.currentDisplayArray addObject:model];
        }
    }
}

-(void)initModelPositoin
{
    [self.currentPostionArray removeAllObjects];
    for (NSInteger i = 0 ; i < self.currentDisplayArray.count; i++)
    {
        ZYWCandleModel *entity  = [self.currentDisplayArray objectAtIndex:i];
        CGFloat open = ((self.maxY - entity.open) * self.scaleY);
        CGFloat close = ((self.maxY - entity.close) * self.scaleY);
        CGFloat high = ((self.maxY - entity.high) * self.scaleY);
        CGFloat low = ((self.maxY - entity.low) * self.scaleY);
        CGFloat left = self.leftPostion+ ((self.candleWidth + self.candleSpace) * i);
        
        if (left >= self.superScrollView.contentSize.width)
        {
            left = self.superScrollView.contentSize.width - self.candleWidth/2.f;
        }
        
        ZYWCandlePostionModel *positionModel = [ZYWCandlePostionModel modelWithOpen:CGPointMake(left, open) close:CGPointMake(left, close) high:CGPointMake(left, high) low:CGPointMake(left,low) date:entity.date];
        positionModel.isDrawDate = entity.isDrawDate;
        [self.currentPostionArray addObject:positionModel];
    }
}

#pragma mark layer相关

-(void)removeAllSubLayers
{
    for (NSInteger i = 0 ; i < self.lineChartLayer.sublayers.count; i++)
    {
        CAShapeLayer *layer = (CAShapeLayer*)self.lineChartLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
    
    for (NSInteger i = 0 ; i < self.timeLayer.sublayers.count; i++)
    {
        id layer = self.timeLayer.sublayers[i];
        [layer removeFromSuperlayer];
        layer = nil;
    }
}

- (void)initLayer
{
    if (self.lineChartLayer)
    {
        [self.lineChartLayer removeFromSuperlayer];
        self.lineChartLayer = nil;
    }
    
    if (!self.lineChartLayer)
    {
        self.lineChartLayer = [CAShapeLayer layer];
        self.lineChartLayer.strokeColor = [UIColor clearColor].CGColor;
        self.lineChartLayer.fillColor = [UIColor clearColor].CGColor;
    }
    [self.layer addSublayer:self.lineChartLayer];
    
    if (self.timeLayer)
    {
        [self.timeLayer removeFromSuperlayer];
        self.timeLayer = nil;
    }
    
    if (!self.timeLayer)
    {
        self.timeLayer = [CAShapeLayer layer];
        self.timeLayer.contentsScale = [UIScreen mainScreen].scale;
        self.timeLayer.strokeColor = [UIColor clearColor].CGColor;
        self.timeLayer.fillColor = [UIColor clearColor].CGColor;
    }
    [self.layer addSublayer:self.timeLayer];
    
    //ma5
    if (self.ma5LineLayer)
    {
        [self.ma5LineLayer removeFromSuperlayer];
    }
    
    if (!self.ma5LineLayer)
    {
        self.ma5LineLayer = [CAShapeLayer layer];
        self.ma5LineLayer.lineWidth = self.lineWidth;
        self.ma5LineLayer.lineCap = kCALineCapRound;
        self.ma5LineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.ma5LineLayer];
    
    //ma10
    if (self.ma10LineLayer)
    {
        [self.ma10LineLayer removeFromSuperlayer];
    }
    
    if (!self.ma10LineLayer)
    {
        self.ma10LineLayer = [CAShapeLayer layer];
        self.ma10LineLayer.lineWidth = self.lineWidth;
        self.ma10LineLayer.lineCap = kCALineCapRound;
        self.ma10LineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.ma10LineLayer];
    
    //ma25
    if (self.ma25LineLayer)
    {
        [self.ma25LineLayer removeFromSuperlayer];
    }
    
    if (!self.ma25LineLayer)
    {
        self.ma25LineLayer = [CAShapeLayer layer];
        self.ma25LineLayer.lineWidth = self.lineWidth;
        self.ma25LineLayer.lineCap = kCALineCapRound;
        self.ma25LineLayer.lineJoin = kCALineJoinRound;
    }
    [self.layer addSublayer:self.ma25LineLayer];
}

-(CAShapeLayer*)getShaperLayer:(ZYWCandlePostionModel*)postion
{
    CGFloat openPrice = postion.openPoint.y + self.topMargin;
    CGFloat closePrice = postion.closePoint.y + self.topMargin;
    CGFloat hightPrice = postion.highPoint.y + self.topMargin;
    CGFloat lowPrice = postion.lowPoint.y + self.topMargin;
    CGFloat x = postion.openPoint.x;
    CGFloat y = openPrice > closePrice ? (closePrice) : (openPrice);
    CGFloat height = MAX(fabs(closePrice-openPrice), self.minHeight);
    
    CGRect rect = CGRectMake(x, y, self.candleWidth, height);
    UIBezierPath *path = [UIBezierPath drawKLine:openPrice close:closePrice high:hightPrice low:lowPrice candleWidth:self.candleWidth rect:rect xPostion:x lineWidth:self.lineWidth];
    
    CAShapeLayer *subLayer = [CAShapeLayer layer];
    subLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    if (postion.openPoint.y >= postion.closePoint.y)
    {
        subLayer.strokeColor = RoseColor.CGColor;
        subLayer.fillColor = RoseColor.CGColor;
    }
    
    else
    {
        subLayer.strokeColor = DropColor.CGColor;
        subLayer.fillColor = DropColor.CGColor;
    }
    
    subLayer.path = path.CGPath;
    [path removeAllPoints];
    return subLayer;
}

#pragma mark draw

-(void)drawCandleSublayers
{
    __weak typeof(self) this = self;
    [_currentPostionArray enumerateObjectsUsingBlock:^(ZYWCandlePostionModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *subLayer = [this getShaperLayer:obj];
        [this.lineChartLayer addSublayer:subLayer];
    }];
}

-(void)drawMALineLayer
{
    NSMutableArray *pathsArray = [UIBezierPath drawLines:self.maPostionArray];

    ZYWLineModel *ma5Model = self.maPostionArray[0][0];
    ZYWLineModel *ma10Model = self.maPostionArray[1][0];
    ZYWLineModel *ma25Model = self.maPostionArray[2][0];
    
    UIBezierPath *ma5Path = pathsArray[0];
    self.ma5LineLayer.path = ma5Path.CGPath;
    self.ma5LineLayer.strokeColor = ma5Model.lineColor.CGColor;
    self.ma5LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma5LineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    UIBezierPath *ma10Path = pathsArray[1];
    self.ma10LineLayer.path = ma10Path.CGPath;
    self.ma10LineLayer.strokeColor = ma10Model.lineColor.CGColor;
    self.ma10LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma10LineLayer.contentsScale = [UIScreen mainScreen].scale;
    
    UIBezierPath *ma25Path = pathsArray[2];
    self.ma25LineLayer.path = ma25Path.CGPath;
    self.ma25LineLayer.strokeColor = ma25Model.lineColor.CGColor;
    self.ma25LineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.ma25LineLayer.contentsScale = [UIScreen mainScreen].scale;
}

-(void)drawMALayer
{
    [self calcuteMaLinePostion];
    [self drawMALineLayer];
}

-(void)drawTimeLayer
{
    [self.currentPostionArray enumerateObjectsUsingBlock:^(ZYWCandlePostionModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.isDrawDate)
        {
            //时间
            CATextLayer *layer = [self getTextLayer];
            layer.string = model.date;
            if (isEqualZero(model.highPoint.x))
            {
                layer.frame =  CGRectMake(0, self.height - self.timeLayerHeight - self.bottomMargin, 60, self.timeLayerHeight);
            }
            
            else
            {
                layer.position = CGPointMake(model.highPoint.x + self.candleWidth, self.height - self.timeLayerHeight/2 - self.bottomMargin);
                layer.bounds = CGRectMake(0, 0, 60, self.timeLayerHeight);
            }
            [self.timeLayer addSublayer:layer];
            
            //时间线
            CAShapeLayer *lineLayer = [self getAxispLayer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            path.lineWidth = self.lineWidth;
            lineLayer.lineWidth = self.lineWidth;
            
            [path moveToPoint:CGPointMake(model.highPoint.x + self.candleWidth/2 - self.lineWidth/2, 1*heightradio)];
            [path addLineToPoint:CGPointMake(model.highPoint.x + self.candleWidth/2 - self.lineWidth/2 ,self.height - self.timeLayerHeight - self.bottomMargin)];
            lineLayer.path = path.CGPath;
            [self.timeLayer addSublayer:lineLayer];
        }
    }];
}

-(void)drawAxisLine
{
    CGFloat klineWidth = (self.dataArray.count)*self.candleWidth+self.candleSpace*(self.dataArray.count);
    CAShapeLayer *bottomLayer = [self getAxispLayer];
    bottomLayer.lineWidth = self.lineWidth;
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    [bpath moveToPoint:CGPointMake(0, self.height - self.timeLayerHeight - self.bottomMargin)];
    [bpath addLineToPoint:CGPointMake(self.width, self.height - self.timeLayerHeight - self.bottomMargin)];
    bottomLayer.path = bpath.CGPath;
    [self.timeLayer addSublayer:bottomLayer];
    
    CAShapeLayer *centXLayer = [self getAxispLayer];
    UIBezierPath *xPath = [UIBezierPath bezierPath];
    [xPath moveToPoint:CGPointMake(0,self.centerY)];
    [xPath addLineToPoint:CGPointMake(klineWidth,self.centerY)];
    centXLayer.path = xPath.CGPath;
    centXLayer.lineWidth = self.lineWidth;
    [self.timeLayer addSublayer:centXLayer];
}

-(void)stockFill
{
    [self initConfig];
    [self initLayer];
    [self.superScrollView layoutIfNeeded];
    [self calcuteCandleWidth];
    [self updateWidth];
    [self drawKLine];
}

#pragma mark publicMethod

-(CATextLayer*)getTextLayer
{
    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.fontSize = 12.f;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor =
    [UIColor grayColor].CGColor;
    return layer;
}

-(CAShapeLayer*)getAxispLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor colorWithHexString:@"ededed"].CGColor;
    layer.fillColor = [[UIColor clearColor] CGColor];
//    [layer setLineDashPattern:
//     [NSArray arrayWithObjects:[NSNumber numberWithInt:2],
//      [NSNumber numberWithInt:1],nil]];
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}

-(void)calcuteCandleWidth
{
    if (_isAutoSetterWidth)
    {
         self.candleWidth = (self.superScrollView.width - (self.displayCount - 1) * self.candleSpace) / self.displayCount;
    }
}

-(void)drawKLine
{
    [self removeAllSubLayers];
    [self initCurrentDisplayModels];
    if (self.delegate && [self.delegate respondsToSelector: @selector(displayScreenleftPostion:startIndex:count:)])
    {
        [_delegate displayScreenleftPostion:self.leftPostion startIndex:self.currentStartIndex count:self.displayCount];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(displayLastModel:)])
    {
        ZYWCandleModel *lastModel = self.currentDisplayArray.lastObject;
        [_delegate displayLastModel:lastModel];
    }
    
    [self calcuteMaxAndMinValue];
    [self initLayer];
    [self initModelPositoin];
    [self drawCandleSublayers];
    [self drawMALayer];
    [self drawTimeLayer];
    [self drawAxisLine];
}

- (void)updateWidth
{
    CGFloat klineWidth = (self.dataArray.count)*self.candleWidth+self.candleSpace*(self.dataArray.count);
    if(klineWidth < self.superScrollView.width)
    {
        klineWidth = self.superScrollView.width;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(klineWidth));
    }];
    
    self.superScrollView.contentSize = CGSizeMake(klineWidth,0);
    [self layoutIfNeeded];
    self.superScrollView.contentOffset = CGPointMake(klineWidth - self.superScrollView.width, 0);
}

-(void)initConfig
{
    self.topMargin = 20;
    self.bottomMargin = 0;
    self.minHeight = 3;
    self.kvoEnable = YES;
   // self.isAutoSetterWidth = NO;
    self.timeLayerHeight = 15;
}

#pragma mark 长按获取坐标

-(CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion
{
    CGFloat localPostion = xPostion;
    NSInteger startIndex = (NSInteger)((localPostion - self.leftPostion) / (self.candleSpace + self.candleWidth));
    NSInteger arrCount = self.currentPostionArray.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        ZYWCandlePostionModel *kLinePositionModel = self.currentPostionArray[index];
        
        CGFloat minX = kLinePositionModel.highPoint.x - (self.candleSpace + self.candleWidth/2);
        CGFloat maxX = kLinePositionModel.highPoint.x + (self.candleSpace + self.candleWidth/2);
        
        if(localPostion > minX && localPostion < maxX)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewLongPressKLinePositionModel:kLineModel:)])
            {
                [self.delegate kLineMainViewLongPressKLinePositionModel:index kLineModel:self.currentDisplayArray[index]];
            }
            
            return CGPointMake(kLinePositionModel.highPoint.x, kLinePositionModel.openPoint.y);
        }
    }
    
    //最后一根线
    ZYWCandlePostionModel *lastPositionModel = self.currentPostionArray.lastObject;
   
    if (localPostion >= lastPositionModel.closePoint.x)
    {
        return CGPointMake(lastPositionModel.highPoint.x, lastPositionModel.openPoint.y);
    }
    
    //第一根线
    ZYWCandlePostionModel *firstPositionModel = self.currentPostionArray.firstObject;
    if (firstPositionModel.closePoint.x >= localPostion)
    {
        return CGPointMake(firstPositionModel.highPoint.x, firstPositionModel.openPoint.y);
    }
    
    return CGPointZero;
}

#pragma mark scrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x<0)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(displayMoreData)])
        {
            //记录上一次的偏移量
            self.previousOffsetX = _superScrollView.contentSize.width  -_superScrollView.contentOffset.x;
            [_delegate displayMoreData];
        }
    }
}

@end
