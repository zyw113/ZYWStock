//
//  ZYWSlipLineView.m
//  ZYWChart
//
//  Created by 张有为 on 2016/12/27.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZYWSlipLineView.h"
#import "KVOController.h"

@interface ZYWSlipLineView ()

@property (nonatomic,strong) UIScrollView *superScrollView;
@property (nonatomic,strong) NSMutableArray *modelPostionArray;
@property (nonatomic,strong) CAShapeLayer *lineChartLayer;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic,strong) CAShapeLayer *xLayer;
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,assign) NSInteger curentModelIndex;

@end

@implementation ZYWSlipLineView

#pragma mark setter

-(NSMutableArray*)modelPostionArray
{
    if (!_modelPostionArray)
    {
        _modelPostionArray = [NSMutableArray array];
    }
    return _modelPostionArray;
}

#pragma mark draw

-(void)drawLineLayer
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
    [self startAnimation];
}

#pragma mark animation

-(void)startAnimation
{
    CABasicAnimation*pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0f;
    pathAnimation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue=@0.0f;
    pathAnimation.toValue=@(1);
    [self.lineChartLayer addAnimation:pathAnimation forKey:nil];
}

#pragma mark postion

-(void)getModelPostion
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

#pragma mark baseMethod

-(void)initConfig
{
    self.lineSpace = DEVICE_WIDTH/10.f ;
    CGFloat  contentWidth = self.lineSpace*(_dataArray.count - 1) + self.leftMargin + self.rightMargin;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(contentWidth);
    }];
    [self.superScrollView setContentSize:CGSizeMake(contentWidth, 0)];
    
    NSNumber *min  = [_dataArray valueForKeyPath:@"@min.floatValue"];
    NSNumber *max = [_dataArray valueForKeyPath:@"@max.floatValue"];
    self.maxY = [max floatValue];
    self.minY  = [min floatValue];
    self.scaleY = (self.height - self.topMargin - self.bottomMargin)/(self.maxY-self.minY);
    
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressGesture:)];
    [self addGestureRecognizer:self.longPress];
}

-(void)addTextLabelAndLayer
{
    _textLabel = [UILabel new];
    [self.superScrollView addSubview:_textLabel];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.backgroundColor = [UIColor colorWithHexString:@"a8a8a8"];
    _textLabel.bounds = CGRectMake(0, 0, 70, 20);
    _textLabel.hidden = YES;
    
    self.xLayer = [CAShapeLayer layer];
    self.xLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.xLayer.lineWidth = 1;
    self.xLayer.lineCap = kCALineCapRound;
    self.xLayer.lineJoin = kCALineJoinRound;
    self.xLayer.strokeColor = [UIColor colorWithHexString:@"FFA500"].CGColor;
    self.xLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.layer addSublayer:self.xLayer];
}

-(void)stockFill
{
    [self initConfig];
    [self getModelPostion];
    [self drawLineLayer];
    [self addTextLabelAndLayer];
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.superScrollView = (UIScrollView*)self.superview;
}

#pragma mark 长按手势

-(void)LongPressGesture:(UILongPressGestureRecognizer*)longPress
{
    static CGFloat oldPositionX = 0;
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state)
    {
        CGPoint location = [longPress locationInView:self.superScrollView];
        CGPoint point = [self getLongPressModelPostionWithXPostion:location.x];
        
        UIBezierPath *xPath = [UIBezierPath bezierPath];
        [xPath moveToPoint:CGPointMake(point.x,0)];
        [xPath addLineToPoint:CGPointMake(point.x,self.height)];
        self.xLayer.path = xPath.CGPath;
       _textLabel.center = CGPointMake(point.x, _textLabel.height/2);
        if (_curentModelIndex == _modelPostionArray.count - 1)
        {
             _textLabel.center = CGPointMake(point.x-_textLabel.width/2, _textLabel.height/2);
        }
        
       else if (_curentModelIndex == 0)
       {
           _textLabel.center = CGPointMake(self.leftMargin + _textLabel.width/2, _textLabel.height/2);
       }
        
        NSString *text = _dataArray[_curentModelIndex];
        _textLabel.text = [NSString stringWithFormat:@"数值: %@",text];
        _textLabel.hidden = NO;
        self.superScrollView.scrollEnabled = NO;
        oldPositionX = location.x;
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        self.xLayer.path = [UIBezierPath bezierPath].CGPath;
        _textLabel.hidden = YES;
        oldPositionX = 0;
        self.superScrollView.scrollEnabled = YES;
    }
}

#pragma mark 长按获取坐标

-(CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion
{
    for (NSInteger i = 1; i<self.modelPostionArray.count; i++) {
        ZYWLineModel *model = self.modelPostionArray[i];
        CGFloat minX = fabs(model.xPosition - self.lineSpace);
        CGFloat maxX = model.xPosition + self.lineSpace;
        
        if (xPostion - self.leftMargin >= minX && xPostion - self.leftMargin  < maxX)
        {
            if (xPostion >= self.width - self.rightMargin)
            {
                _curentModelIndex = _modelPostionArray.count  - 1;
                break;
            }
            
            else if (xPostion <= self.lineSpace)
            {
                _curentModelIndex = 0;
                break;
            }
            
            _curentModelIndex = i;
            return CGPointMake(model.xPosition , model.yPosition);
        }
    }
    ZYWLineModel *lastModel = self.modelPostionArray[_curentModelIndex];
    return CGPointMake(lastModel.xPosition, lastModel.yPosition);
}

@end

