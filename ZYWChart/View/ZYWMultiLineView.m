//
//  ZYWMultiLineView.m
//  ZYWChart
//
//  Created by 张有为 on 2017/5/3.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWMultiLineView.h"
#import "ZYWLineUntil.h"

@interface ZYWMultiLineView ()

/// 折线图层池, 数量按数据源中的折线条数增长
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *lineLayers;

@end

@implementation ZYWMultiLineView

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
    _topMargin = 10;
    _bottomMargin = 5;
    _lineLayers = [NSMutableArray array];
}

- (CAShapeLayer *)lineLayerAtIndex:(NSUInteger)index
{
    if (index < self.lineLayers.count)
    {
        return self.lineLayers[index];
    }

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.contentsScale = UIScreen.mainScreen.scale;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.lineWidth = self.lineWidth;
    layer.fillColor = UIColor.clearColor.CGColor;
    [self.layer addSublayer:layer];
    [self.lineLayers addObject:layer];
    return layer;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    for (CAShapeLayer *layer in self.lineLayers)
    {
        layer.lineWidth = lineWidth;
    }
}

#pragma mark - 可视区域

/// 可视区域在整条折线中的范围, 越界时自动收窄
- (NSRange)visibleRangeInLine:(ZYWLineData *)lineData
{
    NSUInteger count = lineData.data.count;
    if (count == 0 || self.displayCount <= 0)
    {
        return NSMakeRange(0, 0);
    }
    NSUInteger location = MIN((NSUInteger)MAX(self.startIndex, 0), count);
    NSUInteger length = MIN((NSUInteger)self.displayCount, count - location);
    return NSMakeRange(location, length);
}

- (BOOL)updateValueRange
{
    CGFloat maxValue = -CGFLOAT_MAX;
    CGFloat minValue = CGFLOAT_MAX;
    BOOL hasValue = NO;

    for (ZYWLineData *lineData in self.dataArray)
    {
        NSRange range = [self visibleRangeInLine:lineData];
        for (NSUInteger index = range.location; index < NSMaxRange(range); index++)
        {
            ZYWLineUntil *until = lineData.data[index];
            maxValue = MAX(maxValue, until.value);
            minValue = MIN(minValue, until.value);
            hasValue = YES;
        }
    }

    if (!hasValue)
    {
        return NO;
    }

    if (maxValue - minValue < 0.5)
    {
        maxValue += 0.5;
        minValue -= 0.5;
    }

    self.maxY = maxValue;
    self.minY = minValue;
    self.scaleY = (self.height - self.topMargin - self.bottomMargin) / (maxValue - minValue);
    return YES;
}

#pragma mark - 绘制

- (void)stockFill
{
    [self layoutIfNeeded];
    if (self.dataArray.count == 0 || ![self updateValueRange])
    {
        return;
    }

    CGFloat step = self.candleWidth + self.candleSpace;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    [self.dataArray enumerateObjectsUsingBlock:^(ZYWLineData *lineData, NSUInteger line, BOOL *stop) {
        NSRange range = [self visibleRangeInLine:lineData];
        CGMutablePathRef path = CGPathCreateMutable();
        for (NSUInteger index = 0; index < range.length; index++)
        {
            ZYWLineUntil *until = lineData.data[range.location + index];
            CGFloat x = self.leftMargin + (self.startIndex + index) * step + self.candleWidth / 2.f;
            CGFloat y = (self.maxY - until.value) * self.scaleY + self.topMargin;
            if (index == 0)
            {
                CGPathMoveToPoint(path, NULL, x, y);
            }
            else
            {
                CGPathAddLineToPoint(path, NULL, x, y);
            }
        }

        CAShapeLayer *layer = [self lineLayerAtIndex:line];
        layer.strokeColor = lineData.color.CGColor;
        layer.path = path;
        layer.hidden = NO;
        CGPathRelease(path);
    }];

    for (NSUInteger index = self.dataArray.count; index < self.lineLayers.count; index++)
    {
        self.lineLayers[index].hidden = YES;
    }

    [CATransaction commit];
}

@end
