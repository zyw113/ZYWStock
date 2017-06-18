//
//  ZYWLineModel.h
//  ZYWChart
//
//  Created by 张有为 on 2016/12/27.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYWLineModel : NSObject

@property (nonatomic,assign) CGFloat xPosition;
@property (nonatomic,assign) CGFloat yPosition;
@property (nonatomic,strong) UIColor *lineColor;

+ (instancetype)initPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition color:(UIColor*)color;

@end
