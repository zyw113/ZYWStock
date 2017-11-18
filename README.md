# ZYWStock
[![Support](https://img.shields.io/badge/support-iOS7.0+-blue.svg?style=flat)]() &nbsp;
[![Support](https://img.shields.io/badge/support-Autolayout-orange.svg?style=flatt)]() &nbsp;
[![License Apache](https://img.shields.io/hexpm/l/plug.svg?style=flat)]() &nbsp;
# 说明
- ZYWStock是iOS下K线图的绘制库。支持放大缩小，长按高亮, 横竖屏切换。流畅丝滑~~~
- 如果刚好帮到了你，欢迎star or fork 😄 O(∩_∩)O~~ 😄
## 
- ![](https://github.com/zyw113/ZYWStock/blob/master/resourse/demo6.gif)
- ![](https://github.com/zyw113/ZYWStock/blob/master/resourse/demo3.gif)
- ![](https://github.com/zyw113/ZYWStock/blob/master/resourse/demo4.gif)
- ![](https://github.com/zyw113/ZYWStock/blob/master/resourse/demo5.gif)
- ![](https://github.com/zyw113/ZYWStock/blob/master/resourse/img1.png)
## 特点:
- 采用 CAShapeLayer + UIBezierPath绘制，绘制效率高，占用内存低
- 底层视图是UIScrollView，ScrollView上面添加一个View，所有的绘制在这个View上完成。体验流畅丝滑，FPS平均在55帧以上
- 指标支持MACD、WR、KDJ。指标计算采用TALib，方便扩展
## 版本记录
### V0.1
- 新增横竖屏切换
### V0.2
- 新增分时图
### V0.3
- 优化代码
### V1.0
- 整体代码修正
## 代理方法
```
/**
 取得当前屏幕内模型数组的开始下标以及个数
 
 @param leftPostion 当前屏幕最右边的位置
 @param index 下标
 @param count 个数
 */
- (void)displayScreenleftPostion:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count;

/**
 长按手势获得当前k线下标以及模型
 
 @param kLineModeIndex 当前k线在可视范围数组的位置下标
 @param kLineModel   k线模型
 */
- (void)longPressCandleViewWithIndex:(NSInteger)kLineModeIndex kLineModel:(ZYWCandleModel *)kLineModel;

/**
 返回当前屏幕最后一根k线模型
 
 @param kLineModel k线模型
 */
- (void)displayLastModel:(ZYWCandleModel *)kLineModel;

/**
 加载更多数据
 */
- (void)displayMoreData;
### 基础属性方法
```
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
 可视区域显示多少根k线 (如果数据源数组不足以占满屏幕，需要手动给定宽度)
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
@property (nonatomic,assign) CGFloat leftPostion;

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

/**
 kvoEnable
 */
@property (nonatomic,assign) BOOL kvoEnable;

/**
 代理
 */
@property (nonatomic,weak) id <ZYWCandleProtocol> delegate;

- (CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion;

/**
 填充方法

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
 绘制K线
 */
- (void)drawKLine;
```
## Contact
- 如果使用中发现问题欢迎添加 issue ，也欢迎 Pull request。
- QQ群:640138789
## License
ZYWStock is released under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).

        Copyright 2017 zyw113 All rights reserved.
        
        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.
## 博客地址
[简书](http://www.jianshu.com/u/0a68be3f5462)
