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
#import "CustomerSection.h"
#import "ChatViewController.h"

#define pageSize 10
//协议传值4:在使用协议之前,必须要签订协议 由Customer签订
@interface Customers ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,notifiCustomersToReferesh,AddCustomerToReferesh, DeleteCustomerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, transformPerformation, notifiSKBToReferesh>

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
@property(nonatomic, copy) NSString *searchK;
@property (strong, nonatomic) IBOutlet UIButton *cardCamer;

@property (nonatomic, strong) NSString *ID;
//分页
@property (nonatomic, assign)int pageIndex;// 当前页
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, copy) NSString *totalNumber;
@property (nonatomic, strong)NSMutableArray *arr;
@property (weak, nonatomic) UILabel *noProductWarnLab;
//搜索改写
@property (nonatomic, strong) SKSearchBar *searchBar;
@property (nonatomic, strong) SKSearckDisplayController *searchDisplay;
@property (nonatomic, weak) UIView *sep2;
@property (nonatomic, strong) NSMutableArray *chooseAppArr;
@property (nonatomic, strong) NSArray *orderAppArr;

@property (nonatomic, assign)BOOL popFlag;
@property (nonatomic, assign)BOOL isDownLoad;

@property (nonatomic, strong)UILabel *CustomerCounts;
@property (nonatomic, strong)NSMutableArray *Array;
@property (nonatomic, assign)NSInteger peopleN;
//@property (nonatomic, strong)CustomerSection *costomerModel;
@property (nonatomic, strong)NSMutableArray *newsBindingCustomArr;
@property (nonatomic, strong)NSMutableArray *hadBindingCustomArr;
@property (nonatomic, strong)NSMutableArray *otherCustomArr;
@property (nonatomic, copy)NSString *InvitationInfo;
@property (weak, nonatomic) IBOutlet UIView *tableSuper;


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
  
    [self getNotifiList];
    [self customerCenterBarItem];
    self.popTableview.delegate = self;
    self.popTableview.dataSource = self;
    
    [self searchDisplay];
    
    self.chooseAppArr = [NSMutableArray arrayWithObjects:@"不限", @"新绑定APP客户", @"绑定APP客户", @"其他客户", nil];

//    self.A_Z_arr = [NSMutableArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G",@"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", nil];
    
    self.pageIndex = 1;
    [self.dataArr removeAllObjects];
    self.navigationItem.leftBarButtonItem = nil;
    [self.addNew setBackgroundColor:[UIColor colorWithRed:13/255.f green:122/255.f blue:255/255.f alpha:1]];
    [self.importUser setBackgroundColor:[UIColor colorWithRed:13/255.f green:122/255.f blue:255/255.f alpha:1]];
   
    [self.timeBtn setSelected:YES];
    [self customerRightBarItem];
    [self setTable];
//    [self CustomerCounts];
    [self initPull];
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(receiveNotification:) name:@"下班" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealPushBackGround:) name:@"pushWithBackGround" object:nil];
    [self tapGestionToMessVC];
    [self tapGestionToMessVC1];
}

- (void)setTable{
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.rowHeight = 64;
    self.table.separatorStyle = UITableViewCellAccessoryNone;
    self.table.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:238/255.0 alpha:1];
    [self CustomerCounts];
}


