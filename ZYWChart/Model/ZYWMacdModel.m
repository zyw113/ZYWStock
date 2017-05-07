//
//  ZYWMacdModel.m
//  ZYWChart
//
//  Created by 张有为 on 2017/3/13.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWMacdModel.h"

@implementation ZYWMacdModel

- (id)initWithDea:(CGFloat)dea diff:(CGFloat)diff macd:(CGFloat)macd date:(NSString *)date
{
    ZYWMacdModel *model = [[ZYWMacdModel alloc] init];
    model.dea = dea;
    model.diff = diff;
    model.macd = macd;
    model.date = date;
    return model;
}
@end
