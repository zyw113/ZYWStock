//
//  ZYWMacdPostionModel.m
//  ZYWChart
//
//  Created by 张有为 on 2017/3/13.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWMacdPostionModel.h"

@implementation ZYWMacdPostionModel

+(instancetype)initPostion:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    ZYWMacdPostionModel *model = [[ZYWMacdPostionModel alloc] init];
    model.startPoint = startPoint;
    model.endPoint = endPoint;
    return model;
}

@end
