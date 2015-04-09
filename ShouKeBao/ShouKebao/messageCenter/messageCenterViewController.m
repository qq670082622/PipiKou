//
//  messageCenterViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "messageCenterViewController.h"
#import "messageCell.h"
#import "messageModel.h"
#import "messageDetailViewController.h"
#import "HomeHttpTool.h"
@interface messageCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation messageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"消息中心";
    [self loadDataSource];
    self.table.rowHeight = 40;
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(void)loadDataSource
{
    for(NSDictionary *dic in self.dataDic[@"ActivitiesNoticeList"]){
        messageModel *model = [messageModel modalWithDict:dic];
        [self.dataArr addObject:model];
    }
    [self.table reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  messageDetailViewController *messageDetail = [[messageDetailViewController alloc] init];
    messageModel *model = _dataArr[indexPath.row];
    messageDetail.ID = model.ID;
    
[self.navigationController pushViewController:messageDetail animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageCell *cell = [messageCell cellWithTableView:tableView];
    cell.model = _dataArr[indexPath.row];
    return cell;
}
@end
