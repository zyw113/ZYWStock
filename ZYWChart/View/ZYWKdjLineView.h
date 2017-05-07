//
//  ZYWKdjLineView.h
//  ZYWChart
//
//  Created by 张有为 on 2017/4/20.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWBaseChartView.h"

@interface ZYWKdjLineView : ZYWBaseChartView

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat leftPostion;
@property (nonatomic, assign) CGFloat candleWidth;
@property (nonatomic, assign) CGFloat candleSpace;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger displayCount;

-(void)stockFill;

@end
