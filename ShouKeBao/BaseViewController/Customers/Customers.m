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
#import "WMAnimations.h"
#import "MJRefresh.h"
#import "WriteFileManager.h"
@interface Customers ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,notifiCustomersToReferesh>
@property (nonatomic,strong) NSMutableArray *dataArr;
- (IBAction)addNewUser:(id)sender;
- (IBAction)importUser:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
//@property (weak, nonatomic) IBOutlet UIButton *orderNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *wordBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelSearchOutlet;
@property (weak, nonatomic) IBOutlet UIButton *searchCustomerBtnOutlet;
@property (copy,nonatomic) NSMutableString *callingPhoneNum;
- (IBAction)cancelSearch;

//1、 时间顺序;2、时间倒序; 3-订单数顺序;4、订单数倒序 5,字母顺序 6，字母倒序
@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet UITableView *historyTable;
@property (nonatomic,strong) NSMutableArray *historyArr;
@property (weak, nonatomic) IBOutlet UIView *conditionLine;

@end

@implementation Customers

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.timeBtn setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateSelected];
    [self.timeBtn setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateHighlighted];
[self.timeBtn setTitleColor:[UIColor colorWithRed:14/255.f green:123/255.f blue:225/255.f alpha:1] forState:UIControlStateSelected];

   // [self.orderNumBtn setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateSelected];
    //[self.orderNumBtn setTitleColor:[UIColor colorWithRed:14/255.f green:123/255.f blue:225/255.f alpha:1] forState:UIControlStateSelected];
 //[self.orderNumBtn setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateHighlighted];
    
    [self.wordBtn setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateSelected];
    [self.wordBtn setTitleColor:[UIColor colorWithRed:14/255.f green:123/255.f blue:225/255.f alpha:1] forState:UIControlStateSelected];
     [self.wordBtn setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateHighlighted];
   self.title = @"管客户";
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.rowHeight = 64;
    //[self loadDataSource];
    [self customerRightBarItem];
    self.searchTextField.delegate = self;
    [self.timeBtn setSelected:YES];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.searchCustomerBtnOutlet.layer andBorderColor:[UIColor whiteColor] andBorderWidth:0.5 andNeedShadow:NO];
    
    self.table.separatorStyle = UITableViewCellAccessoryNone;
    
    self.historyTable.tableFooterView = [[UIView alloc] init];
    
 CGFloat mainWid = [[UIScreen mainScreen] bounds].size.width;
    UIView *lineOn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWid, 0.5)];
    lineOn.backgroundColor = [UIColor colorWithRed:177/255.f green:177/255.f blue:177/255.f alpha:1];
    UIView *lineDown = [[UIView alloc] initWithFrame:CGRectMake(0, self.conditionLine.frame.size.height-0.5, mainWid, 0.5)];
    lineDown.backgroundColor = [UIColor colorWithRed:177/255.f green:177/255.f blue:177/255.f alpha:1];
    
   [self.conditionLine addSubview:lineDown];
    [self.conditionLine addSubview:lineOn];

}
#pragma  -mark batchAdd delegate
-(void)referesh
{
    [self loadDataSource];
}
-(void)initPull
{
   
    //下拉
    [self.table addHeaderWithTarget:self action:@selector(headerPull)];
    [self.table headerBeginRefreshing];
    
    self.table.headerPullToRefreshText =@"刷新内容";
    self.table.headerRefreshingText = @"正在刷新";
}

-(void)headerPull
{
    [self loadDataSource];
        [self.table headerEndRefreshing];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//    [hudView show:YES];
//    hudView.labelText = @"加载中...";
    [self loadDataSource];
    //[hudView show:NO];
    
    [self initPull];
    
    
    }

-(void)customerRightBarItem
{

    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(setSubViewUp)];
    
    self.navigationItem.rightBarButtonItem= barItem;
}


-(void)setSubViewUp
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

-(NSMutableArray *)historyArr
{
    if (_historyArr == nil) {
       
        self.historyArr = [NSMutableArray array];
    }
    return _historyArr;
}

-(NSMutableString *)callingPhoneNum
{
    if (_callingPhoneNum == nil) {
        self.callingPhoneNum = [[NSMutableString alloc] init];
    }
    return _callingPhoneNum;
}

- (IBAction)addNewUser:(id)sender {
    self.subView.hidden = YES;
    addCustomerViewController *add = [[addCustomerViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
    
}

- (IBAction)importUser:(id)sender {
    self.subView.hidden = YES;
    BatchAddViewController *batch = [[BatchAddViewController alloc] init];
    batch.delegate = self;
    [self.navigationController pushViewController:batch animated:YES];
}



-(void)loadDataSource
{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"PageIndex"];
    [dic setObject:@"500" forKey:@"PageSize"];
   NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sortType = [accountDefaults stringForKey:@"sortType"];
    if (sortType) {
        [dic setObject:sortType forKey:@"sortType"];
    }else if (!sortType){
        [dic setObject:@"1" forKey:@"sortType"];
}
    
    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomerList" params:dic success:^(id json) {
        NSLog(@"------管客户json is %@-------",json);
        [self.dataArr removeAllObjects];
        for(NSDictionary *dic in  json[@"CustomerList"]){
            CustomModel *model = [CustomModel modalWithDict:dic];
            [self.dataArr addObject:model];
        }
        [self.table reloadData];
//        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window]
//    animated:YES];

    } failure:^(NSError *error) {
        NSLog(@"-------管客户第一个接口请求失败 error is %@------",error);
    }];

   }



