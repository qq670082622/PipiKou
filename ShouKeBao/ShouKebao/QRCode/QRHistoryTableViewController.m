//
//  QRHistoryTableViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "QRHistoryTableViewController.h"
#import "WriteFileManager.h"
#import "personIdModel.h"
#import "CardTableViewController.h"
#import "userIDTableviewController.h"
#import "IdentifyViewController.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "MobClick.h"
#import "MJRefresh.h"
#import "QRCodeCell.h"

#define view_width self.view.frame.size.width
#define view_height self.view.frame.size.height

@interface QRHistoryTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)IdentifyViewController *idenVC;



@property(nonatomic,strong) NSMutableArray *editArr;
@property (strong, nonatomic)UIView *loginView;
@property (strong, nonatomic)UIButton *logindeleteBT;
@property (strong, nonatomic)UIButton *loginsaveBT;
@property (strong, nonatomic)UILabel *logindeleteLB;
@property (strong, nonatomic)UILabel *loginsaveLB;
@property (strong, nonatomic)UIButton *deleteVT;
@property (strong, nonatomic) UILabel *deleteLB;
@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, assign) BOOL isOver;
@property (nonatomic, copy) NSString * pageNum;
@property (nonatomic, strong)NSMutableDictionary * postDic;

@property (nonatomic, strong)UIButton *cancleButton;
@property (nonatomic, strong)UIButton *saveButton;

- (void)deleteAction:(id)sender;
- (void)saveToCustom:(id)sender;

@property(nonatomic,strong) NSMutableArray *editIndexArrInNoLogin;

- (IBAction)cancleButton:(id)sender;
- (IBAction)saveButton:(id)sender;

@end

@implementation QRHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self loadNewData];

    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self refresh];
    self.navigationItem.leftBarButtonItems = @[leftItem,turnOffItem];
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
     [self stepRightItem];
    [self.view bringSubviewToFront:self.subView];
    
}

#pragma mark - 下拉刷新
- (void)refresh{
    self.pageNum = @"1";
    [self.table addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.table addFooterWithTarget:self action:@selector(loadMoreData)];
    self.table.headerPullToRefreshText = @"下拉刷新";
    self.table.headerRefreshingText = @"正在刷新中";
    self.table.footerPullToRefreshText = @"上拉刷新";
    self.table.footerRefreshingText = @"正在刷新";
}
- (void)loadMoreData{
    self.pageNum = [NSString stringWithFormat:@"%d",[self.pageNum integerValue]+1];
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

#pragma mark - 各种初始化～～
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)editArr{
    if (_editArr == nil){
        self.editArr = [NSMutableArray array];
    }
    return _editArr;
}

- (IdentifyViewController *)idenVC{
    if (!_idenVC) {
        self.idenVC = [[IdentifyViewController alloc]init];
    }
    return _idenVC;
}

-(NSMutableArray *)editIndexArrInNoLogin{
    if (_editIndexArrInNoLogin == nil) {
        self.editIndexArrInNoLogin = [NSMutableArray array];
    }
    return _editIndexArrInNoLogin;
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShouKeBaoQRHistoryViewController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaoQRHistoryViewController"];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 应答前界面的通知方法
-(void)stepRightItem{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(editHistoryDetail) name:@"edit2" object:@"QRHistory"];
}
-(void)editHistoryDetail{
    //    if (self.subView.hidden == YES && !self.isEditing) {
    //        self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-53-64);
    //        self.subView.hidden = NO;
    //        [self.table setEditing:YES animated:YES];
    //        self.isEditing = YES;
    //
    //        [self.editArr removeAllObjects];
    //
    //    }else if (self.subView.hidden == NO && self.isEditing){
    //        self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
    //        self.subView.hidden = YES;
    //        [self.table setEditing:NO animated:YES];
    //        self.isEditing = NO;
    //    }
    if (self.isEditing == 0) {
        self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-53);
        self.subView.hidden = NO;
        [self.table setEditing:YES animated:YES];
    }else{
        self.table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
        self.subView.hidden = YES;
        [self.table setEditing:NO animated:YES];
        [self.editArr removeAllObjects];
    }
    self.isEditing = !self.isEditing;
    [self.table reloadData];
}

