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

ZYWLineData * computeMAData(NSArray *items,int period);
NSMutableArray* computeMACDData(NSArray *items);
NSMutableArray *computeKDJData(NSArray *items);
NSMutableArray *computeWRData(NSArray *items,int period);
