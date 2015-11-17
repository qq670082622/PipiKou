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
#import "IWHttpTool.h"
#import "TerraceMessageModel.h"
#import "TerracedetailViewController.h"
#import "MBProgressHUD+MJ.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface TerraceMessageController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray *noticeArray;
@end

@implementation TerraceMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"服务通知";
    [self loadDataSource];
    [_tableView registerNib:[UINib nibWithNibName:@"TerraceMessCell" bundle:nil] forCellReuseIdentifier:@"TerraceMessCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"TimerCell" bundle:nil] forCellReuseIdentifier:@"TimerCell"];
    _tableView.tableFooterView = [[UIView alloc] init];
}

- (void)loadDataSource{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [IWHttpTool postWithURL:@"Notice/GetNoticeList" params:nil success:^(id json) {
        if ([json[@"IsSuccess"]integerValue]) {
            NSArray * noticeList = json[@"NoticeList"];
            NSLog(@"%@", json);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            for (NSDictionary * dic in noticeList) {
                TerraceMessageModel * model = [TerraceMessageModel modelWithDic:dic];
                [self.noticeArray addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError * eror) {
    }];
}
-(NSMutableArray *)noticeArray{
    if (!_noticeArray) {
        _noticeArray = [NSMutableArray array];
    }
    return _noticeArray;
}

#pragma mark - UITableViewDelegate&&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.noticeArray.count*2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2 == 0) {
        return 50;
    }
    return 250;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimerCell *cell;
    TerraceMessCell *trcell;
    TerraceMessageModel * model = self.noticeArray[indexPath.row/2];
    if (indexPath.row%2 == 0) {
        cell =[tableView dequeueReusableCellWithIdentifier:@"TimerCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.TimerLabel.text = model.CreatedDateText;
        return cell;
    }
    trcell = [tableView dequeueReusableCellWithIdentifier:@"TerraceMessCell" forIndexPath:indexPath];
    trcell.model = model;
    return trcell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TerraceMessageModel * model = self.noticeArray[indexPath.row/2];
    TerracedetailViewController * detailVC = [[TerracedetailViewController alloc]init];
    detailVC.linkUrl = model.LinkUrl;
    [self.navigationController pushViewController:detailVC animated:YES];
}



@end