#pragma mark - 加载数据
-(void)loadDataSource{
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
        
        [IWHttpTool postWithURL:@"Customer/GetCredentialsPicRecordList" params:@{@"RecordType":@"0",@"SortType":@"2",@"PageIndex":self.pageNum,@"PageSize":@"10"}  success:^(id json) {
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


#pragma mark - tableView - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString * cellID = @"QRHistoryCell";
    QRCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID]; 
    if (cell == nil) {
        cell = [[QRCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    personIdModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
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
            [self.identifyNav pushViewController:uid animated:YES];
            
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
            
            [self.identifyNav pushViewController:ca animated:YES];
        }
        if (!_isLogin) {
            NSMutableArray *mua = [NSMutableArray arrayWithArray:[WriteFileManager readData:@"record"]];
            [mua removeObjectAtIndex:indexPath.row];
            [WriteFileManager saveData:mua name:@"record"];//点击进去即删除点击的数据（因为，详细界面会再保存一次，否则会重复）
            
        }
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    // remondModel *model = _dataArr[indexPath.row];
    personIdModel *model = self.dataArr[indexPath.row];
    if (self.table.editing == YES) {
        if ([self.editArr containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
            [self.editArr removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
        [self.editArr removeObject:model];
        [self.editIndexArrInNoLogin removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
}



//- (void)deleteAction:(UIButton *)sender {
//  
//   }
//
//- (void)saveToCustom:(UIButton *)sender {
//    
//    if (_isLogin) {
//        
//        NSMutableArray *arr = [NSMutableArray array];
//        for(int i = 0 ;i<_editArr.count;i++){
//            //  personIdModel *model = _editArr[i];
//            //[arr addObject:model.RecordId];
//            
//            personIdModel *model = self.dataArr[[self.editArr[i] integerValue]];
//            NSLog(@"%@,%@", model.UserName, model.RecordType);
//            NSString * number = @"";
//            if ([model.RecordType isEqualToString:@"1"]) {
//                number = model.CardNum;
//            }else if([model.RecordType isEqualToString:@"2"]){
//                number = model.PassportNum;
//            }
//            if ([model.UserName isEqualToString:@""]||[number isEqualToString:@""]) {
//                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"姓名或证件号为空，无法保存" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alertView show];
//                return;
//            }else{
//                [arr addObject:model.RecordId];
//            }
//        }
//        
//        NSMutableDictionary * dic = [NSMutableDictionary dictionary];//@"/Customer/CreateCustomerList"
//        self.postDic = dic;
//        [self.postDic setObject:arr forKey:@"RecordIds"];
//        
//        [IWHttpTool WMpostWithURL:@"Customer/IsHaveSameCustomer" params:self.postDic success:^(id json) {
//            NSLog(@"%@", json);
//            if ([[NSString stringWithFormat:@"%@", json[@"IsHaveSameRecord"]]isEqualToString:@"1"]) {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"客户已存在，是否覆盖" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"覆盖", nil];
//                [alert show];
//            }else{
//                [self saveAfterWith];
//            }
//        } failure:^(NSError *error) {
//            NSLog(@"%@", error);
//        }];
//        
//    }else if (!_isLogin){
//        
//        NSMutableArray *muarr = [NSMutableArray array];
//        NSArray *arr = [NSArray arrayWithArray:[WriteFileManager readData:@"record"]] ;
//        for (int i = 0; i<self.editIndexArrInNoLogin.count; i++) {
//            
//            
//            NSDictionary *dic = [arr objectAtIndex:[self.editIndexArrInNoLogin[i] integerValue]
//                                 ];
//            [muarr addObject:dic];
//        }
//        
//        [WriteFileManager saveData:muarr name:@"recoder2"];//未登录时储存的客户;
//        [self.table reloadData];
//        
//    }
//    
//    [self editHistoryDetail];
//    
//    
//}
#pragma mark 删除客户的方法
- (IBAction)cancleButton:(id)sender {
    if (self.editArr.count == 0) {
        [self pointOut];
    }else{
    if (_isLogin) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i<self.editArr.count; i++) {
            NSLog(@"edit = %@", self.dataArr[[self.editArr[i] integerValue]]);
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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
            
            [self loadDataSource];
            [self.table reloadData];
//            [MBProgressHUD hideHUD];
        });
       
        
    }else if (!_isLogin){
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[WriteFileManager readData:@"record"]] ;
        for (int i = 0; i<self.editIndexArrInNoLogin.count; i++) {
            [arr removeObjectAtIndex:[self.editIndexArrInNoLogin[i] integerValue]];
        }
        [WriteFileManager saveData:arr name:@"record"];
    }
        
//        self.idenVC.control.selectedSegmentIndex = 1;
//        self.idenVC.historyFlag = 0;
//        [self.idenVC editCustomerDetail];
        
        [self editHistoryDetail];
        [self.delegate changrightBarButtonItemTitle];
       [MBProgressHUD showSuccess:@"操作成功"];
        
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
//        [MBProgressHUD hideHUD];
//        [self.identifyNav popViewControllerAnimated:YES];
//    });
    }
}
#pragma mark 保存的方法
- (IBAction)saveButton:(id)sender {
    if (self.editArr.count == 0) {
        [self pointOut];
    }else{
        self.isEditing = 1;
        [self.delegate changrightBarButtonItemTitle];
        [self editHistoryDetail];
        [self saveAfterWith];
    }
}
- (void)saveAfterWith{
    [IWHttpTool WMpostWithURL:@"Customer/CopyCredentialsPicRecordToCustomer" params:self.postDic success:^(id json) {
        NSLog(@"批量导入客户成功 返回json is %@",json);
        [self.table reloadData];
        [MBProgressHUD showSuccess:@"操作成功"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
            [MBProgressHUD hideHUD];
//            [self.identifyNav popViewControllerAnimated:YES];
//        });
        
    } failure:^(NSError *error) {
        NSLog(@"批量导入客户失败，返回error is %@",error);
    }];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self saveAfterWith];
    }
}
- (void)pointOut{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有选中任何记录!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
