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
#import "MobClick.h"
#import "WriteFileManager.h"
#import "BaseClickAttribute.h"
@interface messageCenterViewController ()<UITableViewDataSource,UITableViewDelegate>//,notifiToReferesh>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *deleteArr;
@property (nonatomic,strong) NSMutableArray *isReadArr;

//@property (nonatomic,assign) NSInteger isRead;
@end

@implementation messageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"消息中心";
   // [self loadDataSource];


    self.table.rowHeight = 75;
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.table.tableFooterView = [[UIView alloc] init];
    
    
    
}



-(void)toReferesh
{
//    [self loadDataSource];
//  
//    NSLog(@"代理重新刷新");
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShouKeBaoMessageCenterView"];

    [self loadDataSource];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaoMessageCenterView"];

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
        
        [IWHttpTool WMpostWithURL:@"Home/DeleteActivitiesNotice" params:dic success:^(id json) {
          
            NSLog(@"删除单个信息成功，返回信息json ：%@",json);
             [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
       
        } failure:^(NSError *error) {
            NSLog(@"删除单个信息失败，返回消息error %@",error);
        }];
        
       
        }
}


-(NSMutableArray *)isReadArr
{
    if (_isReadArr == nil) {
        self.isReadArr = [NSMutableArray array];
    }
    return _isReadArr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  messageDetailViewController *messageDetail = [[messageDetailViewController alloc] init];
   // messageDetail.delegate = self;
    messageModel *model = _dataArr[indexPath.row];
    messageDetail.ID = model.ID;
    messageDetail.messageURL = model.LinkUrl;
    messageDetail.createDate = model.CreatedDate;
    messageDetail.messageTitle = model.title;
    messageDetail.m = 0;
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShoukeBaoMessageCenterDetailClick" attributes:dict];

    
    [self.isReadArr addObjectsFromArray:[WriteFileManager WMreadData:@"messageRead"]];
    NSString *idStr = [NSString stringWithString:model.ID];
   //如果idstr在这个数组里没有出现 containsObject
    if (![_isReadArr containsObject:idStr]) {
        NSLog(@"---%ld",_isReadArr.count);
        [self.isReadArr addObject:idStr];
        NSLog(@"++++%ld",self.isReadArr.count);
        [WriteFileManager WMsaveData:_isReadArr name:@"messageRead"];
    }
    
   
    
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
    
   [self.isReadArr addObjectsFromArray:[WriteFileManager WMreadData:@"messageRead"]];
    
    if ([self.isReadArr containsObject:model.ID]) {
    
        cell.hongdian.hidden = YES;
    
    }else if(![self.isReadArr containsObject:model.ID]){
    
        cell.hongdian.hidden = NO;
    
    }
    
    return cell;
}

@end
