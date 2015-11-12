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
//#import "addCustomerViewController.h"
#import "AddViewController.h"

#import "BatchAddViewController.h"
#import "MBProgressHUD+MJ.h"
#import "WMAnimations.h"
#import "MJRefresh.h"
#import "WriteFileManager.h"
#import "NSArray+QD.h"
#import "NSString+QD.h"
#import "MobClick.h"
#import "EditCustomerDetailViewController.h"
#import "BaseClickAttribute.h"
#import "ScanningViewController.h"
#import "CustomerDetailAndOrderViewController.h"
#import "ArrowBtn.h"

#import "SKSearchBar.h"
#import "SKSearckDisplayController.h"
#define searchDefaultPlaceholder @"客户名/电话号码"
#define searchHistoryPlaceholder @"请输入客户姓名/电话"
#import "SearchView.h"

#define pageSize 10
//协议传值4:在使用协议之前,必须要签订协议 由Customer签订
@interface Customers ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,notifiCustomersToReferesh,AddCustomerToReferesh, DeleteCustomerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;
- (IBAction)addNewUser:(id)sender;
- (IBAction)importUser:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
//@property (weak, nonatomic) IBOutlet UIButton *orderNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *wordBtn;
@property (copy,nonatomic) NSMutableString *callingPhoneNum;
@property (weak, nonatomic) IBOutlet UIButton *batchCustomerBtn;

//1、 时间顺序;2、时间倒序; 3-订单数顺序;4、订单数倒序 5,字母顺序 6，字母倒序
@property (nonatomic,weak) SearchView *historyView;
//@property (weak, nonatomic) IBOutlet UITableView *historyTable;
@property (nonatomic,strong) NSMutableArray *historyArr;
//两个button的父视图
@property (weak, nonatomic) IBOutlet UIView *conditionLine;
@property (nonatomic, strong)ArrowBtn * timeButton;
@property (nonatomic, strong)ArrowBtn * wordButton;

@property (weak,nonatomic) IBOutlet UIImageView *imageViewWhenIsNull;
@property (weak, nonatomic) IBOutlet UIButton *addNew;
@property (weak, nonatomic) IBOutlet UIButton *importUser;
@property(nonatomic,copy) NSString *searchK;
@property (strong, nonatomic) IBOutlet UIButton *cardCamer;

@property (nonatomic,strong) NSString *ID;
//分页
@property (nonatomic,assign)int pageIndex;// 当前页
@property (nonatomic,assign) BOOL isRefresh;
@property (nonatomic,copy) NSString *totalNumber;
@property (nonatomic, strong)NSMutableArray *arr;
@property(weak,nonatomic) UILabel *noProductWarnLab;
//搜索改写
@property (nonatomic,strong) SKSearchBar *searchBar;
@property (nonatomic,strong) SKSearckDisplayController *searchDisplay;
@property (nonatomic,weak) UIView *sep2;
@property (nonatomic,strong) NSMutableArray *chooseAppArr;
@property (nonatomic, strong)NSMutableArray *A_Z_arr;
@end

@implementation Customers