-(void)loadHistoryArr
{
    NSMutableArray *searchArr = [WriteFileManager WMreadData:@"customerSearch"];
    self.historyArr = searchArr;
    [self.historyTable reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        CustomerDetailViewController *detail = [[CustomerDetailViewController alloc] init];
        CustomModel *model = _dataArr[indexPath.row];
        detail.QQStr = model.QQCode;
        detail.ID = model.ID;
        detail.weChatStr = model.WeiXinCode;
        detail.teleStr = model.Mobile;
        detail.noteStr = model.Remark;
        detail.userNameStr = model.Name;
        detail.customMoel = model;
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    if (tableView.tag == 2) {
        
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
          return self.dataArr.count;
    }
    if (tableView.tag == 2) {
        return self.historyArr.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        CustomCell *cell = [CustomCell cellWithTableView:tableView];
        CustomModel *model = _dataArr[indexPath.row];
        cell.model = model;
        
        return cell;
    }
    if (tableView.tag == 2) {
        static NSString *historyID = @"history";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyID];
        }
        cell.textLabel.text = self.historyArr[indexPath.row];
        return cell;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 2) {
        UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.historyTable.frame.size.width, 44)];
        UIButton *clean = [UIButton buttonWithType:UIButtonTypeCustom];
        [clean setTitle:@"清除历史纪录" forState:UIControlStateNormal];
        [clean setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        clean.frame = foot.frame;
        [clean addTarget:self action:@selector(cleanHistory) forControlEvents:UIControlEventTouchUpInside];
        [foot addSubview:clean];
        
        return foot;
    }
    return 0;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 2) {
        return 44;
    }
    return 0;
}


-(void)cleanHistory
{
    [self.historyArr removeAllObjects];
    //[self.historyArr addObject:@""];
    [WriteFileManager WMsaveData:_historyArr name:@"customerSearch"];
    [self.historyTable reloadData];
}


#pragma mark - textField delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.window.transform = CGAffineTransformMakeTranslation(0, 0);
        
    }];

    [self.historyArr addObject:self.searchTextField.text];
    [WriteFileManager WMsaveData:_historyArr name:@"customerSearch"];
    [self cancelSearch];
    
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
  //  [self.orderNumBtn setSelected:NO];
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    
    hudView.labelText = @"加载中...";
    
    [hudView show:YES];
    
    [self.wordBtn setSelected:NO];
    
    
    if (self.timeBtn.selected == NO) {
        [self.timeBtn setSelected:YES];
         NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"1" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
      //  [self.table reloadData];

    }else if (self.timeBtn.selected == YES && [self.timeBtn.currentTitle  isEqual: @"时间排序 ↓"]) {
        [self.timeBtn setSelected:YES];
        [self.timeBtn setTitle:@"时间排序 ↑" forState:UIControlStateNormal];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"2" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
       // [self.table reloadData];

    }else if (self.timeBtn.selected == YES &&[self.timeBtn.currentTitle isEqual:@"时间排序 ↑"]){
        [self.timeBtn setSelected:YES];
        [self.timeBtn setTitle:@"时间排序 ↓" forState:UIControlStateNormal];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"1" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
      //  [self.table reloadData];

    }
    [hudView hide:YES];
    
}


- (IBAction)wordOrderAction:(id)sender {
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"加载中...";
    [hudView show:YES];
    
    
    [self.timeBtn setSelected:NO];
   // [self.orderNumBtn setSelected:NO];
    if (self.wordBtn.selected == NO) {
        [self.wordBtn setSelected:YES];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"5" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
        //[self.table reloadData];
    }else if (self.wordBtn.selected == YES && [self.wordBtn.currentTitle  isEqual: @"字母排序 ↓"]){
        [self.wordBtn setSelected:YES];
        [self.wordBtn setTitle:@"字母排序 ↑" forState:UIControlStateNormal];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"6" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
       // [self.table reloadData];

    }else if (self.wordBtn.selected == YES && [self.wordBtn.currentTitle  isEqual: @"字母排序 ↑"]){
        [self.wordBtn setSelected:YES];
        [self.wordBtn setTitle:@"字母排序 ↓" forState:UIControlStateNormal];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"5" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
        //[self.table reloadData];

           }
    [hudView hide:YES];

}

- (IBAction)customSearch:(id)sender {
    self.searchTextField.hidden = NO;
    self.cancelSearchOutlet.hidden = NO;
    self.searchCustomerBtnOutlet.hidden = YES;
    [self.searchTextField becomeFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{

        self.view.window.transform = CGAffineTransformMakeTranslation(0, -64);
  
       // self.inputView.transform = CGAffineTransformMakeTranslation(0, 20);
     
        self.historyView.hidden = NO;
        //[[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    }];
    
    [self loadHistoryArr];
   

}
- (IBAction)cancelSearch {
    self.cancelSearchOutlet.hidden = YES;
    self.searchTextField.hidden = YES;
    self.searchCustomerBtnOutlet.hidden = NO;
    [self.searchTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.window.transform = CGAffineTransformMakeTranslation(0, 0);
        self.historyView.hidden = YES;
       // [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    }];

}
@end
