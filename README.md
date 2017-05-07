<<<<<<< HEAD
<<<<<<< HEAD
# ZYWChart
=======
# ZYWStock
>>>>>>> db9ab269599520ed55781b7d0821f0a6ce7b8b8f
iOS下K线图的绘制，放大缩小，长按高亮
如果ZYWChart帮到了你，欢迎star或fork 😄 O(∩_∩)O~~ 😄
## 特点:
- 采用 CAShapeLayer + UIBezierPath绘制，绘制效率高，占用内存低
- 底层视图是UIScrollView，ScrollView上面添加一个View，所有的绘制在这个View上完成。体验流畅丝滑，FPS平均在55帧以上
- 指标支持MACD WR KDJ，指标计算采用TALib，方便扩展
## 基础代理方法
```
-(void)displayScreenleftPostion:(CGFloat)leftPostion startIndex:(NSInteger)index count:(NSInteger)count;
-(void)kLineMainViewLongPressKLinePositionModel:(NSInteger)kLineModeIndex kLineModel:(ZYWCandleModel *)kLineModel;
-(void)displayLastModel:(ZYWCandleModel *)kLineModel;
-(void)displayMoreData;
```
## Contact
- 如果使用中发现问题欢迎添加 issue ，也欢迎 Pull request。

- 如果ZYWChart帮到了你，欢迎star或fork 😄 O(∩_∩)O~~ 😄
## License
- Released under MIT License.
=======
# ZYWStock
iOS K线图
>>>>>>> 84300d16c3cca4e7590ec6ecec1de26d0ac476a8
