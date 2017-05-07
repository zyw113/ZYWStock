//
//  ZYWCandlePostionModel.m
//  ZYWChart
//
//  Created by 张有为 on 2017/1/15.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWCandlePostionModel.h"

@implementation ZYWCandlePostionModel

+ (instancetype) modelWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint date:(NSString*)date
{
    ZYWCandlePostionModel *candleModel = [ZYWCandlePostionModel new];
    candleModel.openPoint = openPoint;
    candleModel.closePoint = closePoint;
    candleModel.highPoint = highPoint;
    candleModel.lowPoint = lowPoint;
    candleModel.date = date;
    return candleModel;
}

@end
