//
//  CandleCrossScreenVC.h
//  ZYWChart
//
//  Created by 张有为 on 2017/5/9.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CandleCrossScreenVC;

@protocol CandleCrossScreenVCDeleate <NSObject>

- (void)willChangeScreenMode:(CandleCrossScreenVC*)vc;

@end

@interface CandleCrossScreenVC : UIViewController

@property (assign, nonatomic)UIInterfaceOrientation orientation;
@property (nonatomic,weak)  id <CandleCrossScreenVCDeleate> delegate;

@end
