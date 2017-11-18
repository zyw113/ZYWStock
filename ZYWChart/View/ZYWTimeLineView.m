//
//  ZYWTimeLineView.m
//  ZYWChart
//
//  Created by 张有为 on 2017/5/11.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWTimeLineView.h"
#import "ZYWLineModel.h"

@interface ZYWTimeLineView()

@property (nonatomic,strong) NSMutableArray *modelPostionArray;
@property (nonatomic,strong) CAShapeLayer *lineChartLayer;
@property (nonatomic,strong) CAShapeLayer *boxLayer;
@property (nonatomic,assign) CGFloat boxLineWidth;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic,strong) CAShapeLayer *xLayer;
@property (nonatomic,strong) CAShapeLayer *yLayer;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *valueLabel;
@property (nonatomic,assign) NSInteger curentModelIndex;
@property (nonatomic,strong) CAShapeLayer *timeLayer;
@property (nonatomic,assign) CGFloat timeLayerHeight;

@end

@implementation ZYWTimeLineView

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

- (void)draw
{
    [self initConfig];
    [self initModelPostion];
    [self drawLineLayer];
    [self drawBoxLayer];
    [self addTimeLayer];
    [self addAxisLayer];
    [self addLabels];
}

- (void)stockFill
{
    [self setNeedsDisplay];
}

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
    ZYWLineModel *lastPoint = _modelPostionArray.lastObject;
    [path addLineToPoint:CGPointMake(lastPoint.xPosition,self.height - self.topMargin - self.timeLayerHeight)];
    [path addLineToPoint:CGPointMake(self.leftMargin, self.height - self.topMargin - self.timeLayerHeight)];
    path.lineWidth = 0;
    [_fillColor setFill];
    [path fill];
    [path stroke];
    [path closePath];
    [self startRoundAnimation];
}

- (void)drawBoxLayer
{
    self.boxLayer = [CAShapeLayer layer];
    self.boxLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.boxLayer.contentsScale = [UIScreen mainScreen].scale;
    self.boxLayer.strokeColor = [UIColor clearColor].CGColor;
    self.boxLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.boxLayer];
    
    CAShapeLayer *leftLayer = [self getAxispLayer];
    leftLayer.lineWidth = self.boxLineWidth;
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    [leftPath moveToPoint:CGPointMake(self.leftMargin,0)];
    [leftPath addLineToPoint:CGPointMake(self.leftMargin, self.height - self.bottomMargin - self.timeLayerHeight)];
    leftLayer.path = leftPath.CGPath;
    [self.boxLayer addSublayer:leftLayer];
    
    CAShapeLayer *rightLayer = [self getAxispLayer];
    rightLayer.lineWidth = self.boxLineWidth;
    UIBezierPath *rightPath = [UIBezierPath bezierPath];
    [rightPath moveToPoint:CGPointMake(self.width - self.rightMargin,0)];
    [rightPath addLineToPoint:CGPointMake(self.width - self.rightMargin, self.height - self.bottomMargin - self.timeLayerHeight)];
    rightLayer.path = rightPath.CGPath;
    [self.boxLayer addSublayer:rightLayer];

    CAShapeLayer *topLayer = [self getAxispLayer];
    topLayer.lineWidth = self.boxLineWidth;
    UIBezierPath *topPath = [UIBezierPath bezierPath];
    [topPath moveToPoint:CGPointMake(self.leftMargin,0)];
    [topPath addLineToPoint:CGPointMake(self.width - self.rightMargin, 0)];
    topLayer.path = topPath.CGPath;
    [self.boxLayer addSublayer:topLayer];
    
    CAShapeLayer *bottomLayer = [self getAxispLayer];
    bottomLayer.lineWidth = self.boxLineWidth;
    UIBezierPath *bottomPath = [UIBezierPath bezierPath];
    [bottomPath moveToPoint:CGPointMake(self.leftMargin,self.height - self.bottomMargin - self.timeLayerHeight)];
    [bottomPath addLineToPoint:CGPointMake(self.width - self.rightMargin,self.height - self.bottomMargin - self.timeLayerHeight)];
    bottomLayer.path = bottomPath.CGPath;
    [self.boxLayer addSublayer:bottomLayer];
}

