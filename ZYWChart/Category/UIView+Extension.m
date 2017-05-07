//
//  UIView+Extension.m
//  ZYWChart
//
//  Created by 张有为 on 2017/4/8.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

-(void)setX:(CGFloat)x
{
    CGRect tempF = self.frame;
    tempF.origin.x = x;
    self.frame = tempF;
}

-(CGFloat)x
{
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)y{
    CGRect tempF = self.frame;
    tempF.origin.y = y ;
    self.frame = tempF;
}

-(CGFloat)y
{
    return self.frame.origin.y;
}

-(void)setWidth:(CGFloat)width
{
    CGRect tempF = self.frame;
    tempF.size.width = width;
    self.frame = tempF;
}

-(void)setCenterX:(CGFloat)centerX
{
    CGPoint tempF = self.center;
    tempF.x = centerX;
    self.center = tempF;
}
-(CGFloat)centerX
{
    return self.center.x;
}

-(void)setCenterY:(CGFloat)centerY
{
    CGPoint tempF = self.center;
    tempF.y = centerY;
    self.center = tempF;
}
-(CGFloat)centerY
{
    return self.center.y;
}

-(CGFloat)width
{
    return self.frame.size.width;
}

-(void)setHeight:(CGFloat)height
{
    CGRect tempF = self.frame;
    tempF.size.height = height;
    self.frame = tempF;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

-(void)setSize:(CGSize)size
{
    CGRect tempF = self.frame;
    tempF.size = size;
    self.frame = tempF;
}
-(CGSize)size
{
    return self.frame.size;
}

@end
