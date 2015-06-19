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
@interface QRHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,assign) BOOL isEditing;
@property (weak, nonatomic) IBOutlet UIView *subView;
//@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) NSMutableArray *editArr;
- (IBAction)deleteAction:(id)sender;
- (IBAction)saveToCustom:(id)sender;

@property(nonatomic,strong) NSMutableArray *editIndexArrInNoLogin;

@end

@implementation QRHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.table.rowHeight = 70;
    self.table.tableFooterView = [[UIView alloc] init];
    
   
    
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
    [self stepRightItem];
     self.title = @"识别纪录";
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
    if (!_isLogin) {
        [self.dataArr removeAllObjects];
          NSArray *arr = [NSArray arrayWithArray:[WriteFileManager readData:@"record"]] ;
        
      for(NSDictionary *dic in arr) {
            personIdModel *model = [personIdModel modelWithDict:dic];
            [self.dataArr addObject:model];
        }
        [self ifArrIsNull:_dataArr];
        [self.table reloadData];
        
    }else if (_isLogin){

        [IWHttpTool postWithURL:@"Customer/GetCredentialsPicRecordList" params:@{@"RecordType":@"0",@"SortType":@"1",@"PageIndex":@"1",@"PageSize":@"1000"}  success:^(id json) {
    NSLog(@"纪录json is %@",json);
    NSMutableArray *mua = [NSMutableArray array];
    for (NSDictionary *dic in json[@"CredentialsPicRecordList"]) {
        personIdModel *model = [personIdModel modelWithDict:dic];
        [mua addObject:model];
    }
    [self.dataArr removeAllObjects];
    self.dataArr = mua;
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
//      self.dataArr = [NSMutableArray arrayWithArray: [WriteFileManager WMreadData:@"scanning"]];
//    
//    //personIdModel *model = _dataArr[0];
//    UILabel *testLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 320, 500)];
//    testLab.backgroundColor = [UIColor whiteColor];
//    testLab.text = [NSString stringWithFormat:@"(用来测试后台返回的数据，8秒后自动删除)\n\narr is %lu----,modelName is",self.dataArr.count];
//    testLab.numberOfLines = 0;
//    [self.view.window addSubview:testLab];

    if (self.subView.hidden == YES && !self.isEditing) {
       
        self.subView.hidden = NO;
        [self.table setEditing:YES animated:YES];
        self.isEditing = YES;
        
        
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
static NSString *cellID = @"QRHistoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        personIdModel *model = self.dataArr[indexPath.row];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 35, 35)];
        [cell.contentView addSubview:imgV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+10, 10, 200, 20)];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = model.UserName;
        [cell.contentView addSubview:label];
        
        UILabel *codeLab = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame)+10, 200, 20)];
        codeLab.textColor = [UIColor grayColor];
        codeLab.font = [UIFont systemFontOfSize:12];
        codeLab.textAlignment = NSTextAlignmentLeft;
       
        [cell.contentView addSubview:codeLab];
        
        UILabel *creatLab = [[UILabel alloc] initWithFrame:CGRectMake(screenW-140, codeLab.frame.origin.y, 130, 20)];
        creatLab.textColor = [UIColor grayColor];
        creatLab.font = [UIFont systemFontOfSize:13];
        creatLab.textAlignment = NSTextAlignmentRight;
        creatLab.text = model.ModifyDate;
        
        
        if ([model.RecordType isEqualToString:@"2"]) {
            imgV.image = [UIImage imageNamed:@"passPort"];
             codeLab.text = model.PassportNum;
        }else if([model.RecordType isEqualToString:@"1"]){
            imgV.image = [UIImage imageNamed:@"IDInform"];
            codeLab.text = model.CardNum;
        }

       cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        
        [cell.contentView addSubview:creatLab];
    }
  

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
    
    if (self.table.editing == YES) {
        
        [self.editArr addObject:model];
        
        [self.editIndexArrInNoLogin addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
    }else if (self.table.editing == NO){
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
            uid.isLogin = _isLogin;
                   [self.navigationController pushViewController:uid animated:YES];

        }else if ([model.RecordType isEqualToString:@"2"]){
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
            CardTableViewController *ca = [sb instantiateViewControllerWithIdentifier:@"customerCard"];
            ca.nameLabStr = model.UserName;
            ca.sexLabStr = model.Sex;
            ca.countryLabStr = model.Country;
            ca.cardNumStr = model.PassportNum;
            ca.bornLabStr = model.BirthDay;
            ca.startDayLabStr = model.ValidStartDate;
            ca.startPointLabStr = model.ValidAddress;
            ca.effectiveLabStr = model.ValidEndDate;
            ca.RecordId = model.RecordId;
            ca.isLogin = _isLogin;
            
            [self.navigationController pushViewController:ca animated:YES];

        }

    }
    
    
