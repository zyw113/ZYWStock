//
//  UIBezierPath+Draw.h
//  ZYWChart
//
//  Created by 张有为 on 2017/4/8.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Draw)

/**
 绘制单个折线

 @param linesArray 单个折线数组
 @return 绘制的path
 */
+ (UIBezierPath*)drawLine:(NSMutableArray*)linesArray;

/**
 绘制多个折线
 
 @param linesArray 多个折线数组
 @return 绘制的path数组
 */
+ (NSMutableArray<__kindof UIBezierPath*>*)drawLines:(NSMutableArray<NSMutableArray*>*)linesArray;

/**
 绘制蜡烛图

 @param open 开盘价
 @param close 收盘价
 @param high 最高价
 @param low 最低价
 @param candleWidth 蜡烛线宽度
 @param rect 绘制区域
 @param xPostion 绘制x坐标
 @param lineWidth 直线宽度
 @return 绘制的path
 */
+ (UIBezierPath*)drawKLine:(CGFloat)open close:(CGFloat)close high:(CGFloat)high low:(CGFloat)low candleWidth:(CGFloat)candleWidth rect:(CGRect)rect xPostion:(CGFloat)xPostion lineWidth:(CGFloat)lineWidth;

@end
