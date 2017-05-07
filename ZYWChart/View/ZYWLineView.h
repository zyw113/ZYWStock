//
//  ZYWLineView.h
//  ZYWChart
//
//  Created by 张有为 on 2016/12/27.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZYWBaseChartView.h"

@interface ZYWLineView : ZYWBaseChartView

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UIColor *fillColor;
@property (nonatomic,assign) BOOL isFillColor;

-(void)stockFill;

@end
