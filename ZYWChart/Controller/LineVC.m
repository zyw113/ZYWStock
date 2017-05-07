//
//  LineVC.m
//  ZYWChart
//
//  Created by 张有为 on 2016/12/27.
//  Copyright © 2016年 zyw113. All rights reserved.
//

#import "LineVC.h"
#import "ZYWLineView.h"

@interface LineVC ()

@property (nonatomic,strong)  ZYWLineView *lineView;
@property (nonatomic,strong)  NSArray *dataArray;

@end

@implementation LineVC

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"折线图";
    
    _lineView = [[ZYWLineView alloc] init];
    _lineView.lineWidth = 2;
    _lineView.backgroundColor = [UIColor colorWithHexString:@"8B6969"];
    _lineView.lineColor = [UIColor colorWithHexString:@"C0FF3E"];
    _lineView.fillColor = [UIColor colorWithHexString:@"CD3278"];
    _lineView.isFillColor = YES;
    
    [self.view addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(200));
    }];
    [_lineView layoutIfNeeded];
    _dataArray = @[@"12",@"33",@"26",@"10",@"7",@"30",@"21"];

    _lineView.dataArray = _dataArray;
    _lineView.leftMargin = 0;
    _lineView.rightMargin = 0;
    _lineView.topMargin = 0;
    _lineView.bottomMargin = 0;
    [_lineView stockFill];
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