//    NSLog(@"--------editArr is %@--------indexpath.row's model is %@---",_editArr,_dataArr[indexPath.row]);
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // remondModel *model = _dataArr[indexPath.row];
    personIdModel *model = self.dataArr[indexPath.row];
    if (self.table.editing == YES) {
        
        [self.editArr removeObject:model];
         [self.editIndexArrInNoLogin removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    
  //  NSLog(@"--------editArr is %@--------indexpath.row's model is %@---",_editArr,_dataArr[indexPath.row]);
    
}



- (IBAction)deleteAction:(id)sender {
    if (_isLogin) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i<self.editArr.count; i++) {
            [self.dataArr removeObject:self.editArr[i]];
            personIdModel *model = self.editArr[i];
            [arr addObject:model.RecordId];
            // Customer/DeleteCredentialsPicRecord
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];//@"/Customer/CreateCustomerList"
        [dic setObject:arr forKey:@"RecordIds"];
        
        [IWHttpTool WMpostWithURL:@"Customer/DeleteCredentialsPicRecord" params:dic success:^(id json) {
            NSLog(@"批量删除客户成功 返回json is %@",json);
            // [self.delegate referesh];
        } failure:^(NSError *error) {
            NSLog(@"批量删除客户失败，返回error is %@",error);
        }];
   
[self.table reloadData];
    }else if (!_isLogin){
      
        for (int i = 0; i<self.editIndexArrInNoLogin.count; i++) {
            [self.dataArr removeObjectAtIndex:[self.editIndexArrInNoLogin[i] integerValue]];
        }
        [self.table reloadData];
    }
   
    [self EditCustomerDetail];
    
    [MBProgressHUD showSuccess:@"操作成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        [MBProgressHUD hideHUD];
    });

  
}

- (IBAction)saveToCustom:(id)sender {
    
    if (_isLogin) {
       
        NSMutableArray *arr = [NSMutableArray array];
        for(int i = 0 ;i<_editArr.count;i++){
            personIdModel *model = _editArr[i];
            [arr addObject:model];
            }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];//@"/Customer/CreateCustomerList"
        [dic setObject:arr forKey:@"RecordIds"];
        
        [IWHttpTool WMpostWithURL:@"Customer/CopyCredentialsPicRecordToCustomer" params:dic success:^(id json) {
            NSLog(@"批量导入客户成功 返回json is %@",json);
            [self.table reloadData];
            
        } failure:^(NSError *error) {
            NSLog(@"批量导入客户失败，返回error is %@",error);
        }];

    }else if (!_isLogin){
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (int i = 0; i<self.editIndexArrInNoLogin.count; i++) {
            personIdModel *model = [self.dataArr objectAtIndex:[self.editIndexArrInNoLogin[i] integerValue]
                                    ];
           [arr addObject:model.RecordId];
        }
        
        [WriteFileManager saveData:arr name:@"recoder2"];//未登录时储存的客户;
        [self.table reloadData];

    }
    
    [self EditCustomerDetail];
    
    [MBProgressHUD showSuccess:@"操作成功"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        [MBProgressHUD hideHUD];
    });

}
@end
