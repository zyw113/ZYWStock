# ZYWStock
- ZYWStock是iOS下K线图的绘制库。支持放大缩小，长按高亮, 横竖屏切换。流畅丝滑~~~
- 如果刚好帮到了你，欢迎star fork 😄 O(∩_∩)O~~ 😄
## 
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
## 基础代理方法
```
-(void)displayScreenleftPostion:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count;
-(void)kLineMainViewLongPressKLinePositionModel:(NSInteger)kLineModeIndex kLineModel:(ZYWCandleModel *)kLineModel;
-(void)displayLastModel:(ZYWCandleModel *)kLineModel;
-(void)displayMoreData;
```
## Contact
- 如果使用中发现问题欢迎添加 issue ，也欢迎 Pull request。
- QQ群:640138789
## License
- Released under Apache Licence 2.0.
## 博客地址
[简书](http://www.jianshu.com/u/0a68be3f5462)
