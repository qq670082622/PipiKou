//
//  ZhiVisitorDynamicController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/11.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ZhiVisitorDynamicController.h"
#import "NewCustomerCell.h"
#import "OpportunitykeywordCell.h"
#import "OpprotunityFreqCell.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface ZhiVisitorDynamicController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZhiVisitorDynamicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"客户动态";
    self.view.backgroundColor = [UIColor colorWithRed:(229.0/255.0) green:(231.0/255.0) blue:(232.0/255.0) alpha:1];
    [self.view addSubview:self.tableView];
}
#pragma mark - UITableViewDelegate&&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 86;
    }else if(indexPath.row == 1){
        return 110;
    }
    return 200;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NewCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewCustomerCell" forIndexPath:indexPath];
        return cell;
    }else if(indexPath.row == 1){
        OpportunitykeywordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpportunitykeywordCell" forIndexPath:indexPath];
        return cell;
    }
    OpprotunityFreqCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpprotunityFreqCell" forIndexPath:indexPath];
    return cell;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 0, kScreenSize.width-30, kScreenSize.height) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"NewCustomerCell" bundle:nil] forCellReuseIdentifier:@"NewCustomerCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"OpportunitykeywordCell" bundle:nil] forCellReuseIdentifier:@"OpportunitykeywordCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"OpprotunityFreqCell" bundle:nil] forCellReuseIdentifier:@"OpprotunityFreqCell"];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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