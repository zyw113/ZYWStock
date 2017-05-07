//
//  ZYWQuotaView.m
//  ZYWChart
//
//  Created by 张有为 on  2017/04/30.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWQuotaView.h"

@interface ZYWQuotaView()

@property (nonatomic,strong) UILabel *highLabel;
@property (nonatomic,strong) UILabel *lowLabel;
@property (nonatomic,strong) UILabel *openLabel;
@property (nonatomic,strong) UILabel *closeLabel;

@end
@implementation ZYWQuotaView

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
    [_highLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).multipliedBy(0.5);
        make.top.equalTo(@(40));
    }];
    
    [_lowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).multipliedBy(1.5);
        make.top.equalTo(_highLabel);
    }];

    [_openLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_highLabel);
        make.top.equalTo(_highLabel.mas_bottom).offset(10);
    }];
    
    [_closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_lowLabel);
        make.top.equalTo(_lowLabel.mas_bottom).offset(10);
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
    return label;
}

@end
