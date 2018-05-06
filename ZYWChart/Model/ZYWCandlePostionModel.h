//
//  ZYWCandlePostionModel.h
//  ZYWChart
//
//  Created by 张有为 on 2017/1/15.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYWCandlePostionModel : NSObject

/**
 *  开盘点
 */
@property (nonatomic, assign) CGPoint openPoint;

/**
 *  收盘点
 */
@property (nonatomic, assign) CGPoint closePoint;

/**
 *  最高点
 */
@property (nonatomic, assign) CGPoint highPoint;

/**
 *  最低点
 */
@property (nonatomic, assign) CGPoint lowPoint;

/**
 *  日期
 */
@property (nonatomic, copy) NSString *date;

@property (nonatomic,assign) BOOL isDrawDate;

@property (assign, nonatomic) NSInteger localIndex;

+ (instancetype) modelWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint date:(NSString*)date;

@end
