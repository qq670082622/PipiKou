//
//  QRHistoryViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "QRHistoryViewController.h"
#import "WriteFileManager.h"
#import "personIdModel.h"
#import "CardTableViewController.h"
#import "userIDTableviewController.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "MobClick.h"
#import "MJRefresh.h"
#import "QRCodeCell.h"

@interface QRHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,assign) BOOL isEditing;
@property (weak, nonatomic) IBOutlet UIView *subView;
//@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) NSMutableArray *editArr;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIButton *logindeleteBT;
@property (strong, nonatomic) IBOutlet UIButton *loginsaveBT;
@property (strong, nonatomic) IBOutlet UILabel *logindeleteLB;
@property (strong, nonatomic) IBOutlet UILabel *loginsaveLB;
@property (strong, nonatomic) IBOutlet UIButton *deleteVT;
@property (strong, nonatomic) IBOutlet UILabel *deleteLB;
@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, assign) BOOL isOver;
@property (nonatomic, copy) NSString * pageNum;
@property (nonatomic, strong)NSMutableDictionary * postDic;
- (IBAction)deleteAction:(id)sender;
- (IBAction)saveToCustom:(id)sender;

@property(nonatomic,strong) NSMutableArray *editIndexArrInNoLogin;

@end

@implementation QRHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.table.rowHeight = 70;
    self.table.tableFooterView = [[UIView alloc] init];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.pageNum = @"1";
    [self.table addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.table addFooterWithTarget:self action:@selector(loadMoreData)];
    self.table.headerPullToRefreshText = @"下拉刷新";
    self.table.headerRefreshingText = @"正在刷新中";
    self.table.footerPullToRefreshText = @"上拉刷新";
    self.table.footerRefreshingText = @"正在刷新";

    self.navigationItem.leftBarButtonItems = @[leftItem,turnOffItem];
    
//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    
//    self.navigationItem.leftBarButtonItem= leftItem;
    
    [self stepRightItem];
     self.title = @"识别纪录";
    //[self loadDataSource];
    if (self.isLogin) {
        self.deleteLB.hidden  = YES;
        self.deleteVT.hidden = YES;
    }else{
        self.loginView.hidden = YES;
        self.loginsaveBT.hidden = YES;
        self.loginsaveLB.hidden = YES;
        self.logindeleteBT.hidden = YES;
        self.logindeleteLB.hidden = YES;
    }
    [self loadNewData];
}

//- (void)turnOff{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShouKeBaoQRHistoryViewController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaoQRHistoryViewController"];
}
- (void)loadMoreData{
    self.pageNum = [NSString stringWithFormat:@"%ld",[self.pageNum integerValue]+1];
    self.isLoadMore = YES;
    if (self.isOver) {
        self.table.footerHidden = YES;
    }else{
    [self loadDataSource];
    }
}
- (void)loadNewData{
    self.pageNum = @"1";
    self.isLoadMore = NO;
    self.isOver = NO;
    self.table.footerHidden = NO;
    [self loadDataSource];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)stepRightItem
{
    
 UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(EditCustomerDetail)];
    self.navigationItem.rightBarButtonItem= barItem;
}

