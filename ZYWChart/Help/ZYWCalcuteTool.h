//
//  ZYWCalcuteTool.h
//  ZYWChart
//
//  Created by limc on 12/26/13.
//  Copyright (c) 2013 limc. All rights reserved.
//

#import "ta_libc.h"
#import "ZYWLineData.h"
#import "ZYWLineUntil.h"

/**
 计算移动平均线(SMA)

 数据源与 outValues 均按时间正序(旧 -> 新)排列, 内部使用滑动窗口, 复杂度 O(n)。
 前 period-1 个点不足一个周期, 取已有数据的均值, 保证均线从最左侧开始连续。

 @param values    收盘价数组
 @param count     数据个数
 @param period    均线周期
 @param outValues 输出缓冲区, 长度需为 count
 */
void ZYWComputeSMA(const CGFloat *values, NSUInteger count, NSUInteger period, CGFloat *outValues);

ZYWLineData * computeMAData(NSArray *items,int period);
NSMutableArray* computeMACDData(NSArray *items);
NSMutableArray *computeKDJData(NSArray *items);
NSMutableArray *computeWRData(NSArray *items,int period);