#warning 消息点击事件
#pragma mark -代理方法
- (void)transformPerformation:(CustomModel *)model{
//    NSLog(@"%@", model.AppSkbUserId);
    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:model.AppSkbUserId conversationType:eConversationTypeChat];
    chatController.title = model.Name;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)receiveNotification:(NSNotification *)noti{
    [self initPull];
}
-(void)toRefereshCustomers{
//    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"sortType"];
    
    [self.table headerBeginRefreshing];
}
-(void)referesh{
//    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"sortType"];
    [self.table headerBeginRefreshing];
}
-(void)refreshSKBMessgaeCount:(int)count{
    [self getNotifiList];
}
-(void)getNotifiList{
    NSMutableDictionary *dic = [NSMutableDictionary  dictionary];
    [HomeHttpTool getActivitiesNoticeListWithParam:dic success:^(id json) {
        NSLog(@"公告消息列表%@",json);
        NSMutableArray *arr = json[@"ActivitiesNoticeList"];
        int count = 0;
        [self.isReadArr addObjectsFromArray:[WriteFileManager WMreadData:@"messageRead"]];
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            if (![_isReadArr containsObject:dic[@"ID"]]) {
                count += 1;
            }
        }
        self.messageCount = count;
        [self messagePromptAction];
        
    } failure:^(NSError *error) {
        NSLog(@"公告消息列表失败%@",error);
    }];
}
-(void)messagePromptAction{
    if (self.messageCount == 0) {
        self.conditionLine.hidden = YES;
        self.tableSuper.frame = CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height-45);
    }else{
    self.conditionLine.hidden = NO;
    self.tableSuper.frame = CGRectMake(0, 90, self.view.frame.size.width, self.view.frame.size.height-90);
        
    self.messagePrompt.text = [NSString stringWithFormat:@"您有%d条未读信息", self.messageCount];
   self.timePrompt.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"customMessageDateStr"];
    if (self.messageCount >0) {
        [self.bellButton setImage:[UIImage imageNamed:@"redBell"] forState:UIControlStateNormal];
    }
  }
    
}
- (IBAction)pushMessageVC:(id)sender {
    NewMessageCenterController *messgeCenter = [[NewMessageCenterController alloc] init];
    [self.navigationController pushViewController:messgeCenter animated:YES];
}

- (void)tapGestionToMessVC{
    UITapGestureRecognizer *messageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMessageVC:)];
    [self.messagePrompt addGestureRecognizer:messageTap];
}
- (void)tapGestionToMessVC1{
    UITapGestureRecognizer *timeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMessageVC:)];
    [self.timePrompt addGestureRecognizer:timeTap];
}


-(void)loadHistoryArr{
    NSArray *tmp = [WriteFileManager readFielWithName:@"customerSearch"];
    NSMutableArray *searchArr = [NSMutableArray arrayWithArray:tmp];
    self.historyArr = searchArr;
}

#pragma mark - 标题及方法
-(void)customerCenterBarItem{
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 50, 100);
    [button setTitle:@"管客户" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"whidexiala"] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 15)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(20, 60, 20, -10)];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [button addTarget:self action:@selector(popCustomersAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
    
}
- (void)popCustomersAction:(UIButton *)button{
    if (self.popFlag == NO) {
        self.popTableview.hidden = NO;
        [self showShadeView];
        [self.view addSubview:self.popTableview];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopTableView)];
        [self.shadeView addGestureRecognizer:tap];

    }else{
        self.popTableview.hidden = YES;
        [self.shadeView removeFromSuperview];
    }
     self.popFlag = !self.popFlag;
    
}

- (void)showShadeView{
    self.shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.popTableview.frame.size.height+64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-self.popTableview.frame.size.height-64)];
    _shadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view.window addSubview:self.shadeView];
}

- (void)closePopTableView{
    self.popFlag = NO;
    [self.shadeView removeFromSuperview];
    self.popTableview.hidden = YES;
}

