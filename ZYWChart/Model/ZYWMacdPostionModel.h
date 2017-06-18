//
//  ZYWMacdPostionModel.h
//  ZYWChart
//
//  Created by 张有为 on 2017/3/13.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYWMacdPostionModel : NSObject

@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) CGPoint endPoint;

+ (instancetype)initPostion:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
