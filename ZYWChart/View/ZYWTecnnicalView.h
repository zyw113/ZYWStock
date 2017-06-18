//
//  ZYWTecnnicalView.h
//  ZYWChart
//
//  Created by 张有为 on 2017/2/26.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZYWTecnnicalViewDelegate <NSObject>

- (void)didSelectButton:(UIButton*)button index:(NSInteger)index;

@end

@interface ZYWTecnnicalView : UIView

@property (nonatomic,strong) UIButton *macdButton;
@property (nonatomic,strong) UIButton *wrButton;
@property (nonatomic,strong) UIButton *kdjButton;
@property (nonatomic,  weak) id <ZYWTecnnicalViewDelegate> delagate;

@end
