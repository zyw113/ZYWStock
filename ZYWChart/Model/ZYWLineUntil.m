//
//  ZYWLineUntil.m
//  ZYWChart
//
//  Created by 张有为 on 2017/3/13.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWLineUntil.h"

@implementation ZYWLineUntil

- (id)initWithValue:(CGFloat)value date:(NSString *)date {
    self = [self init];
    
    if (self) {
        self.value = value;
        self.date = date;
    }
    return self;
}

@end
