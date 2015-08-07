//
//  CustomerOrderViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/6.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CustomerOrderViewController.h"

@interface CustomerOrderViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray * dateSource;
@end

@implementation CustomerOrderViewController


- (NSMutableArray *)dateSource{
    if (!_dateSource) {
        _dateSource = [NSMutableArray array];
    }
    return _dateSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 0;
    self.view.backgroundColor = [UIColor whiteColor ];
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}              // Default is 1 if not implemented

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"CustomerOrdercell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
    
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
