//
//  ZYWCandleModel.h
//  ZYWChart
//
//  Created by 张有为 on 2016/12/28.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYWCandleModel : NSObject

@property (assign, nonatomic) CGFloat high;
@property (assign, nonatomic) CGFloat low;
@property (assign, nonatomic) CGFloat open;
@property (assign, nonatomic) CGFloat close;
@property (copy,   nonatomic) NSString *date;
@property (assign, nonatomic) BOOL isDrawDate;
@property (assign, nonatomic) NSInteger localIndex;

@end
