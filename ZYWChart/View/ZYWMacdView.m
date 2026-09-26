//
//  ZYWMacdView.m
//  ZYWChart
//
//  Created by 张有为 on 2017/3/13.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWMacdView.h"

/// MACD柱的最小高度, 保证数值接近 0 时仍可见
static const CGFloat ZYWMacdMinBarHeight = 1.f;

@interface ZYWMacdView ()

/// 常驻图层, 每帧只更新 path
@property (nonatomic, strong) CAShapeLayer *riseBarLayer;
@property (nonatomic, strong) CAShapeLayer *fallBarLayer;
@property (nonatomic, strong) CAShapeLayer *deaLayer;
@property (nonatomic, strong) CAShapeLayer *diffLayer;

@property (nonatomic, strong) NSMutableArray<__kindof ZYWMacdModel *> *displayModels;

@end

@implementation ZYWMacdView

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
    _topMargin = 5;
    _bottomMargin = 5;
    _displayModels = [NSMutableArray array];

    _riseBarLayer = [self addShapeLayerWithColor:RoseColor filled:YES];
    _fallBarLayer = [self addShapeLayerWithColor:DropColor filled:YES];
    _deaLayer = [self addShapeLayerWithColor:UIColor.redColor filled:NO];
    _diffLayer = [self addShapeLayerWithColor:UIColor.blackColor filled:NO];
}

- (CAShapeLayer *)addShapeLayerWithColor:(UIColor *)color filled:(BOOL)filled
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.contentsScale = UIScreen.mainScreen.scale;
    layer.strokeColor = color.CGColor;
    layer.fillColor = filled ? color.CGColor : UIColor.clearColor.CGColor;
    layer.lineWidth = self.lineWidth;
    [self.layer addSublayer:layer];
    return layer;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    _deaLayer.lineWidth = lineWidth;
    _diffLayer.lineWidth = lineWidth;
}

#pragma mark - 可视区域

- (void)updateDisplayModels
{
    [self.displayModels removeAllObjects];
    if (self.dataArray.count == 0)
    {
        return;
    }

    NSInteger startIndex = MIN(MAX(self.startIndex, 0), (NSInteger)self.dataArray.count - 1);
    NSInteger length = MIN(self.displayCount, (NSInteger)self.dataArray.count - startIndex);
    if (length <= 0)
    {
        return;
    }
    [self.displayModels addObjectsFromArray:[self.dataArray subarrayWithRange:NSMakeRange(startIndex, length)]];
}

- (void)updateValueRange
{
    CGFloat maxValue = -CGFLOAT_MAX;
    CGFloat minValue = CGFLOAT_MAX;
    for (ZYWMacdModel *model in self.displayModels)
    {
        maxValue = MAX(maxValue, MAX(model.dea, MAX(model.diff, model.macd)));
        minValue = MIN(minValue, MIN(model.dea, MIN(model.diff, model.macd)));
    }

    if (maxValue - minValue < 0.5)
    {
        maxValue += 0.5;
        minValue -= 0.5;
    }

    self.maxY = maxValue;
    self.minY = minValue;
    //scaleY 为每个单位数值对应的点数
    self.scaleY = (self.height - self.topMargin - self.bottomMargin) / (maxValue - minValue);
}

- (CGFloat)yPositionOfValue:(CGFloat)value
{
    return (self.maxY - value) * self.scaleY + self.topMargin;
}

#pragma mark - 绘制

- (void)stockFill
{
    [self layoutIfNeeded];
    [self updateDisplayModels];
    if (self.displayModels.count == 0)
    {
        return;
    }

    [self updateValueRange];

    CGMutablePathRef risePath = CGPathCreateMutable();
    CGMutablePathRef fallPath = CGPathCreateMutable();
    CGMutablePathRef deaPath = CGPathCreateMutable();
    CGMutablePathRef diffPath = CGPathCreateMutable();

    CGFloat zeroY = [self yPositionOfValue:0.f];
    CGFloat step = self.candleWidth + self.candleSpace;

    [self.displayModels enumerateObjectsUsingBlock:^(ZYWMacdModel *model, NSUInteger index, BOOL *stop) {
        CGFloat left = self.leftMargin + (self.startIndex + index) * step;
        CGFloat centerX = left + self.candleWidth / 2.f;

        //MACD柱
        CGFloat valueY = [self yPositionOfValue:model.macd];
        CGFloat height = MAX(fabs(valueY - zeroY), ZYWMacdMinBarHeight);
        CGRect bar = CGRectMake(left, model.macd > 0 ? zeroY - height : zeroY, self.candleWidth, height);
        CGPathAddRect(model.macd > 0 ? risePath : fallPath, NULL, bar);

        //DEA 与 DIFF 曲线
        CGFloat deaY = [self yPositionOfValue:model.dea];
        CGFloat diffY = [self yPositionOfValue:model.diff];
        if (index == 0)
        {
            CGPathMoveToPoint(deaPath, NULL, centerX, deaY);
            CGPathMoveToPoint(diffPath, NULL, centerX, diffY);
        }
        else
        {
            CGPathAddLineToPoint(deaPath, NULL, centerX, deaY);
            CGPathAddLineToPoint(diffPath, NULL, centerX, diffY);
        }
    }];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.riseBarLayer.path = risePath;
    self.fallBarLayer.path = fallPath;
    self.deaLayer.path = deaPath;
    self.diffLayer.path = diffPath;
    [CATransaction commit];

    CGPathRelease(risePath);
    CGPathRelease(fallPath);
    CGPathRelease(deaPath);
    CGPathRelease(diffPath);
}

@end