- (void)addAxisLayer
{
    self.xLayer = [CAShapeLayer layer];
    self.xLayer.lineWidth = 1;
    self.xLayer.lineCap = kCALineCapRound;
    self.xLayer.lineJoin = kCALineJoinRound;
    self.xLayer.strokeColor = [UIColor colorWithHexString:@"FFA500"].CGColor;
    self.xLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.layer addSublayer:self.xLayer];
    
    self.yLayer = [CAShapeLayer layer];
    self.yLayer.lineWidth = 1;
    self.yLayer.lineCap = kCALineCapRound;
    self.yLayer.lineJoin = kCALineJoinRound;
    self.yLayer.strokeColor = [UIColor colorWithHexString:@"FFA500"].CGColor;
    self.yLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.layer addSublayer:self.yLayer];
    
    CGPoint point = [self getLastModelPostion];
    
    UIBezierPath *xPath = [UIBezierPath bezierPath];
    [xPath moveToPoint:CGPointMake(point.x,0)];
    [xPath addLineToPoint:CGPointMake(point.x,self.height - self.timeLayerHeight)];
    self.xLayer.path = xPath.CGPath;
    
    UIBezierPath *yPath = [UIBezierPath bezierPath];
    [yPath moveToPoint:CGPointMake(self.leftMargin,point.y)];
    [yPath addLineToPoint:CGPointMake(self.width - self.rightMargin,point.y)];
    self.yLayer.path = yPath.CGPath;
    
    for (NSInteger i = 1; i<3 ;i++)
    {
        CGFloat y = (self.height - self.timeLayerHeight) /3*(i);
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = widthradio;
        layer.strokeColor = [UIColor colorWithHexString:@"ededed"].CGColor;
        [layer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:1],nil]];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.leftMargin,y)];
        [path addLineToPoint:CGPointMake(self.width - self.rightMargin,y)];
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
    }
    
    for (NSInteger i = 1;i < 3;i++)
    {
        CGFloat x = self.width/3*(i);
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = heightradio;
        layer.strokeColor = [UIColor colorWithHexString:@"ededed"].CGColor;
        [layer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:1],nil]];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(x,0)];
        [path addLineToPoint:CGPointMake(x,self.height - self.timeLayerHeight)];
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
    }
}

- (void)addTimeLayer
{
    self.timeLayer = [CAShapeLayer layer];
    self.timeLayer.contentsScale = [UIScreen mainScreen].scale;
    self.timeLayer.strokeColor = [UIColor clearColor].CGColor;
    self.timeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.timeLayer];
   
    for (NSInteger i = 1;i<3;i++)
    {
        ZYWTimeLineModel *model = self.dataArray[self.dataArray.count*i/3];
        CGFloat x = self.width/3*i;
        CATextLayer *layer = [self getTextLayer];
         layer.string = model.currtTime;
        layer.position = CGPointMake(x,self.height - _timeLayerHeight/2);
        layer.bounds = CGRectMake(0, 0, 60, self.timeLayerHeight);
        [self.timeLayer addSublayer:layer];
    }
}

- (void)addLabels
{
    _timeLabel = [self createLabel];
    [self addSubview:_timeLabel];
    _timeLabel.bounds = CGRectMake(0, 0, 100, 20);
    
    _valueLabel = [self createLabel];
    [self addSubview:_valueLabel];
    _valueLabel.bounds = CGRectMake(0, 0, 100, 20);
}

#pragma mark Animation

- (void)startRoundAnimation
{
    ZYWLineModel *nextPoint = [_modelPostionArray lastObject];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(nextPoint.xPosition, nextPoint.yPosition) radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor colorWithHexString:@"d96c9c"].CGColor;
    [self.layer addSublayer:layer];
    
    NSInteger pulsingCount = 1;
    double animationDuration = 2;
    CALayer * animationLayer = [CALayer layer];
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(nextPoint.xPosition-5,nextPoint.yPosition - 5, 10, 10);
        pulsingLayer.borderColor = [UIColor colorWithHexString:@"e73785"].CGColor;
        pulsingLayer.borderWidth = 1;
        pulsingLayer.cornerRadius = 5;
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1;
        scaleAnimation.toValue = @2.2;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.layer addSublayer:animationLayer];
}

#pragma mark init

- (void)initModelPostion
{
    _modelPostionArray = [NSMutableArray array];
    for (NSInteger i = 0;i<_dataArray.count;i++)
    {
        ZYWTimeLineModel *model = [_dataArray objectAtIndex:i];
        CGFloat xPostion = (self.lineWidth)*i + self.leftMargin + self.boxLineWidth;
        CGFloat yPostion = (self.maxY - model.lastPirce)*self.scaleY;
        ZYWLineModel *postitionModel = [ZYWLineModel initPositon:xPostion yPosition:yPostion color:[UIColor redColor]];
        [_modelPostionArray addObject:postitionModel];
    }
}