-(void)dealloc
{
//    只要注册一个观察者,一定要在类的dealloc方法中, 移除掉自己的观察者身份
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.searchBar];
    //1[self.view sendSubviewToBack:self.searchBar];
    [self searchDisplay];
    
    self.chooseAppArr = [NSMutableArray arrayWithObjects:@"不限", @"新绑定APP客户", @"绑定APP客户", @"其他客户", nil];
    self.A_Z_arr = [NSMutableArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G",@"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", nil];
    
    self.pageIndex = 1;
    [self.dataArr removeAllObjects];
    self.navigationItem.leftBarButtonItem = nil;
    [self.addNew setBackgroundColor:[UIColor colorWithRed:13/255.f green:122/255.f blue:255/255.f alpha:1]];
    [self.importUser setBackgroundColor:[UIColor colorWithRed:13/255.f green:122/255.f blue:255/255.f alpha:1]];
    [self.timeBtn setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateSelected];
    [self.timeBtn setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateHighlighted];
    [self.timeBtn setTitleColor:[UIColor colorWithRed:14/255.f green:123/255.f blue:225/255.f alpha:1] forState:UIControlStateSelected];
    [self.wordBtn setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateSelected];
    [self.wordBtn setTitleColor:[UIColor colorWithRed:14/255.f green:123/255.f blue:225/255.f alpha:1] forState:UIControlStateSelected];
    [self.wordBtn setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateHighlighted];
    self.timeBtn.hidden = YES;
    self.wordBtn.hidden = YES;
//    self.title = @"管客户";
    [self customerCenterBarItem];

    
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.rowHeight = 64;
    
    [self.timeBtn setSelected:YES];

    self.table.separatorStyle = UITableViewCellAccessoryNone;
    self.table.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:238/255.0 alpha:1];
    [self customerRightBarItem];
    
    [self initPull];
    [self setContentView];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(receiveNotification:) name:@"下班" object:nil];
  
}
- (void)setContentView{
    CGFloat mainWid = [[UIScreen mainScreen] bounds].size.width;
    UIView *lineOn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWid, 0.5)];
    lineOn.backgroundColor = [UIColor colorWithRed:177/255.f green:177/255.f blue:177/255.f alpha:1];
    UIView *lineDown = [[UIView alloc] initWithFrame:CGRectMake(0, self.conditionLine.frame.size.height-0.5, mainWid, 0.5)];
    lineDown.backgroundColor = [UIColor colorWithRed:177/255.f green:177/255.f blue:177/255.f alpha:1];
    [self.conditionLine addSubview:lineDown];
    ArrowBtn *leftBtn = [[ArrowBtn alloc] init];
    [leftBtn addTarget:self action:@selector(timeOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.conditionLine addSubview:leftBtn];
    self.timeButton = leftBtn;
    
    ArrowBtn *rightBtn = [[ArrowBtn alloc] init];
    [rightBtn addTarget:self action:@selector(wordOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.conditionLine addSubview:rightBtn];
    self.wordButton = rightBtn;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    self.timeButton.frame = CGRectMake(0, 0, screenW * 0.5 - 0.5, self.conditionLine.frame.size.height);
        
    CGFloat rightX = CGRectGetMaxX(self.timeButton.frame) + 1;
    self.wordButton.frame = CGRectMake(rightX, 0, screenW * 0.5 - 0.5, self.conditionLine.frame.size.height);
    
    self.timeButton.text = @"时间排序";
    self.wordButton.text = @"字母排序";
    [self.conditionLine addSubview:self.timeButton];
    [self.conditionLine addSubview:self.wordButton];
}

//4,收到通知中心的消息时,观察者(self)要调用方法
- (void)receiveNotification:(NSNotification *)noti
{
    [self initPull];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      self.subView.hidden = YES;
    [self.table reloadData];
//    NSUserDefaults *customer = [NSUserDefaults standardUserDefaults];
//    NSString *appIsBack = [customer objectForKey:@"appIsBack"];
//    NSLog(@"appIsBack---- %@", appIsBack);
//    if ([appIsBack isEqualToString:@"no"]) {
//        [self initPull];
//    }
//    [customer synchronize];
    [MobClick beginLogPageView:@"Customers"];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historySearch:) name:@"CustomerHistorySearch" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Customers"];
}

-(void)initPull
{
    [self.table addHeaderWithTarget:self action:@selector(headPull)dateKey:nil];
    [self.table headerBeginRefreshing];
    [self.table addFooterWithTarget:self action:@selector(foodPull)];
    [self.table footerBeginRefreshing];
    self.table.headerPullToRefreshText = @"下拉刷新";
    self.table.headerRefreshingText = @"正在刷新中";
    self.table.footerPullToRefreshText = @"上拉刷新";
    self.table.footerRefreshingText = @"正在刷新";
    
}
//下拉刷新
-(void)headPull
{
    self.isRefresh = YES;
    self.pageIndex = 1;
    self.searchBar.placeholder = searchDefaultPlaceholder;
    [self loadDataSource];
}
//  上啦加载
- (void)foodPull
{
    [self.noProductWarnLab removeFromSuperview];
    self.isRefresh = NO;
    self.pageIndex++;
    if (self.pageIndex  > [self getTotalPage]) {
        [self.table footerEndRefreshing];
        //        [self warning];
    }else{
        [self loadDataSource];
    }
}