#pragma mark - 消息提示
- (void)dealPushBackGround:(NSNotification *)noti{
    NSMutableArray *message = noti.object;
    if([message[0] isEqualToString:@"messageId"]){//新公告
    self.messagePrompt.text = [NSString stringWithFormat:@"您有%d条未读信息", self.messageCount++];
    }
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.subView.hidden = YES;
    
    NSLog(@"... customerType  %ld",self.customerType);
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

#pragma mark - 刷新
-(void)initPull{
    [self.table addHeaderWithTarget:self action:@selector(headPull)dateKey:nil];
    [self.table headerBeginRefreshing];
    [self.table addFooterWithTarget:self action:@selector(foodPull)];
    [self.table footerBeginRefreshing];
    self.table.headerPullToRefreshText = @"下拉刷新";
    self.table.headerRefreshingText = @"正在刷新中";
    self.table.footerPullToRefreshText = @"上拉刷新";
    self.table.footerRefreshingText = @"正在刷新";
    self.isDownLoad = NO;
}
//下拉刷新
-(void)headPull
{
    self.isDownLoad = NO;
    if (!self.isMe) {
     self.customerType = 0;
    }
    self.searchK = @"";
    self.isRefresh = YES;
    self.pageIndex = 1;
    self.searchBar.placeholder = searchDefaultPlaceholder;
    [self loadDataSource];
}
//  上啦加载
- (void)foodPull
{
    self.isDownLoad = YES;
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

- (NSInteger)getTotalPage{
    NSInteger cos = [self.totalNumber integerValue] % pageSize;
    if (cos == 0) {
        return [self.totalNumber integerValue] / pageSize;
    }else{
        NSLog(@"[self.totalNumber integerValue] / pageSize = %ld", [self.totalNumber integerValue] / pageSize + 1);
        return [self.totalNumber integerValue] / pageSize + 1;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self subViewHidden];
}

-(void)setSubViewUp{
    if (self.subView.hidden == YES) {
        [self.view addSubview:self.subView];
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

#pragma mark - 右边导航栏的方法
-(void)customerRightBarItem{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(setSubViewUp)];
    self.navigationItem.rightBarButtonItem= barItem;
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
    if (self.historyArr.count > 6) {
        [self.historyArr removeObjectAtIndex:0];
    }
    [self.noProductWarnLab removeFromSuperview];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%d", self.pageIndex] forKey:@"PageIndex"];
    [dic setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"PageSize"];
    [dic setObject:@7 forKey:@"SortType"];
    [dic setObject:self.searchK forKey:@"SearchKey"];
    [dic setObject:[NSString stringWithFormat:@"%ld", self.customerType]forKey:@"CustomerType"];
    NSLog(@"self.customerType = %ld", self.customerType);

    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomerList" params:dic success:^(id json){
        NSLog(@"------管客户json is %@-------",json);

        self.InvitationInfo = json[@"InvitationInfo"];
        if (self.isRefresh) {
            [self.dataArr removeAllObjects];
            [self.Array removeAllObjects];
            [self.newsBindingCustomArr removeAllObjects];
            [self.hadBindingCustomArr removeAllObjects];
            [self.otherCustomArr removeAllObjects];
            
        }
        NSMutableArray *arrs = [NSMutableArray array];
        self.totalNumber = json[@"TotalCount"];
    
        arrs = json[@"CustomerList"];
       
        if (arrs.count == 0){
        }else{
            [self.Array addObjectsFromArray:arrs];
           
            for (NSDictionary *dic in json[@"CustomerList"]) {
                
                NSString *groupType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"GroupbyType"]];
                 CustomModel *model = [CustomModel modalWithDict:dic];
                
                if ([groupType isEqualToString:@"1"]) {
                  
                    [self.newsBindingCustomArr addObject:model];
                }else if([groupType isEqualToString:@"2"]){
              
                    [self.hadBindingCustomArr addObject:model];
                }else if ([groupType isEqualToString:@"3"]){
                  
                    [self.otherCustomArr addObject:model];
                }
            }
        }
          NSLog(@"dadta = %@ %@ %@",self.newsBindingCustomArr, self.hadBindingCustomArr, self.otherCustomArr);
        
        if (self.newsBindingCustomArr.count && !self.isDownLoad) {
            [self.dataArr addObject:self.newsBindingCustomArr];
        }
    
        if (self.hadBindingCustomArr.count && !self.isDownLoad) {
            [self.dataArr addObject:self.hadBindingCustomArr];
        }
        if (self.otherCustomArr.count && !self.isDownLoad) {
            [self.dataArr addObject:self.otherCustomArr];
        }
        
        NSLog(@"dadta = %@", self.dataArr);
        
        if (self.dataArr.count==0) {
            self.imageViewWhenIsNull.hidden = NO;
            self.CustomerCounts.hidden = YES;
        }else if (self.dataArr.count>0){
            self.imageViewWhenIsNull.hidden = YES ;
            self.CustomerCounts.hidden = NO;
            self.imageViewWhenIsNull.hidden = YES;
            self.peopleN = self.Array.count;
            self.CustomerCounts.text = [NSString stringWithFormat:@"%ld位联系人", self.peopleN];
        }
   
        [self.table reloadData];
        [self.table headerEndRefreshing];
        [self.table footerEndRefreshing];

    } failure:^(NSError *error) {
        NSLog(@"-------管客户第一个接口请求失败 error is %@------",error);
    }];
  
}