- (void)initConfig
{
    self.boxLineWidth = 1;
    self.timeLayerHeight = 20;
    self.lineWidth  = (self.width - self.leftMargin - self.rightMargin )/self.timesCount;
    self.maxY = CGFLOAT_MIN;
    self.minY = CGFLOAT_MAX;
    CGFloat offset = CGFLOAT_MIN;
    for (NSInteger i = 0; i < _dataArray.count; i++)
    {
        ZYWTimeLineModel *model = [_dataArray objectAtIndex:i];
        offset = offset >fabs(model.lastPirce-model.preClosePx) ? offset:fabs(model.lastPirce-model.preClosePx);
    }
    
    self.maxY =((ZYWTimeLineModel *)[_dataArray firstObject]).preClosePx + offset;
    self.minY =((ZYWTimeLineModel*)[_dataArray firstObject]).preClosePx - offset;
    self.scaleY = (self.height - self.topMargin - self.bottomMargin - self.boxLineWidth*2 - self.timeLayerHeight)/(self.maxY-self.minY);

    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressGesture:)];
    [self addGestureRecognizer:self.longPress];
}

#pragma mark 长按手势

- (void)LongPressGesture:(UILongPressGestureRecognizer*)longPress
{
    static CGFloat oldPositionX = 0;
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state)
    {
        CGPoint location = [longPress locationInView:self];
        CGPoint point = [self getLongPressModelPostionWithXPostion:location.x];
     
        UIBezierPath *xPath = [UIBezierPath bezierPath];
        [xPath moveToPoint:CGPointMake(point.x,0)];
        [xPath addLineToPoint:CGPointMake(point.x,self.height - self.timeLayerHeight)];
        self.xLayer.path = xPath.CGPath;
        
        UIBezierPath *yPath = [UIBezierPath bezierPath];
        [yPath moveToPoint:CGPointMake(self.leftMargin,point.y)];
        [yPath addLineToPoint:CGPointMake(self.width - self.rightMargin,point.y)];
        self.yLayer.path = yPath.CGPath;

        _timeLabel.center = CGPointMake(point.x, _timeLabel.height/2);
        _valueLabel.center = CGPointMake(_valueLabel.width/2 + self.leftMargin, point.y);
        if (_timeLabel.center.x  + _timeLabel.width/2 >= self.width - self.rightMargin)
        {
            _timeLabel.center = CGPointMake(self.width-_timeLabel.width/2 - self.rightMargin, _timeLabel.height/2);
        }
        
        else if (_timeLabel.center.x  - _timeLabel.width/2 <= self.leftMargin)
        {
            _timeLabel.center = CGPointMake(self.leftMargin + _timeLabel.width/2, _timeLabel.height/2);
        }
        
        ZYWTimeLineModel *model = _dataArray[_curentModelIndex];
        _timeLabel.text = [NSString stringWithFormat:@"%@",model.currtTime];
        _valueLabel.text = [NSString stringWithFormat:@"%@",model.rate];
        _timeLabel.hidden = NO;
        _valueLabel.hidden = NO;
        oldPositionX = location.x;
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        self.xLayer.path = [UIBezierPath bezierPath].CGPath;
         self.yLayer.path = [UIBezierPath bezierPath].CGPath;
        _timeLabel.hidden = YES;
        _valueLabel.hidden = YES;
        oldPositionX = 0;
    }
}

#pragma mark 长按获取坐标

- (CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion
{
    for (NSInteger i = 0; i<self.modelPostionArray.count; i++) {
        ZYWLineModel *model = self.modelPostionArray[i];
        CGFloat minX = fabs(model.xPosition - self.lineWidth);
        CGFloat maxX = model.xPosition + self.lineWidth;
        
        if (xPostion - self.leftMargin >= minX && xPostion - self.rightMargin  < maxX)
        {
            _curentModelIndex = i;
            return CGPointMake(model.xPosition , model.yPosition);
        }
    }
    
    ZYWLineModel *lastPoint = _modelPostionArray.lastObject;
    if (xPostion >= lastPoint.xPosition)
    {
        _curentModelIndex = _modelPostionArray.count - 1;
        return CGPointMake(lastPoint.xPosition, lastPoint.yPosition);
    }
    
    ZYWLineModel *firstPoint = _modelPostionArray.firstObject;
    if (fabs(xPostion - self.leftMargin)  <= firstPoint.xPosition)
    {
        _curentModelIndex = 0;
        return CGPointMake(firstPoint.xPosition, firstPoint.yPosition);
    }
    return CGPointZero;
}

- (CGPoint)getLastModelPostion
{
    if (_modelPostionArray.count>0)
    {
        ZYWLineModel *lastPoint = _modelPostionArray.lastObject;
        return CGPointMake(lastPoint.xPosition, lastPoint.yPosition);
    }
    return CGPointZero;
}

#pragma mark privateMethod

- (UILabel*)createLabel
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor colorWithHexString:@"a8a8a8"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"353535"];
    label.hidden = YES;
    return label;
}

- (CAShapeLayer*)getAxispLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor colorWithHexString:@"ededed"].CGColor;
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}

- (CATextLayer*)getTextLayer
{
    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.fontSize = 12.f;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor =
    [UIColor grayColor].CGColor;
    return layer;
}
@end