- (NSInteger)getTotalPage
{
    NSInteger cos = [self.totalNumber integerValue] % pageSize;
    if (cos == 0) {
        return [self.totalNumber integerValue] / pageSize;
    }else{
        NSLog(@"[self.totalNumber integerValue] / pageSize = %ld", [self.totalNumber integerValue] / pageSize + 1);
        return [self.totalNumber integerValue] / pageSize + 1;
    }
}



-(void)customerRightBarItem{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(setSubViewUp)];
    self.navigationItem.rightBarButtonItem= barItem;
}

-(void)customerCenterBarItem{
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 50, 100);
    [button setTitle:@"管客户" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"sanjiao"] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 15)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(20, 63, 20, 0)];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [button addTarget:self action:@selector(popCustomersAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
    
}
- (void)popCustomersAction:(UIButton *)button{
    self.popTableview.delegate = self;
    self.popTableview.dataSource = self;
    self.popTableview.hidden = NO;
   
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self subViewHidden];
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
        [self subViewHidden];
    }
}
- (void)subViewHidden{
    [UIView animateWithDuration:0.8 animations:^{
        self.subView.alpha = 1;
        self.subView.alpha = 0;
        self.subView.hidden = YES;
    }];
}

#pragma -mark getter
- (NSMutableArray *)chooseAppArr{
    if (!_chooseAppArr) {
        _chooseAppArr = [NSMutableArray array];
    }
    return _chooseAppArr;
}
-(NSMutableArray *)A_Z_arr{
    if (_A_Z_arr == nil) {
        _A_Z_arr = [NSMutableArray array];
    }
    return _A_Z_arr;
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
- (SKSearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[SKSearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.conditionLine.bounds.size.height)];
        _searchBar.delegate = self;
        _searchBar.barStyle = UISearchBarStyleDefault;
        _searchBar.translucent = NO;
        _searchBar.placeholder = searchDefaultPlaceholder;
        _searchBar.barTintColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    }
    
    return _searchBar;
}
- (SKSearckDisplayController *)searchDisplay
{
    if (!_searchDisplay) {
        _searchDisplay = [[SKSearckDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchDisplay.delegate = self;
        _searchDisplay.searchResultsTableView.backgroundColor = [UIColor clearColor];
        _searchDisplay.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _searchDisplay;
}
- (IBAction)addNewUser:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    AddViewController *addVC = [sb instantiateViewControllerWithIdentifier:@"AddCustomer"];
    addVC.delegate = self;
    [self.navigationController pushViewController:addVC animated:YES];
    
}


- (IBAction)addFormCardCamer:(id)sender {
    ScanningViewController * scanVC = [[ScanningViewController alloc]init];
    scanVC.isFromCostom = YES;
    scanVC.isLogin = YES;
    scanVC.VC = self;
    [self.navigationController pushViewController:scanVC animated:YES];
    
}

#pragma -mark 添加客户成功后的代理方法（刷新列表）
-(void)toRefereshCustomers{
    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"sortType"];
    [self.table headerBeginRefreshing];
}
#pragma  -mark batchAdd delegate
-(void)referesh{
    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"sortType"];
    [self.table headerBeginRefreshing];
}

- (IBAction)importUser:(id)sender {
 
//    NSString *systemVersion   = [[UIDevice currentDevice] systemVersion];
//    if ([systemVersion intValue]<8.0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"通讯许访问仅允许在IOS8.0以上系统版本" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//        [alert show];
//        self.subView.hidden = YES;
//    }else if ([systemVersion intValue] >= 8.0){
    self.subView.hidden = YES;
    BatchAddViewController *batch = [[BatchAddViewController alloc] init];
    batch.delegate = self;
        [self.navigationController pushViewController:batch animated:YES];
  //  }
}



