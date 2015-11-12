//
//  NewMessageCenterController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/6.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NewMessageCenterController.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface NewMessageCenterController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation NewMessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"IM";
    _tableView.tableFooterView = [[UIView alloc] init];
}
#pragma mark - UITableViewDelegate&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 20)];
    headView.backgroundColor = [UIColor colorWithRed:(241.0/255.0) green:(242.0/255.0) blue:(244.0/255.0) alpha:1];
    return headView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 50)];
    cell.textLabel.text = @"哈哈";
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
