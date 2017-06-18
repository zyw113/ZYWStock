//
//  SlipLineVC.m
//  ZYWChart
//
//  Created by 张有为 on 2016/12/27.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "SlipLineVC.h"
#import "ZYWSlipLineView.h"

@interface SlipLineVC ()

@property (nonatomic,strong) ZYWSlipLineView *slipLine;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation SlipLineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"滑动折线图";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(80);
        make.height.equalTo(@(200));
    }];
    
    _slipLine = [[ZYWSlipLineView alloc] init];
    _slipLine.backgroundColor = [UIColor colorWithHexString:@"8B6969"];
    [_scrollView addSubview:_slipLine];
    _slipLine.lineWidth = 4;
     _slipLine.lineColor = [UIColor colorWithHexString:@"00FF7F"];
    [_slipLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(@(200));
        make.top.equalTo(_scrollView);
    }];
    
    [_slipLine layoutIfNeeded];
    _dataArray = @[@"12",@"33",@"44",@"55",@"7",@"10",@"28",@"12",@"33",@"11",@"63",@"7",@"10",@"66",@"12",@"41",@"28",@"12",@"55",@"77",@"21",@"12",@"33",@"54",@"30",@"7",@"20",@"21",@"12",@"33",@"44",@"55",@"7",@"10",@"28",@"12",@"33",@"11",@"63",@"7",@"10",@"66",@"12",@"41",@"28",@"12",@"55",@"77",@"21",@"12",@"33"];
    _slipLine.dataArray = _dataArray;
    _slipLine.leftMargin = 10;
    _slipLine.rightMargin = 10;
    _slipLine.topMargin = 10;
    _slipLine.bottomMargin = 10;
    [_slipLine stockFill];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
