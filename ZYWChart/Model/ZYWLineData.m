//
//  ZYWLineData.m
//  ZYWChart
//
//  Created by 张有为 on 2017/2/8.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWLineData.h"

@implementation ZYWLineData

- (id)initWithData:(NSMutableArray *)data color:(UIColor *)color title:(NSString *)title
{
    self = [self init];
    if (self)
    {
        self.data = data;
        self.color = color;
        self.title = title;
    }
    
    return self;
}

@end
