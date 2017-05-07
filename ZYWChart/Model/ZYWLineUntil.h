//
//  ZYWLineUntil.h
//  ZYWChart
//
//  Created by 张有为 on 2017/3/13.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYWLineUntil : NSObject

@property(assign, nonatomic) CGFloat value;
@property(retain, nonatomic) NSString *date;

- (id)initWithValue:(CGFloat)value date:(NSString *)date;

@end
