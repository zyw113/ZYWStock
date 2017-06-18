//
//  ZYWLineView.m
//  ZYWChart
//
//  Created by 张有为 on 2016/12/27.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZYWLineView.h"

@interface ZYWLineView ()

@property (nonatomic,strong) NSMutableArray *modelPostionArray;
@property (nonatomic, strong) CAShapeLayer *lineChartLayer;

@end

@implementation ZYWLineView

#pragma mark setter

- (NSMutableArray*)modelPostionArray
{
    if (!_modelPostionArray)
    {
        _modelPostionArray = [NSMutableArray array];
    }
    return _modelPostionArray;
}

#pragma mark draw

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self draw];
}

- (void)drawLineLayer
{
    UIBezierPath *path = [UIBezierPath drawLine:self.modelPostionArray];
    self.lineChartLayer = [CAShapeLayer layer];
    self.lineChartLayer.path = path.CGPath;
    self.lineChartLayer.strokeColor = self.lineColor.CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];

    self.lineChartLayer.lineWidth = self.lineWidth;
    self.lineChartLayer.lineCap = kCALineCapRound;
    self.lineChartLayer.lineJoin = kCALineJoinRound;
    self.lineChartLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.lineChartLayer];
 
    if (_isFillColor)
    {
        ZYWLineModel *lastPoint = _modelPostionArray.lastObject;
        [path addLineToPoint:CGPointMake(lastPoint.xPosition,self.height - self.topMargin)];
        [path addLineToPoint:CGPointMake(self.leftMargin, self.height - self.topMargin)];
        path.lineWidth = 0;
        [_fillColor setFill];
        [path fill];
        [path stroke];
        [path closePath];
    }
    [self startAnimation];
}

- (void)startAnimation
{
    CABasicAnimation*pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0f;
    pathAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue=@0.0f;
    pathAnimation.toValue=@(1);
    [self.lineChartLayer addAnimation:pathAnimation forKey:nil];
}

- (void)initModelPostion
{
    __weak typeof(self) this = self;
    [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = [_dataArray[idx] floatValue];
        CGFloat xPostion = this.lineSpace*idx + this.leftMargin;
        CGFloat yPostion = (this.maxY - value)*this.scaleY + this.topMargin;
        ZYWLineModel *lineModel = [ZYWLineModel initPositon:xPostion yPosition:yPostion color:this.lineColor];
        [this.modelPostionArray addObject:lineModel];
    }];
}

-(void)initConfig
{
    self.lineSpace = (DEVICE_WIDTH - self.leftMargin - self.rightMargin)/(_dataArray.count-1) ;
    NSNumber *min  = [_dataArray valueForKeyPath:@"@min.floatValue"];
    NSNumber *max = [_dataArray valueForKeyPath:@"@max.floatValue"];
    self.maxY = [max floatValue];
    self.minY  = [min floatValue];
    self.scaleY = (self.height - self.topMargin - self.bottomMargin)/(self.maxY-self.minY);
}

- (void)draw
{
    [self initConfig];
    [self initModelPostion];
    [self drawLineLayer];
}

- (void)stockFill
{
    [self setNeedsDisplay];
}

@end
