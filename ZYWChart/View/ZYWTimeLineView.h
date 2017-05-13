//
//  ZYWTimeLineView.h
//  ZYWChart
//
//  Created by 张有为 on 2017/5/11.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYWTimeLineModel.h"

@interface ZYWTimeLineView : ZYWBaseChartView

@property (nonatomic,assign) NSInteger timesCount;
@property (nonatomic,strong) UIColor *fillColor;
@property (nonatomic,strong) NSArray<__kindof ZYWTimeLineModel*> *dataArray;
-(void)stockFill;

@end
