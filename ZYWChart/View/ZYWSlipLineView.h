//
//  ZYWSlipLineView.h
//  ZYWChart
//
//  Created by 张有为 on 2016/12/27.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZYWBaseChartView.h"

@interface ZYWSlipLineView : ZYWBaseChartView

@property (nonatomic,strong) NSArray *dataArray;

- (CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion;
- (void)stockFill;

@end
