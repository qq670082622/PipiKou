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
@interface messageCenterViewController ()<UITableViewDataSource,UITableViewDelegate,notifiToReferesh>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *deleteArr;
@property (nonatomic,strong) NSMutableArray *isReadArr;
@end

@implementation messageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"消息中心";
    [self loadDataSource];
    [self loadDeleteArr];
    [self loadIsReadArr];
    
    self.table.rowHeight = 40;
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
    self.table.rowHeight = 60;
}
-(void)toReferesh
{
    [self loadDataSource];
    [self loadDeleteArr];
    [self loadIsReadArr];
    [self.table reloadData];
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
-(NSMutableArray *)deleteArr
{
    if (_deleteArr == nil) {
        self.deleteArr = [NSMutableArray array];
    }
    return _deleteArr;
}
-(NSMutableArray *)isReadArr
{
    if (_isReadArr == nil) {
        self.isReadArr = [NSMutableArray array];
    }
    return _isReadArr;
}

-(void)loadIsReadArr
{
    self.isReadArr = [WriteFileManager WMreadData:@"hasRead"];
}
-(void)loadDeleteArr
{
    self.deleteArr = [WriteFileManager WMreadData:@"deleted"];
}

-(void)loadDataSource
{
   
    NSMutableArray *arr = [WriteFileManager WMreadData:@"deleted"];
    NSLog(@"file's arr is%@",arr);
    [self.dataArr removeAllObjects];
   
    for(NSDictionary *dic in self.dataDic[@"ActivitiesNoticeList"]){
       messageModel *model = [messageModel modalWithDict:dic];
        
        [self.dataArr addObject:model];
}

    for(int i = 0; i<self.dataArr.count ; i++){
        messageModel *model = _dataArr[i];
        if ([arr containsObject:model.ID]) {
            [self.dataArr removeObjectAtIndex:i];
        }
    }
    
    for(int i = 0; i<self.dataArr.count ; i++){
        messageModel *model = _dataArr[i];
        if ([arr containsObject:model.ID]) {
            [self.dataArr removeObjectAtIndex:i];
        }
    }
    
    for(int i = 0; i<self.dataArr.count ; i++){
        messageModel *model = _dataArr[i];
        if ([arr containsObject:model.ID]) {
            [self.dataArr removeObjectAtIndex:i];
        }
    }
    
    
    [self.table reloadData];
    
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
       [self.deleteArr addObject:model.ID];
        [WriteFileManager WMsaveData:self.deleteArr name:@"deleted"];
        
        [self.dataArr removeObjectAtIndex:[indexPath row]];
        
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  messageDetailViewController *messageDetail = [[messageDetailViewController alloc] init];
    messageDetail.delegate = self;
    messageModel *model = _dataArr[indexPath.row];
    messageDetail.ID = model.ID;
    
    [self.isReadArr addObject:model.ID];
   [WriteFileManager WMsaveData:self.isReadArr name:@"hasRead"];


    //此处是计算还有几条未读消息，并将值通过代理返给首页，以供铃铛debadgeValue使用
    int count = 0;
    for (int i = 0; i<self.dataArr.count; i++) {
        messageModel *model = self.dataArr[i];
        if ([_isReadArr containsObject:model.ID]) {
            count+=1;
        }
    }
    
    int newCount = (int)(self.dataArr.count - count);
   [self.delegate refreshSKBMessgaeCount:newCount];
    
    
    [self.navigationController pushViewController:messageDetail animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageCell *cell = [messageCell cellWithTableView:tableView];
    messageModel *model = _dataArr[indexPath.row];
    cell.model = model;

if ([_isReadArr containsObject:model.ID]) {
   
        cell.hongdian.hidden = YES;
    }
    
    return cell;
}
@end
