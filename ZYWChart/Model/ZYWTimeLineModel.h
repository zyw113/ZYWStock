//
//  ZYWTimeLineModel.h
//  ZYWChart
//
//  Created by 张有为 on 2017/5/13.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYWTimeLineModel : NSObject

@property (nonatomic, copy)    NSString *currtTime;
@property (nonatomic, assign)  CGFloat  preClosePx;
@property (nonatomic, assign)  CGFloat  avgPirce;
@property (nonatomic, assign)  CGFloat  lastPirce;
@property (nonatomic, assign)  CGFloat  totalVolume;
@property (nonatomic, assign)  CGFloat  volume;
@property (nonatomic, assign)  CGFloat  trade;
@property (nonatomic, copy)    NSString *rate;

@end