-(void)loadDataSource{
     [self.noProductWarnLab removeFromSuperview];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%d", self.pageIndex] forKey:@"PageIndex"];
    [dic setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"PageSize"];
    
//    if (_searchK.length>0) {
//        [dic setObject:_searchK forKey:@"SearchKey"];
//    }
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sortType = [accountDefaults stringForKey:@"sortType"];
    if (sortType) {
        [dic setObject:sortType forKey:@"sortType"];
    }else if (!sortType){
        [dic setObject:@"2" forKey:@"sortType"];
}
    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomerList" params:dic success:^(id json) {
        NSLog(@"------管客户json is %@-------",json);
        if (self.isRefresh) {
            [self.dataArr removeAllObjects];
        }
        self.totalNumber = json[@"TotalCount"];
        
        NSLog(@"__________ %ld", [json[@"CustomerList"]count]);
        NSLog(@"__________ %@", json[@"CustomerList"]);

        // 当再无加载数据时提示没有客户的信息
       self.arr = json[@"CustomerList"];
        if (self.arr.count == 0) {
//            [self warning];
        }else{
        for(NSDictionary *dic in  json[@"CustomerList"]){
            CustomModel *model = [CustomModel modalWithDict:dic];
            [self.dataArr addObject:model];
        }
    
        [self.table reloadData];
        if (_dataArr.count==0) {
           self.imageViewWhenIsNull.hidden = NO ;
        }else if (_dataArr.count>0){
            self.imageViewWhenIsNull.hidden = YES ;
        } }
        [self.table headerEndRefreshing];
        [self.table footerEndRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"-------管客户第一个接口请求失败 error is %@------",error);
    }];

   }

#pragma mark - 加载完事时显示的内容
- (void)warning
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, 20)];
    label.text = @"抱歉，没有更多客户了😢";
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.table.tableFooterView = label;
    self.noProductWarnLab = label;
}