#pragma mark - 加载完事时显示的内容
- (void)warning{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, 20)];
    label.text = @"抱歉，没有更多客户了😢";
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.table.tableFooterView = label;
    self.noProductWarnLab = label;
}

#pragma mark - tableView－delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.table == tableView) {
//        CustomModel *model = _dataArr[indexPath.row];
        CustomModel *model = self.dataArr[indexPath.section][indexPath.row];
        CustomerDetailAndOrderViewController * VC = [[CustomerDetailAndOrderViewController  alloc]init];
        VC.customVC = self;
        VC.keyWords = self.searchK;
        VC.customerID = model.ID;
        VC.appUserID = @"";
        
     [self.navigationController pushViewController:VC animated:YES];
    }else if (self.popTableview == tableView){
//刷新数据
        self.customerType = indexPath.row;
        self.isRefresh = YES;
        self.isDownLoad = NO;
        self.pageIndex = 1;
        [self loadDataSource];
        [self closePopTableView];
    }
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.popTableview == tableView) {
        return 1;
    }else{
        return self.dataArr.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.table == tableView) {
//        return self.dataArr.count;
        return [self.dataArr[section]count];
    }else{
        return self.chooseAppArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.table == tableView) {
//        CustomCell *cell = [CustomCell cellWithTableView:tableView navigationC:self.navigationController];
        CustomCell *cell = [CustomCell cellWithTableView:tableView InvitationInfo:self.InvitationInfo navigationC:self.navigationController];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.delegate = self;
        cell.model = _dataArr[indexPath.section][indexPath.row];
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
       return 40.0f;
    }else{
        return 0.01f;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.table == tableView) {
        NSString *str;
        
        if (self.customerType == 0 && section < 3) {
            
            [self setHeadTitle];
            str = [[self.orderAppArr objectAtIndex:section]objectForKey:@"valve"];
            
        }else if(self.customerType == 1){
            str = @"新绑定APP客户";
        }else if(self.customerType == 2){
            str = @"绑定APP客户";
        }else{
            str = @"其他客户";
        }
        return  str;
    }else{
        return nil;
    }
}
- (void)setHeadTitle{
    if (self.dataArr.count == 1) {
        if (_newsBindingCustomArr.count) {
            self.orderAppArr = @[@{@"valve":@"新绑定APP客户"}];
        }else if (_hadBindingCustomArr.count){
            self.orderAppArr = @[@{@"valve":@"绑定APP客户"}];
        }else{
            self.orderAppArr = @[@{@"valve":@"其他客户"}];
        }
    }else if (self.dataArr.count == 2){
        if (_newsBindingCustomArr.count &&_hadBindingCustomArr.count) {
            self.orderAppArr = @[@{@"valve":@"新绑定APP客户"},
                                 @{@"valve":@"绑定APP客户"}];
        }else if (_newsBindingCustomArr.count && _otherCustomArr.count){
            self.orderAppArr = @[@{@"valve":@"新绑定APP客户"},
                                 @{@"valve":@"其他客户"}];
        }else{
            self.orderAppArr = @[@{@"valve":@"绑定APP客户"},
                                 @{@"valve":@"其他客户"}];
        }
    }else if (self.dataArr.count == 3){
        self.orderAppArr = @[@{@"valve":@"新绑定APP客户"},
                             @{@"valve":@"绑定APP客户"},
                             @{@"valve":@"其他客户"}];
    }
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (self.table == tableView) {
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, 40)];
//        view.backgroundColor = self.table.backgroundColor;
//        
//        UILabel *lableT = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.table.frame.size.width-10, 40)];
//        lableT.font = [UIFont systemFontOfSize:15.0f];
//        lableT.text = [self.chooseAppArr objectAtIndex:section];
//        [view addSubview:lableT];
//        return view;
//        
//    }else{
//        UIView *view = [[UIView alloc]init];
//        return view;
//    }
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.popTableview == tableView) {
        return self.popTableview.frame.size.height/self.chooseAppArr.count;
    }else{
        return 64.0f;
    }
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
        
            CustomModel *model = _dataArr[indexPath.section][indexPath.row];
            [self deleteTableViewCellwithId:model.ID];
            // 删除这行
