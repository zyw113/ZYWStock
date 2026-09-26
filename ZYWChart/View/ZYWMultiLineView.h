//
//  ZYWMultiLineView.h
//  ZYWChart
//
//  Created by 张有为 on 2017/5/3.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWBaseChartView.h"
#import "ZYWLineData.h"

NS_ASSUME_NONNULL_BEGIN

/**
 多条折线指标图的通用实现(KDJ、WR 等)。
 每条 ZYWLineData 对应一个常驻的 CAShapeLayer, 刷新时只更新 path。
 */
@interface ZYWMultiLineView : ZYWBaseChartView

/**
 折线数据源, 每个元素是一条折线, 数据按时间正序排列
 */
@property (nonatomic, copy, nullable) NSArray<ZYWLineData *> *dataArray;

@property (nonatomic, assign) CGFloat candleWidth;
@property (nonatomic, assign) CGFloat candleSpace;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger displayCount;

/**
 按当前可视区域重新绘制
 */
- (void)stockFill;

@end

NS_ASSUME_NONNULL_END
