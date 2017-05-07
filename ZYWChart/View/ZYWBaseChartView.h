//
//  ZYWBaseChartView.h
//  ZYWChart
//
//  Created by 张有为 on 2016/12/17.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYWBaseChartView : UIView
{
    CGFloat  _maxY;
    CGFloat  _minY;
    CGFloat  _maxX;
    CGFloat  _minX;
    CGFloat  _scaleY;
    CGFloat  _scaleX;
    CGFloat  _lineWidth;
    CGFloat  _lineSpace;
    CGFloat  _leftMargin;
    CGFloat  _rightMargin;
    CGFloat  _topMargin;
    CGFloat  _bottomMargin;
    UIColor  *_lineColor;
}

@property (nonatomic,assign) CGFloat maxY;
@property (nonatomic,assign) CGFloat minY;
@property (nonatomic,assign) CGFloat maxX;
@property (nonatomic,assign) CGFloat minX;
@property (nonatomic,assign) CGFloat scaleY;
@property (nonatomic,assign) CGFloat scaleX;
@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,assign) CGFloat lineSpace;
@property (nonatomic,assign) CGFloat leftMargin;
@property (nonatomic,assign) CGFloat rightMargin;
@property (nonatomic,assign) CGFloat topMargin;
@property (nonatomic,assign) CGFloat bottomMargin;
@property (nonatomic,strong) UIColor *lineColor;

@end
