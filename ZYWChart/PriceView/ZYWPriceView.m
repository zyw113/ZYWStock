//
//  ZYWPriceView.m
//  ZYWChart
//
//  Created by 张有为 on 2017/04/30.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWPriceView.h"

@implementation ZYWPriceView

-(UILabel *)maxPriceLabel
{
    if (!_maxPriceLabel)
    {
        _maxPriceLabel = [self createLabel];
        [self addSubview:_maxPriceLabel];
        [_maxPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
        }];
    }
    return _maxPriceLabel;
}

-(UILabel *)middlePriceLabel
{
    if (!_middlePriceLabel)
    {
        _middlePriceLabel = [self createLabel];
        [self addSubview:_middlePriceLabel];
        [_middlePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.left.equalTo(self);
        }];
    }
    return _middlePriceLabel;
}

-(UILabel *)minPriceLabel
{
    if (!_minPriceLabel)
    {
        _minPriceLabel = [self createLabel];
        [self addSubview:_minPriceLabel];
        [_minPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.equalTo(self);
        }];
    }
    return _minPriceLabel;
}

-(UILabel*)createLabel
{
    UILabel *label = [UILabel new];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:11];
    return label;
}

@end
