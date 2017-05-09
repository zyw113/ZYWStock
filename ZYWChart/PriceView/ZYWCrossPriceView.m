//
//  ZYWCrossPriceView.m
//  ZYWChart
//
//  Created by 张有为 on 2017/5/9.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWCrossPriceView.h"

@interface ZYWCrossPriceView()

@property (nonatomic,strong) UILabel *highLabel;
@property (nonatomic,strong) UILabel *lowLabel;
@property (nonatomic,strong) UILabel *openLabel;
@property (nonatomic,strong) UILabel *closeLabel;

@end
@implementation ZYWCrossPriceView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubviews];
        [self addConstraints];
    }
    return self;
}

-(void)addSubviews
{
    _highLabel = [self createLabel];
    [self addSubview:_highLabel];
    
    _lowLabel = [self createLabel];
    [self addSubview:_lowLabel];
    
    _openLabel = [self createLabel];
    [self addSubview:_openLabel];
    
    _closeLabel = [self createLabel];
    [self addSubview:_closeLabel];
}

-(void)addConstraints
{
    CGFloat width = DEVICE_HEIGHT/4;
    [_highLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self);
        make.width.equalTo(@(width));
        
    }];
    
    [_lowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.highLabel.mas_right);
        make.width.equalTo(self.highLabel);
        make.centerY.equalTo(self);
    }];
    
    [_openLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lowLabel.mas_right);
        make.width.equalTo(self.highLabel);
        make.centerY.equalTo(self);
    }];
    
    [_closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.openLabel.mas_right);
        make.width.equalTo(self.highLabel);
        make.centerY.equalTo(self);
    }];
}

-(void)setModel:(ZYWCandleModel *)model
{
    _model = model;
    _highLabel.text = [NSString stringWithFormat:@"%@%.2f",@"最高价 : ",_model.high];
    _lowLabel.text = [NSString stringWithFormat:@"%@%.2f",@"最低价 : ",_model.low];
    _openLabel.text = [NSString stringWithFormat:@"%@%.2f",@"开盘价 : ",_model.open];
    _closeLabel.text = [NSString stringWithFormat:@"%@%.2f",@"收盘价 : ",_model.close];
}

-(UILabel*)createLabel
{
    UILabel *label = [UILabel new];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}


@end
