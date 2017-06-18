//
//  ZYWMacdView.h
//  ZYWChart
//
//  Created by 张有为 on 2017/3/13.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYWMacdModel.h"

@interface ZYWMacdView : ZYWBaseChartView

@property (nonatomic,strong) NSMutableArray <__kindof ZYWMacdModel*>*dataArray;

@property (nonatomic,assign) CGFloat    leftPostion;
@property (nonatomic,assign) NSInteger startIndex;
@property (nonatomic,assign) NSInteger displayCount;
@property (nonatomic,assign) CGFloat    candleWidth;
@property (nonatomic,assign) CGFloat    candleSpace;

- (void)stockFill;

@end