//            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.dataArr[indexPath.section] removeObjectAtIndex:indexPath.row];
            
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
#pragma mark - 删除客户时调用的内容
- (void)deleteTableViewCellwithId:(NSString *)ID{
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"删除中...";
    [hudView show:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:ID forKey:@"CustomerID"];
    
    [IWHttpTool WMpostWithURL:@"/Customer/DeleteCustomer" params:dic success:^(id json) {
        NSLog(@"删除客户信息成功%@",json);
        hudView.labelText = @"删除成功...";
        [hudView hide:YES afterDelay:0.4];
        
        self.peopleN = self.peopleN - 1;
        self.CustomerCounts.text = [NSString stringWithFormat:@"%d位联系人", self.peopleN];
        [self.table reloadData];
   
    } failure:^(NSError *error) {
        NSLog(@"删除客户请求失败%@",error);
    }];
}
- (void)deselect{
    [self.table deselectRowAtIndexPath:[self.table indexPathForSelectedRow] animated:YES];
    [self.popTableview deselectRowAtIndexPath:[self.popTableview indexPathForSelectedRow] animated:YES];
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *trimStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.searchK = trimStr;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
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
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    // 纯粹调节样式
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

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    
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
- (void)historySearch:(NSNotification *)noty{
    self.searchK = noty.userInfo[@"historyKey"];
    [self.searchDisplayController setActive:NO animated:YES];
    [self searchLoadData];
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
    tableView.hidden = YES;
}

#pragma mark - textField delegate method
- (void)searchLoadData{
    [self loadDataSource];
}

#pragma -mark 各种初始化
- (NSMutableArray *)newsBindingCustomArr{
    if (!_newsBindingCustomArr) {
        _newsBindingCustomArr = [NSMutableArray array];
    }
    return _newsBindingCustomArr;
}
- (NSMutableArray *)hadBindingCustomArr{
    if (!_hadBindingCustomArr) {
        _hadBindingCustomArr = [NSMutableArray array];
    }
    return _hadBindingCustomArr;
}
- (NSMutableArray *)otherCustomArr{
    if (!_otherCustomArr) {
        _otherCustomArr = [NSMutableArray array];
    }
    return _otherCustomArr;
}

//- (CustomerSection *)costomerModel{
//    if (!_costomerModel) {
//        _costomerModel = [[CustomerSection alloc]init];
//    }
//    return _costomerModel;
//}
- (NSMutableArray *)Array{
    if (!_Array) {
        _Array = [NSMutableArray array];
    }
    return _Array;
}
- (NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}
- (UILabel *)CustomerCounts{
    if (!_CustomerCounts) {
        self.table.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 50)];
        self.CustomerCounts = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 50)];
        self.CustomerCounts.textAlignment = NSTextAlignmentCenter;
//        [self.table.tableFooterView addSubview:self.CustomerCounts];
        self.table.tableFooterView = self.CustomerCounts;
    }
    return _CustomerCounts;
}
-(NSMutableArray *)isReadArr{
    if (_isReadArr == nil) {
        self.isReadArr = [NSMutableArray array];
    }
    return _isReadArr;
}
- (NSMutableArray *)chooseAppArr{
    if (!_chooseAppArr) {
        _chooseAppArr = [NSMutableArray array];
    }
    return _chooseAppArr;
}
- (NSArray *)orderAppArr{
    if (!_orderAppArr) {
        _orderAppArr = [NSArray array];
    }
    return _orderAppArr;
}

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
