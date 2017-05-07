//
//  ZYWLineModel.m
//  ZYWChart
//
//  Created by 张有为 on 2016/12/27.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "ZYWLineModel.h"
@implementation ZYWLineModel

+(instancetype)initPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition color:(UIColor*)color
{
    ZYWLineModel *model = [[ZYWLineModel alloc] init];
    model.xPosition = xPositon;
    model.yPosition = yPosition;
    model.lineColor = color;
    return model;
}

@end