-(void)loadDataSource
{
//PageIndex   PageSize
    if (!_isLogin) {  //注record是未登录时的识别纪录，而record2是未登录时添加的客户
        
        [self.dataArr removeAllObjects];
        NSArray *arr = [NSArray arrayWithArray:[WriteFileManager readData:@"record"]] ;
        NSLog(@"dataArr is %@ - --- arr is %@",_dataArr,arr);
      for(NSDictionary *dic in arr) {
            personIdModel *model = [personIdModel modelWithDict:dic];
            [self.dataArr addObject:model];
        }
        [self ifArrIsNull:_dataArr];
         [self.table reloadData];
    }else if (_isLogin){

        [IWHttpTool postWithURL:@"Customer/GetCredentialsPicRecordList" params:@{@"RecordType":@"0",@"SortType":@"2",@"PageIndex":self.pageNum,@"PageSize":@"20"}  success:^(id json) {
            [self.table footerEndRefreshing];
            [self.table headerEndRefreshing];
    NSLog(@"纪录json is %@",json);
    NSMutableArray *mua = [NSMutableArray array];
    for (NSDictionary *dic in json[@"CredentialsPicRecordList"]) {
        personIdModel *model = [personIdModel modelWithDict:dic];
        [mua addObject:model];
    }
            if (!self.isLoadMore) {
                [self.dataArr removeAllObjects];
                self.dataArr = mua;
            }else{
                if ([self.pageNum integerValue] > [json[@"TotalCount"] integerValue]/20) {
                    self.isOver = YES;
                }else{
                [self.dataArr addObjectsFromArray:mua];
                }
            }
             [self ifArrIsNull:_dataArr];
            
             [self.table reloadData];
      } failure:^(NSError *error) {
    NSLog(@" error history");
}];
    }
    
   


}
//没有纪录时调用
-(void)ifArrIsNull:(NSMutableArray *)arr
{
    if (arr.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有历史纪录" message:@"您还没有通过证件神器进行扫描" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }

}

-(void)EditCustomerDetail
{

    if (self.subView.hidden == YES && !self.isEditing) {
       
        self.subView.hidden = NO;
        [self.table setEditing:YES animated:YES];
        self.isEditing = YES;
        
        [self.editArr removeAllObjects];
        self.navigationItem.rightBarButtonItem.title = @"取消";
        
    }else if (self.subView.hidden == NO && self.isEditing){
        self.subView.hidden = YES;
        
        [self.table setEditing:NO animated:YES];
        self.isEditing = NO;
        
        
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
        
    }
    return _dataArr;
}


-(NSMutableArray *)editArr
{
    if (_editArr == nil){
        self.editArr = [NSMutableArray array];
    }
    return _editArr;
    
}


-(NSMutableArray *)editIndexArrInNoLogin
{
    if (_editIndexArrInNoLogin == nil) {
        self.editIndexArrInNoLogin = [NSMutableArray array];
    }
    return _editIndexArrInNoLogin;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString * cellID = @"QRHistoryCell";
    QRCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[QRCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    personIdModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    personIdModel *model = _dataArr[indexPath.row];
    NSLog(@"%ld%@", (long)indexPath.row, model.UserName);
    if (self.table.editing == YES) {
              
        [self.editArr addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
        [self.editIndexArrInNoLogin addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    }else if (self.table.editing == NO){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ([model.RecordType isEqualToString:@"1"]) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
            userIDTableviewController *uid = [sb instantiateViewControllerWithIdentifier:@"userID"];
            uid.address = model.Address;
            uid.birthDay = model.BirthDay;
            uid.cardNumber = model.CardNum;
            uid.Nationality = model.Nationality;
            
            uid.sex = model.Sex;
            uid.UserName = model.UserName;
            uid.RecordId = model.RecordId;
            uid.ModifyDate = [NSMutableString stringWithFormat:@"%@",model.ModifyDate];
            uid.isLogin = _isLogin;
            uid.PicUrl = model.PicUrl;
                   [self.navigationController pushViewController:uid animated:YES];
          
            
        }else if ([model.RecordType isEqualToString:@"2"]){
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
            CardTableViewController *ca = [sb instantiateViewControllerWithIdentifier:@"customerCard"];
            ca.nameLabStr = model.UserName;
            ca.sexLabStr = model.Sex;
            ca.countryLabStr = model.Country;
            NSLog(@"%@", model.Country);
            ca.cardNumStr = model.PassportNum;
            ca.bornLabStr = model.BirthDay;
            ca.startDayLabStr = model.ValidStartDate;
            ca.startPointLabStr = model.ValidAddress;
            ca.effectiveLabStr = model.ValidEndDate;
            ca.RecordId = model.RecordId;
            ca.isLogin = _isLogin;
            ca.PicUrl = model.PicUrl;
            ca.ModifyDate = [NSMutableString stringWithFormat:@"%@",model.ModifyDate];

            [self.navigationController pushViewController:ca animated:YES];

        }
        if (!_isLogin) {
            NSMutableArray *mua = [NSMutableArray arrayWithArray:[WriteFileManager readData:@"record"]];
            [mua removeObjectAtIndex:indexPath.row];
            [WriteFileManager saveData:mua name:@"record"];//点击进去即删除点击的数据（因为，详细界面会再保存一次，否则会重复）

        }
           }
    
    
//    NSLog(@"--------editArr is %@--------indexpath.row's model is %@---",_editArr,_dataArr[indexPath.row]);
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // remondModel *model = _dataArr[indexPath.row];
    personIdModel *model = self.dataArr[indexPath.row];
    if (self.table.editing == YES) {
        if ([self.editArr containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
            [self.editArr removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
        [self.editArr removeObject:model];
         [self.editIndexArrInNoLogin removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    
  //  NSLog(@"--------editArr is %@--------indexpath.row's model is %@---",_editArr,_dataArr[indexPath.row]);
    
}



- (IBAction)deleteAction:(id)sender {
     [self.table setEditing:NO animated:YES];
    if (_isLogin) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i<self.editArr.count; i++) {
          
            personIdModel *model = self.dataArr[[self.editArr[i] integerValue]];
            [arr addObject:model.RecordId];
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];//@"/Customer/CreateCustomerList"
        [dic setObject:arr forKey:@"RecordIds"];
        
        [IWHttpTool WMpostWithURL:@"Customer/DeleteCredentialsPicRecord" params:dic success:^(id json) {
            NSLog(@"批量删除客户成功 返回json is %@",json);


           
        } failure:^(NSError *error) {
            NSLog(@"批量删除客户失败，返回error is %@",error);
        }];
       

    }else if (!_isLogin){
         NSMutableArray *arr = [NSMutableArray arrayWithArray:[WriteFileManager readData:@"record"]] ;
        for (int i = 0; i<self.editIndexArrInNoLogin.count; i++) {
            [arr removeObjectAtIndex:[self.editIndexArrInNoLogin[i] integerValue]];
        }
        [WriteFileManager saveData:arr name:@"record"];
           }
   
    [self EditCustomerDetail];
    
    [MBProgressHUD showSuccess:@"操作成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        [MBProgressHUD hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    });

   
}

- (IBAction)saveToCustom:(id)sender {
    
    if (_isLogin) {
       
        NSMutableArray *arr = [NSMutableArray array];
        for(int i = 0 ;i<_editArr.count;i++){
          //  personIdModel *model = _editArr[i];
            //[arr addObject:model.RecordId];
        
            personIdModel *model = self.dataArr[[self.editArr[i] integerValue]];
            NSLog(@"%@,%@", model.UserName, model.RecordType);
            NSString * number = @"";
            if ([model.RecordType isEqualToString:@"1"]) {
                number = model.CardNum;
            }else if([model.RecordType isEqualToString:@"2"]){
                number = model.PassportNum;
            }
            if ([model.UserName isEqualToString:@""]||[number isEqualToString:@""]) {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"姓名或证件号为空，无法保存" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }else{
            [arr addObject:model.RecordId];
            }
        }
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];//@"/Customer/CreateCustomerList"
        self.postDic = dic;
        [self.postDic setObject:arr forKey:@"RecordIds"];
        
        [IWHttpTool WMpostWithURL:@"Customer/IsHaveSameCustomer" params:self.postDic success:^(id json) {
            NSLog(@"%@", json);
            if ([[NSString stringWithFormat:@"%@", json[@"IsHaveSameRecord"]]isEqualToString:@"1"]) {
               UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"客户已存在，是否覆盖" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"覆盖", nil];
                [alert show];
            }else{
                [self saveAfterWith];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];

    }else if (!_isLogin){
        
        NSMutableArray *muarr = [NSMutableArray array];
        NSArray *arr = [NSArray arrayWithArray:[WriteFileManager readData:@"record"]] ;
        for (int i = 0; i<self.editIndexArrInNoLogin.count; i++) {
            
            
            NSDictionary *dic = [arr objectAtIndex:[self.editIndexArrInNoLogin[i] integerValue]
                                    ];
           [muarr addObject:dic];
        }
        
        [WriteFileManager saveData:muarr name:@"recoder2"];//未登录时储存的客户;
        [self.table reloadData];

    }
    
    [self EditCustomerDetail];
    

}
- (void)saveAfterWith{
    [IWHttpTool WMpostWithURL:@"Customer/CopyCredentialsPicRecordToCustomer" params:self.postDic success:^(id json) {
        NSLog(@"批量导入客户成功 返回json is %@",json);
        [self.table reloadData];
        [MBProgressHUD showSuccess:@"操作成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
            [MBProgressHUD hideHUD];
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        NSLog(@"批量导入客户失败，返回error is %@",error);
    }];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self saveAfterWith];
    }
}

@end