-(void)loadHistoryArr{   
    NSArray *tmp = [WriteFileManager readFielWithName:@"customerSearch"];
    NSMutableArray *searchArr = [NSMutableArray arrayWithArray:tmp];
   self.historyArr = searchArr;

//    NSMutableArray *searchArr = [WriteFileManager WMreadData:@"customerSearch"];
//    self.historyArr = searchArr;
//    [self.historyTable reloadData];
    NSLog(@"sssss");

}
#pragma mark - 删除客户时调用的内容
- (void)deleteTableViewCellwithId:(NSString *)ID
{
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"删除中...";
    [hudView show:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:ID forKey:@"CustomerID"];

    [IWHttpTool WMpostWithURL:@"/Customer/DeleteCustomer" params:dic success:^(id json) {
        NSLog(@"删除客户信息成功%@",json);
        hudView.labelText = @"删除成功...";
        [hudView hide:YES afterDelay:0.4];
        
    } failure:^(NSError *error) {
        NSLog(@"删除客户请求失败%@",error);
    }];
}
- (void)deselect
{
    [self.table deselectRowAtIndexPath:[self.table indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.table == tableView) {

        CustomModel *model = _dataArr[indexPath.row];
        CustomerDetailAndOrderViewController * VC = [[CustomerDetailAndOrderViewController  alloc]init];
        VC.customVC = self;
        VC.keyWords = self.searchK;
        VC.model = model;
    NSLog(@"%@",         model);
        [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (self.popTableview == tableView){
        
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.table == tableView) {
        return self.dataArr.count;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.table == tableView) {

        CustomCell *cell = [CustomCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        CustomModel *model = _dataArr[indexPath.row];
        cell.model = model;
        self.ID = cell.model.ID;
        
        return cell;
    }else{
        static NSString *cellID = @"popCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
         cell.textLabel.text = [self.chooseAppArr objectAtIndex:indexPath.row];
        
        return cell;
    }
}

//设置区头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.table == tableView) {
       return 5.0f;
    }else{
        return 0.1f;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.table == tableView) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, 40)];
        view.backgroundColor = self.table.backgroundColor;
        
        UILabel *lableT = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.table.frame.size.width-10, 40)];
        lableT.font = [UIFont systemFontOfSize:15.0f];
        lableT.text = [self.A_Z_arr objectAtIndex:section];
        [view addSubview:lableT];
        return view;
        
    }else{
        UIView *view = [[UIView alloc]init];
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (tableView.tag == 2) {
//        return 44;
//    }
    return 0.01f;
}
/*
 右滑动删除客户
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.table == tableView) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            CustomModel *model = _dataArr[indexPath.row];
            [self deleteTableViewCellwithId:model.ID];
            // 删除这行
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.table == tableView) {
      return @"删除";
    }
    return nil;
}


- (IBAction)timeOrderAction:(id)sender {
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"TimeOrderClick" attributes:dict];

    self.timeButton.textColor = [UIColor colorWithRed:0 green:99/255.0 blue:1.0 alpha:1.0];
    self.wordButton.textColor = [UIColor blackColor];
//    if ([self.wordButton.iconImage isEqual:[UIImage imageNamed:@"xiangxiablue"]]) {
        self.wordButton.iconImage = [UIImage imageNamed:@"xiangxia"];
//    }else{
//        self.wordButton.iconImage = [UIImage imageNamed:@"xiangshang"];
//    }
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    
    hudView.labelText = @"加载中...";
    
    [hudView show:YES];
    
    [self.wordBtn setSelected:NO];
    
    self.pageIndex = 1;
    if (self.timeBtn.selected == NO) {
        [self.timeBtn setSelected:YES];
         NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"2" forKey:@"sortType"];
        self.timeButton.iconImage = [UIImage imageNamed:@"xiangxiablue"];

        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
      //  [self.table reloadData];

    }else if (self.timeBtn.selected == YES && [self.timeBtn.currentTitle  isEqual: @"时间排序 ↓"]) {
        [self.timeBtn setSelected:YES];
        
        [self.timeBtn setTitle:@"时间排序 ↑" forState:UIControlStateNormal];
        //向上箭头设置；
        self.timeButton.iconImage = [UIImage imageNamed:@"xiangshangblue"];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"1" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
       // [self.table reloadData];

    }else if (self.timeBtn.selected == YES &&[self.timeBtn.currentTitle isEqual:@"时间排序 ↑"]){
        [self.timeBtn setSelected:YES];
        [self.timeButton setSelected:YES];

        [self.timeBtn setTitle:@"时间排序 ↓" forState:UIControlStateNormal];
        self.timeButton.iconImage = [UIImage imageNamed:@"xiangxiablue"];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"2" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
      //  [self.table reloadData];

    }
    [hudView hide:YES];
}


- (IBAction)wordOrderAction:(id)sender {
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"WordOrderClick" attributes:dict];
    self.timeButton.textColor = [UIColor blackColor];
    self.wordButton.textColor = [UIColor colorWithRed:0 green:99/255.0 blue:1.0 alpha:1.0];
//    if ([self.timeButton.iconImage isEqual:[UIImage imageNamed:@"xiangshangblue"]]) {
//        self.timeButton.iconImage = [UIImage imageNamed:@"xiangshang"];
//    }else{
        self.timeButton.iconImage = [UIImage imageNamed:@"xiangxia"];
//    }
    self.pageIndex = 1;
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"加载中...";
    [hudView show:YES];
    
    
    [self.timeBtn setSelected:NO];
   // [self.orderNumBtn setSelected:NO];
    if (self.wordBtn.selected == NO) {
        [self.wordBtn setSelected:YES];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"6" forKey:@"sortType"];
        self.wordButton.iconImage = [UIImage imageNamed:@"xiangxiablue"];

        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
        //[self.table reloadData];
    }else if (self.wordBtn.selected == YES && [self.wordBtn.currentTitle  isEqual: @"字母排序 ↓"]){
        [self.wordBtn setSelected:YES];

        [self.wordBtn setTitle:@"字母排序 ↑" forState:UIControlStateNormal];
           self.wordButton.iconImage = [UIImage imageNamed:@"xiangshangblue"];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"5" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
       // [self.table reloadData];

    }else if (self.wordBtn.selected == YES && [self.wordBtn.currentTitle  isEqual: @"字母排序 ↑"]){
        [self.wordBtn setSelected:YES];

        [self.wordBtn setTitle:@"字母排序 ↓" forState:UIControlStateNormal];
        self.wordButton.iconImage = [UIImage imageNamed:@"xiangxiablue"];
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"6" forKey:@"sortType"];
        [accountDefaults synchronize];
        [self.dataArr removeAllObjects];
        [self loadDataSource];
        //[self.table reloadData];

           }
    [hudView hide:YES];

}

//协议传值6:由第一页实现协议方法
- (void)deleteCustomerWith:(NSString *)keyWords{
    [self initPull];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - UISearchBar的delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
// 这个方法里面纯粹调样式
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    for (UIView *searchbuttons in [[searchBar.subviews objectAtIndex:0] subviews])
    {if ([searchbuttons isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton *)searchbuttons;
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"取消"];
            NSMutableDictionary *muta = [NSMutableDictionary dictionary];
            [muta setObject:[UIColor colorWithRed:68/255.0 green:122/255.0 blue:208/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
            [muta setObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
            [attr addAttributes:muta range:NSMakeRange(0, 2)];
            [cancelButton setAttributedTitle:attr forState:UIControlStateNormal];
            
            break;
        }else{
            UITextField *textField = (UITextField *)searchbuttons;
            // 边界线
            CGFloat sepX = CGRectGetMaxX(textField.frame);
            UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(sepX, 25, 0.5, 34)];
            sep2.backgroundColor = [UIColor lightGrayColor];
            sep2.alpha = 0.3;
            [self.view.window addSubview:sep2];
            self.sep2 = sep2;
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *trimStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.searchK = trimStr;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
//    [MobClick event:@"CumtomerSearchClick" attributes:dict];
    
    [self.searchDisplayController setActive:NO animated:YES];
    
    if (self.searchK.length) {
        [searchBar endEditing:YES];
        
        NSMutableArray *tmp = [NSMutableArray array];
        
        // 先取出原来的记录
        NSArray *arr = [WriteFileManager readFielWithName:@"CustomerHistorySearch"];
        [tmp addObjectsFromArray:arr];
        
        // 再加上新的搜索记录
        [tmp addObject:self.searchK];
        
        // 并保存
        [WriteFileManager saveFileWithArray:tmp Name:@"CustomerHistorySearch"];
        [self searchLoadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UISearchDisplayDelegate
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{// 纯粹调节样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.searchBar.barTintColor = [UIColor whiteColor];
    
    // 历史记录的界面
    SearchView *searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height + 49)];
    searchView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    [self.view.window addSubview:searchView];
    self.historyView = searchView;
    
    self.searchBar.placeholder = searchHistoryPlaceholder;
    self.searchBar.text = self.searchK;
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.sep2 removeFromSuperview];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.searchBar.barTintColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    [self.historyView removeFromSuperview];
    [self.sep2 removeFromSuperview];
    if (self.searchK.length){
        self.searchBar.placeholder = self.searchK;
        NSLog(@"self.searchK = %@", self.searchK);
    }else{
        self.searchBar.placeholder = searchDefaultPlaceholder;
    }

}
- (void)historySearch:(NSNotification *)noty
{
    self.searchK = noty.userInfo[@"historyKey"];
    [self.searchDisplayController setActive:NO animated:YES];
    [self searchLoadData];
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.hidden = YES;
}

#pragma mark - textField delegate method
- (void)searchLoadData
{
    if (self.historyArr.count > 6) {
        [self.historyArr removeObjectAtIndex:0];
    }
//    NSArray *tmp = [NSArray arrayWithMemberIsOnly:self.historyArr];
//    [WriteFileManager saveFileWithArray:tmp Name:@"customerSearch"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@1 forKey:@"PageIndex"];
    [dic setObject:@"100" forKey:@"PageSize"];
    [dic setObject:self.searchK forKey:@"SearchKey"];

    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomerList" params:dic success:^(id json) {
        NSLog(@"------管客户搜索结果的json is %@-------",json);
        [self.dataArr removeAllObjects];
        for(NSDictionary *dic in json[@"CustomerList"]){
            CustomModel *model = [CustomModel modalWithDict:dic];
            [self.dataArr addObject:model];
        }
        
        [self.table reloadData];
        if (self.dataArr.count == 0) {
            self.imageViewWhenIsNull.hidden = NO;
        }else if (self.dataArr.count >0){
            self.imageViewWhenIsNull.hidden = YES;
        }
    } failure:^(NSError *error) {
        NSLog(@"-------管客户第一个接口请求失败 error is %@------",error);
    }];
}





@end
