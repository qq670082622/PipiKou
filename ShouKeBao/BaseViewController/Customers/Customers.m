//
//  Customers.m
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//
#import "IWHttpTool.h"
#import "Customers.h"
#import "CustomCell.h"
#import "CustomModel.h"
#import "CustomerDetailViewController.h"
#import "addCustomerViewController.h"
#import "BatchAddViewController.h"
#import "MBProgressHUD+MJ.h"
@interface Customers ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *dataArr;
- (IBAction)addNewUser:(id)sender;
- (IBAction)importUser:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *wordBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelSearchOutlet;

- (IBAction)cancelSearch:(id)sender;

//1、 时间顺序;2、时间倒序; 3-订单数顺序;4、订单数倒序 5,字母顺序 6，字母倒序
@end

@implementation Customers

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"管客户";
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.rowHeight = 55;
    //[self loadDataSource];
    [self customerRightBarItem];
    self.searchTextField.delegate = self;
    [self.timeBtn setSelected:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"加载中...";
    [hudView show:YES];
    
    [self loadDataSource];
}
-(void)customerRightBarItem
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [button setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(setUp)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem= barItem;
}


-(void)setUp
{
    if (self.subView.hidden == YES) {
        [UIView animateWithDuration:0.8 animations:^{
            self.subView.alpha = 0;
            self.subView.alpha = 1;
           self.subView.hidden = NO;
        }];
        
    }else if (self.subView.hidden == NO){
       [UIView animateWithDuration:0.8 animations:^{
           self.subView.alpha = 1;
           self.subView.alpha = 0;
             self.subView.hidden = YES;
       }];
      
    }
}

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (IBAction)addNewUser:(id)sender {
    self.subView.hidden = YES;
    addCustomerViewController *add = [[addCustomerViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
    
}

- (IBAction)importUser:(id)sender {
    self.subView.hidden = YES;
    BatchAddViewController *batch = [[BatchAddViewController alloc] init];
    [self.navigationController pushViewController:batch animated:YES];
}



-(void)loadDataSource
{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"PageIndex"];
    [dic setObject:@"100" forKey:@"PageSize"];
   NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sortType = [accountDefaults stringForKey:@"sortType"];
    if (sortType) {
        [dic setObject:sortType forKey:@"sortType"];
    }else if (!sortType){
        [dic setObject:@"1" forKey:@"sortType"];
}
    
    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomerList" params:dic success:^(id json) {
        NSLog(@"------管客户json is %@-------",json);
        for(NSDictionary *dic in  json[@"CustomerList"]){
            CustomModel *model = [CustomModel modalWithDict:dic];
            [self.dataArr addObject:model];
        }
        [self.table reloadData];
        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window]
    animated:YES];

    } failure:^(NSError *error) {
        NSLog(@"-------管客户第一个接口请求失败 error is %@------",error);
    }];

   }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    CustomerDetailViewController *detail = [[CustomerDetailViewController alloc] init];
    CustomModel *model = _dataArr[indexPath.row];
    detail.QQStr = model.QQCode;
    detail.ID = model.ID;
    detail.weChatStr = model.WeiXinCode;
    detail.teleStr = model.Mobile;
    detail.noteStr = model.Remark;
    
       [self.navigationController pushViewController:detail animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [CustomCell cellWithTableView:tableView];
    CustomModel *model = _dataArr[indexPath.row];
    cell.model = model;
   
       return cell;
    }
#pragma mark - textField delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTextField resignFirstResponder];
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"PageIndex"];
    [dic setObject:@"100" forKey:@"PageSize"];
   [dic setObject:self.searchTextField.text forKey:@"SearchKey"];
    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomerList" params:dic success:^(id json) {
       
        NSLog(@"------管客户json is %@-------",json);
        [self.dataArr removeAllObjects];
        for(NSDictionary *dic in json[@"CustomerList"]){
            CustomModel *model = [CustomModel modalWithDict:dic];
            [self.dataArr addObject:model];
        }
        [self.table reloadData];
    } failure:^(NSError *error) {
        NSLog(@"-------管客户第一个接口请求失败 error is %@------",error);
    }];
    

    return YES;
   
}

- (IBAction)timeOrderAction:(id)sender {
    [self.orderNumBtn setSelected:NO];
    [self.wordBtn setSelected:NO];
    
    if (self.timeBtn.selected == NO) {
        [self.timeBtn setSelected:YES];
         NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"1" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
        [self.table reloadData];

    }else if (self.timeBtn.selected == YES && [self.timeBtn.currentTitle  isEqual: @"时间排序 ↓"]) {
        [self.timeBtn setSelected:YES];
        [self.timeBtn setTitle:@"时间排序 ↑" forState:UIControlStateNormal];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"2" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
        [self.table reloadData];

    }else if (self.timeBtn.selected == YES &&[self.timeBtn.currentTitle isEqual:@"时间排序 ↑"]){
        [self.timeBtn setSelected:YES];
        [self.timeBtn setTitle:@"时间排序 ↓" forState:UIControlStateNormal];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"1" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
        [self.table reloadData];

    }
    
}
- (IBAction)orderNumAction:(id)sender {
    [self.timeBtn setSelected:NO];
    [self.wordBtn setSelected:NO];
    if (self.orderNumBtn.selected == NO) {
        [self.orderNumBtn setSelected:YES];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"3" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
        [self.table reloadData];

    }else if (self.orderNumBtn.selected == YES && [self.orderNumBtn.currentTitle  isEqual: @"订单数排序 ↓"]){
        [self.orderNumBtn setSelected:YES];
        [self.orderNumBtn setTitle:@"订单数排序 ↑" forState:UIControlStateNormal];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"4" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
        [self.table reloadData];

    }else if (self.orderNumBtn.selected == YES && [self.orderNumBtn.currentTitle  isEqual: @"订单数排序 ↑"]){
        [self.orderNumBtn setSelected:YES];
        [self.orderNumBtn setTitle:@"订单数排序 ↓" forState:UIControlStateNormal];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"3" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
        [self.table reloadData];

    }
}
- (IBAction)wordOrderAction:(id)sender {
    [self.timeBtn setSelected:NO];
    [self.orderNumBtn setSelected:NO];
    if (self.wordBtn.selected == NO) {
        [self.wordBtn setSelected:YES];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"5" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
        [self.table reloadData];
    }else if (self.wordBtn.selected == YES && [self.wordBtn.currentTitle  isEqual: @"字母排序 ↓"]){
        [self.wordBtn setSelected:YES];
        [self.wordBtn setTitle:@"字母排序 ↑" forState:UIControlStateNormal];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"6" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
        [self.table reloadData];

    }else if (self.wordBtn.selected == YES && [self.wordBtn.currentTitle  isEqual: @"字母排序 ↑"]){
        [self.wordBtn setSelected:YES];
        [self.wordBtn setTitle:@"字母排序 ↓" forState:UIControlStateNormal];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"5" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
        [self.table reloadData];

           }

}

- (IBAction)customSearch:(id)sender {
    self.searchTextField.hidden = NO;
    self.cancelSearchOutlet.hidden = NO;
    [self.searchTextField becomeFirstResponder];
}
- (IBAction)cancelSearch:(id)sender {
    self.cancelSearchOutlet.hidden = YES;
    self.searchTextField.hidden = YES;
    
    [self.searchTextField resignFirstResponder];
}
@end
