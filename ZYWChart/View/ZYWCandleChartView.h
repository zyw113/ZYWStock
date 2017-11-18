//
//  ZYWCandleChartView.h
//  ZYWChart
//
//  Created by 张有为 on 2016/12/17.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZYWBaseChartView.h"
#import "ZYWCandleModel.h"
#import "ZYWCandleProtocol.h"

@interface ZYWCandleChartView : ZYWBaseChartView<ZYWCandleProtocol>

/**
 数据源数组 在调用绘制方法之前设置
 */
@property (nonatomic,strong) NSMutableArray<__kindof ZYWCandleModel*> *dataArray;

/**
 当前屏幕范围内显示的k线模型数组
 */
@property (nonatomic,strong) NSMutableArray *currentDisplayArray;

/**
 当前屏幕范围内显示的k线位置数组
 */
@property (nonatomic,strong) NSMutableArray *currentPostionArray;

/**
 可视区域显示多少根k线 
 */
@property (nonatomic,assign) NSInteger displayCount;

/**
 k线之间的距离
 */
@property (nonatomic,assign) CGFloat candleSpace;

/**
 k线的宽度 根据每页k线的根数和k线之间的距离动态计算得出
 */
@property (nonatomic,assign) CGFloat candleWidth;

/**
 k线最小高度
 */
@property (nonatomic,assign) CGFloat minHeight;

/**
 当前屏幕范围内绘制起点位置
 */
@property (nonatomic,assign) NSInteger leftPostion;

/**
 当前绘制的起始下标
 */
@property (nonatomic,assign) NSInteger currentStartIndex;

/**
 滑到最右侧的偏移量
 */
@property (nonatomic,assign) CGFloat previousOffsetX;

/**
 当前偏移量
 */
@property (nonatomic,assign) CGFloat contentOffset;

@property (nonatomic,assign) BOOL kvoEnable;

/**
 长按手势返回对应model的相对位置

 @param xPostion 手指在屏幕的位置
 @return 距离手指位置最近的model位置
 */
- (CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion;

/**
 填充
 */
- (void)stockFill;

/**
 刷新右拉加载调用
 */
- (void)reload;

/**
 宽度计算
 */
- (void)calcuteCandleWidth;

/**
 更新宽度
 */
- (void)updateWidth;

/**
 绘制主方法
 */
- (void)drawKLine;

@property (nonatomic,weak) id <ZYWCandleProtocol> delegate;

@end
