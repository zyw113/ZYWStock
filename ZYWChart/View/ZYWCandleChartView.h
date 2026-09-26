//
//  ZYWCandleChartView.h
//  ZYWChart
//
//  Created by 张有为 on 2016/12/17.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZYWBaseChartView.h"
#import "ZYWCandleModel.h"
#import "ZYWCandlePostionModel.h"
#import "ZYWCandleProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 K线图。需要作为 UIScrollView 的子视图使用, 视图宽度等于全部K线的总宽度,
 每一帧只绘制可视区域内的K线, 滚动与缩放均由本视图内部处理。
 */
@interface ZYWCandleChartView : ZYWBaseChartView

/**
 数据源数组, 按时间正序(旧 -> 新)排列, 在调用绘制方法之前设置
 */
@property (nonatomic, copy, nullable) NSArray<__kindof ZYWCandleModel *> *dataArray;

/**
 当前屏幕范围内显示的k线模型数组
 */
@property (nonatomic, readonly) NSArray<__kindof ZYWCandleModel *> *currentDisplayArray;

/**
 当前屏幕范围内显示的k线位置数组
 */
@property (nonatomic, readonly) NSArray<ZYWCandlePostionModel *> *currentPostionArray;

/**
 可视区域显示多少根k线
 */
@property (nonatomic, assign) NSInteger displayCount;

/**
 捏合缩放时可视区域内k线根数的下限, 默认 10
 */
@property (nonatomic, assign) NSInteger minDisplayCount;

/**
 捏合缩放时可视区域内k线根数的上限, 默认 100
 */
@property (nonatomic, assign) NSInteger maxDisplayCount;

/**
 是否开启捏合缩放, 默认 YES
 */
@property (nonatomic, assign, getter=isZoomEnabled) BOOL zoomEnabled;

/**
 k线之间的距离
 */
@property (nonatomic, assign) CGFloat candleSpace;

/**
 k线的宽度 根据每页k线的根数和k线之间的距离动态计算得出
 */
@property (nonatomic, assign) CGFloat candleWidth;

/**
 k线最小高度
 */
@property (nonatomic, assign) CGFloat minHeight;

/**
 当前屏幕范围内绘制起点位置
 */
@property (nonatomic, readonly) CGFloat leftPostion;

/**
 当前绘制的起始下标
 */
@property (nonatomic, readonly) NSInteger currentStartIndex;

/**
 实际绘制的K线根数, 比 displayCount 多一根, 用于补齐滚动时露出的边缘
 */
@property (nonatomic, readonly) NSInteger visibleCount;

/**
 滑到最右侧的偏移量
 */
@property (nonatomic, assign) CGFloat previousOffsetX;

@property (nonatomic, weak, nullable) id<ZYWCandleProtocol> delegate;

/**
 长按手势返回对应model的相对位置

 @param xPostion 手指在屏幕的位置
 @return 距离手指位置最近的model位置
 */
- (CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion;

/**
 首次填充数据并绘制, 绘制后停留在最右侧(最新一根K线)
 */
- (void)stockFill;

/**
 刷新右拉加载调用
 */
- (void)reload;

/**
 根据可视根数重新计算单根K线的宽度
 */
- (void)calcuteCandleWidth;

/**
 绘制主方法, 只绘制可视区域
 */
- (void)drawKLine;

@end

NS_ASSUME_NONNULL_END
