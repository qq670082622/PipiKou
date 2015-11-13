//
//  TerraceMessageController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/6.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "TerraceMessageController.h"
#import "TerraceMessCell.h"
#import "TimerCell.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface TerraceMessageController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TerraceMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"服务通知";
    [_tableView registerNib:[UINib nibWithNibName:@"TerraceMessCell" bundle:nil] forCellReuseIdentifier:@"TerraceMessCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TimerCell" bundle:nil] forCellReuseIdentifier:@"TimerCell"];
    _tableView.tableFooterView = [[UIView alloc] init];
}
#pragma mark - UITableViewDelegate&&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    }
    return 250;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimerCell *cell;
    TerraceMessCell *trcell;
    if (indexPath.row == 0) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"TimerCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    trcell = [tableView dequeueReusableCellWithIdentifier:@"TerraceMessCell" forIndexPath:indexPath];
    NSLog(@"%f---%f",trcell.frame.size.width,kScreenSize.width);
    return trcell;
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
