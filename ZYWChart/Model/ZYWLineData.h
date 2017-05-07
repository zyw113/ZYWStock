//
//  ZYWLineData.h
//  ZYWChart
//
//  Created by 张有为 on 2017/2/8.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYWLineData : NSObject

@property (nonatomic,copy) NSArray *data;
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,strong) UIColor *color;

- (id)initWithData:(NSMutableArray *)data color:(UIColor *)color title:(NSString *)title;

@end
