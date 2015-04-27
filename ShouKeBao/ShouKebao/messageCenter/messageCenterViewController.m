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
#import "WriteFileManager.h"
#import "IWHttpTool.h"
@interface messageCenterViewController ()<UITableViewDataSource,UITableViewDelegate,notifiToReferesh>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *deleteArr;
@property (nonatomic,strong) NSMutableArray *isReadArr;

@property (nonatomic,assign) NSInteger isRead;
@end

@implementation messageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"消息中心";
    [self loadDataSource];
    

    self.table.rowHeight = 75;
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
    self.table.tableFooterView = [[UIView alloc] init];
    
}
-(void)toReferesh
{
    [self loadDataSource];
  
    NSLog(@"代理重新刷新");
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
    NSMutableDictionary *dic = [NSMutableDictionary  dictionary];
    [HomeHttpTool getActivitiesNoticeListWithParam:dic success:^(id json) {
        NSLog(@"首页公告消息列表%@",json);
        [self.dataArr removeAllObjects];
        for (NSDictionary *dic in json[@"ActivitiesNoticeList"]) {
            
            messageModel *model = [messageModel modalWithDict:dic];
            [self.dataArr addObject:model];
}
        [self.table reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"首页公告消息列表失败%@",error);
    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath      //当在Cell上滑动时会调用此函数
{
    return  UITableViewCellEditingStyleDelete;
    
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"%ld", (long)indexPath.row);
        
        messageModel *model = self.dataArr[indexPath.row];
        [self.dataArr removeObjectAtIndex:[indexPath row]];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:model.ID forKey:@"ActivitiesNoticeID"];
        [IWHttpTool WMpostWithURL:@"/Home/DeleteActivitiesNotice" params:dic success:^(id json) {
            NSLog(@"删除单个信息成功，返回信息json ：%@",json);
        } failure:^(NSError *error) {
            NSLog(@"删除单个信息失败，返回消息error %@",error);
        }];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  messageDetailViewController *messageDetail = [[messageDetailViewController alloc] init];
    messageDetail.delegate = self;
    messageModel *model = _dataArr[indexPath.row];
    messageDetail.ID = model.ID;
    messageDetail.messageURL = model.LinkUrl;
    messageDetail.createDate = model.CreatedDate;
    messageDetail.messageTitle = model.title;

    self.isRead = indexPath.row;
    [self.navigationController pushViewController:messageDetail animated:YES];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     NSLog(@"----------------------message count is %lu",(unsigned long)self.dataArr.count);
    
    return self.dataArr.count;
   
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageCell *cell = [messageCell cellWithTableView:tableView];
   
    messageModel *model = _dataArr[indexPath.row];
    
    cell.model = model;
    
    if (indexPath.row == _isRead) {
    
        cell.hongdian.hidden = YES;
    }
    
    return cell;
}

@end
