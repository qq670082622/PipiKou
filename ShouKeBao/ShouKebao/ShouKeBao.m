//
//  ShouKeBao.m
//  ShouKeBao
//
//  Created by Richard on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ShouKeBao.h"
#import "MJRefresh.h"
#import "OrderCell.h"
#import "OrderModel.h"
#import "SearchProductViewController.h"
#import "ShouKeBaoCell.h"
#import "StationSelect.h"
#import "StoreViewController.h"
#import "QRCodeViewController.h"
#import "ResizeImage.h"
#import "BBBadgeBarButtonItem.h"
#import "messageCenterViewController.h"
#import "SosViewController.h"
#import "HomeHttpTool.h"
#import "HomeList.h"
#import "WriteFileManager.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "Recommend.h"
#import "HomeBase.h"
#import "RecommendCell.h"
#import "RecommendViewController.h"
#import "WriteFileManager.h"
#import "remondModel.h"
#import "ShowRemindCell.h"
#import <ShareSDK/ShareSDK.h>
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "RemindDetailViewController.h"
#import "OrderDetailViewController.h"
#import "NSMutableDictionary+QD.h"
#import "WMAnimations.h"
#import "ProduceDetailViewController.h"
#import "RemindDetailViewController.h"
#import "messageDetailViewController.h"
#import "UserInfo.h"
#import "APService.h"
#import <AudioToolbox/AudioToolbox.h>
#import "RecomViewController.h"
#import "ScanningViewController.h"
#define FiveDay 432000
#import "MeHttpTool.h"
#import "AFNetworking.h"
#import "MeProgressView.h"
#import "SKBNavBar.h"
#import "messageModel.h"
#import "messageCellSKBTableViewCell.h"
#import "SKBNavBarFor6OrP.h"
#import "MobClick.h"
@interface ShouKeBao ()<UITableViewDataSource,UITableViewDelegate,notifiSKBToReferesh,remindDetailDelegate>

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
- (IBAction)changeStation:(id)sender;
- (IBAction)phoneToService:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;// 搬救兵电话按钮


//@property (weak, nonatomic) IBOutlet UILabel *yesterDayOrderCount;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayVisitors;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;// 列表内容的数组
@property (nonatomic,strong) NSMutableArray *stationDataSource;
@property (weak, nonatomic) IBOutlet UIView *upView;
//@property (weak, nonatomic)  UIButton *stationName;
//@property (nonatomic,copy) NSMutableString *messageCount;
- (IBAction)search:(id)sender;

- (IBAction)add:(id)sender;//现改为share!!

@property (nonatomic,copy) NSMutableString *shareLink;
@property (nonatomic,strong) NSMutableDictionary *shareDic;

@property (nonatomic,assign) NSInteger recommendCount;// 今日推荐的数量

@property (nonatomic,strong) UIView *guideView;
@property (nonatomic,strong) UIImageView *guideImageView;
@property (nonatomic,assign) int guideIndex;

@property(nonatomic,strong) NSMutableArray *isReadArr;
@property (nonatomic, strong)MeProgressView * progressView;
@property (nonatomic, copy)NSString * checkVersionLinkUrl;

@property (weak, nonatomic) IBOutlet UIButton *SKBNewBtn;

@property(nonatomic,weak) UIView *navBarView;

@end

@implementation ShouKeBao

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initPull];
       
    [self postwithNotLoginRecord];//上传未登录时保存的扫描记录
    [ self postWithNotLoginRecord2];//上传未登录时保存的客户
    

    [WMAnimations WMAnimationMakeBoarderWithLayer:self.userIcon.layer andBorderColor:[UIColor clearColor] andBorderWidth:0.5 andNeedShadow:NO];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.SKBNewBtn.layer andBorderColor:[UIColor redColor] andBorderWidth:0.5 andNeedShadow:NO ];
    [self.SKBNewBtn setTitle:@"我要收客" forState:UIControlStateNormal];
    [self.SKBNewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.SKBNewBtn addTarget:self action:@selector(pushToStoreFromButton) forControlEvents:UIControlEventTouchUpInside];

    [WMAnimations WMAnimationMakeBoarderWithLayer:self.searchBtn.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.5 andNeedShadow:NO];
    
   
    
   
    
    [self.view addSubview:self.tableView];
    
    // 取出隐藏的数据 看下有没有过期的 有就去掉
    NSDate *now = [NSDate date];
    NSInteger timeLong = [now timeIntervalSince1970];
    NSArray *tmp = [WriteFileManager readData:@"hideData"];
    NSMutableArray *muta = [NSMutableArray arrayWithArray:tmp];
    if (tmp) {
        for (HomeBase *home in tmp) {
            if ([home.time integerValue] < (timeLong - FiveDay)) {
                [muta removeObject:home];
            }
        }
        [WriteFileManager saveData:muta name:@"hideData"];
    }
    
    [self customLeftBarItem];
    [self customRightBarItem];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToStore)];
   
    [self.upView addGestureRecognizer:tap];
    
    // 加载主列表数据
    [self loadContentDataSource];
    
    [self  getUserInformation];
    
  //  [self getNotifiList];
    
    // 长按搬救兵 打电话
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCall:)];
    longPress.minimumPressDuration = 1;
    [self.phoneBtn addGestureRecognizer:longPress];
    
    // 显示提醒
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showRemind:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealPushBackGround:) name:@"pushWithBackGround" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealPushForeground:) name:@"pushWithForeground" object:nil];
    
//    NSUserDefaults *appIsBack = [NSUserDefaults standardUserDefaults];
//    NSString *isBack = [appIsBack objectForKey:@"appIsBack"];
    
     NSUserDefaults *guiDefault = [NSUserDefaults standardUserDefaults];
    NSString *SKBGuide = [guiDefault objectForKey:@"SKBGuide"];
    if ([SKBGuide integerValue] != 1) {// 是否第一次打开app
        [self Guide];
    }
   
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToRecommendList) name:@"notifiToPushToRecommed" object:nil];
//    [self checkNewVerSion];
    [[[UIApplication sharedApplication].delegate window]addSubview:self.progressView];

}
-(void)setUpNavBarView
{ CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    
    if (screenW<375) {
        SKBNavBar *navBar = [SKBNavBar SKBNavBar];
        self.navigationItem.titleView = navBar;
        //navBar.frame = CGRectMake(40, 0, screenW/2 - 20, 34);
        
        UIView *cover = [[UIView alloc] init];
        CGFloat navBarW = navBar.frame.size.width;
        cover.frame = CGRectMake(screenW/2 - navBarW/2,5, navBar.frame.size.width, 34);
        cover.backgroundColor = [UIColor clearColor];
        UIButton *station = [UIButton buttonWithType:UIButtonTypeSystem];
        station.backgroundColor = [UIColor clearColor];
        station.frame = CGRectMake(0, 0, 64, 34);
        [station addTarget:self action:@selector(changeStation) forControlEvents:UIControlEventTouchUpInside];
        [cover addSubview:station];
        
        UIButton *search = [UIButton buttonWithType:UIButtonTypeSystem];
        search.backgroundColor = [UIColor clearColor];
        search.frame = CGRectMake(64, 0, navBarW-64, 34);
        [search addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        [cover addSubview:search];
        
        [self.navigationController.navigationBar addSubview:cover];
        self.navBarView = cover;

    }else{
        
        SKBNavBarFor6OrP *navBar = [SKBNavBarFor6OrP SKBNavBarFor6OrP];
        self.navigationItem.titleView = navBar;
       // navBar.frame = CGRectMake(40, 0, screenW/2 - 20, 34);
        
        UIView *cover = [[UIView alloc] init];
        CGFloat navBarW = navBar.frame.size.width;
        cover.frame = CGRectMake(screenW/2 - navBarW/2,5, navBar.frame.size.width, 34);
        cover.backgroundColor = [UIColor clearColor];
        UIButton *station = [UIButton buttonWithType:UIButtonTypeSystem];
        station.backgroundColor = [UIColor clearColor];
        station.frame = CGRectMake(0, 0, 64, 34);
        [station addTarget:self action:@selector(changeStation) forControlEvents:UIControlEventTouchUpInside];
        [cover addSubview:station];
        
        UIButton *search = [UIButton buttonWithType:UIButtonTypeSystem];
        search.backgroundColor = [UIColor clearColor];
        search.frame = CGRectMake(64, 0, navBarW-64, 34);
        [search addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
        [cover addSubview:search];
        
        [self.navigationController.navigationBar addSubview:cover];
        self.navBarView = cover;

    }
   
}

-(void)initPull
{
//    //上啦刷新
//    [self.tableView addFooterWithTarget:self action:@selector(footLoad)];
//    //设置文字
//    self.tableView.footerPullToRefreshText = @"加载更多";
//    self.tableView.footerRefreshingText = @"正在刷新";
    //下拉
    [self.tableView addHeaderWithTarget:self action:@selector(headerPull)];
    [self.tableView headerBeginRefreshing];
    
    self.tableView.headerPullToRefreshText =@"刷新内容";
    self.tableView.headerRefreshingText = @"正在刷新";
}
-(void)headerPull
{
    [self loadContentDataSource];
    [self.tableView headerEndRefreshing];
}

#pragma mark - CheckNewVersion
- (void)checkNewVerSion{
    NSDictionary * param = @{};
    [MeHttpTool inspectionWithParam:param success:^(id json) {
        NSDictionary * dic = json[@"ios"];
        NSString * versionCode = dic[@"VersionCode"];
        self.checkVersionLinkUrl = dic[@"LinkUrl"];
        NSString * isMust = @"不在询问";
        if ([dic[@"IsMustUpdate"]isEqualToString:@"1"]) {
            isMust = @"退出程序";
        }
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
        if (![versionCode isEqualToString:currentVersion]) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:@"" delegate:self cancelButtonTitle:isMust otherButtonTitles:@"立即更新", nil];
            [alertView show];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL *URL = [NSURL URLWithString:self.checkVersionLinkUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        self.progressView.hidden = NO;
                      //下载请求
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                      //正确的下载路径 [self getImagePath:@3.zip]
                      
                      //错误的路径
                      //    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
                      //    NSString *docPath = [path objectAtIndex:0];
                      
//            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:[self getImagePath:@"3.zip"] append:YES];
                      //下载进度回调
            [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            //下载进度
            float progress = ((float)totalBytesRead) / (totalBytesExpectedToRead);
            self.progressView.progressValue = progress;
        }];
        
                      //成功和失败回调
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.progressView.hidden = YES;
            NSLog(@"ok");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
                      
        [operation start];
        
    }else{
        if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"退出程序"]) {
            exit(0);
        }
    }
}

#pragma  - mark程序在后台时远程推送处理函数
-(void)dealPushBackGround:(NSNotification *)noti
{ //arr[0]是value arr[1]是key
    //orderId ,userId ,recommond ,productId ,messageId
    
    [self loadContentDataSource];
    [self  getUserInformation];
   
    NSMutableArray *message = noti.object;
    NSLog(@"viewController 里取得值是 is %@",message);
    
    if ([message[0] isEqualToString:@"orderId"]) {
    //已经处理的订单在发生变化时发送消息给用户，点击消息直接进入该订单消息的订单详情
        //message[2]是订单url
        OrderDetailViewController *detail = [[OrderDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detail.url = message[2];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    else if ([message[0] isEqualToString:@"remind"]){
    //跳remindDetail
        NSString *remindTime = message[1];
        NSString *remindContent = message[2];
        //time,note
        RemindDetailViewController *remindDetail = [[RemindDetailViewController alloc] init];
        remindDetail.time = remindTime;
        remindDetail.note = remindContent;
        [self.navigationController pushViewController:remindDetail animated:YES];
    }
    
    else if ([message[0] isEqualToString:@"recommond"]){
        //精品推荐界面
        //无需参数，直接跳转到精品推荐
        RecommendViewController *rec = [[RecommendViewController alloc] init];
        [self.navigationController pushViewController:rec animated:YES];
    }
    
    else if ([message[0] isEqualToString:@"productId"]){
        
        //产品详情h5
        ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
        detail.produceUrl = message[2];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    else if ([message[0] isEqualToString:@"messageId"]){
        //进入h5
        NSString *messageURL = message[2];
        messageDetailViewController *messageDetail = [[messageDetailViewController alloc] init];
        messageDetail.messageURL = messageURL;
        [self.navigationController pushViewController:messageDetail animated:YES];
    }
    
    else if ([message[0] isEqualToString:@"noticeType"]){
       // [self ringAction];
    }
}


#pragma -mark 声音
-(void)getVoice{
   
    //添加提示音
    SystemSoundID messageSound;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"message" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&messageSound);
    
    AudioServicesPlaySystemSound (messageSound);
}


#pragma  - mark程序在前台时远程推送处理函数
-(void)dealPushForeground:(NSNotification *)noti
{ //arr[0]是value arr[1]是key
    //orderId ,userId ,recommond ,productId ,messageId
   
    NSMutableArray *message = noti.object;
    NSLog(@"viewController 里取得值是 is %@",message);
    
    [self loadContentDataSource];
    
    [self  getUserInformation];
  
    [self getVoice];
   
         self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[self.tabBarItem.badgeValue intValue]+1];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [self.tabBarItem.badgeValue integerValue];
  
   

    if ([message[0] isEqualToString:@"orderId"]) {//订单消息
     
    }
    
    else if ([message[0] isEqualToString:@"remind"]){//客户提醒

        
    }
    
    else if ([message[0] isEqualToString:@"recommond"]){//精品推荐
      
        
    }
    
    else if ([message[0] isEqualToString:@"productId"]){//新线路（新产品）
        
           }
    
     if ([message[0] isEqualToString:@"messageId"]){//新公告
        BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;
        int valueCount = [barButton.badgeValue intValue];
        barButton.badgeValue = [NSString stringWithFormat:@"%d",valueCount+1];
        
        //self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[self.tabBarItem.badgeValue intValue]+1];
    }
    

}


-(NSMutableString *)shareLink
 {
     if (_shareLink == nil) {
         self.shareLink = [NSMutableString string];
     }
     return _shareLink;
 }


-(NSMutableDictionary *)shareDic
{
    if (_shareDic == nil) {
        self.shareDic = [NSMutableDictionary dictionary];
    }
    return _shareDic;
}


#pragma -mark massegeCenterDelegate
-(void)refreshSKBMessgaeCount:(int)count
{
    [self getNotifiList];
   
}


-(void)getStationName
{
    //确定分站
    [IWHttpTool WMpostWithURL:@"/Product/GetSubstation" params:nil success:^(id json) {
        NSLog(@"------获取分站信息%@-------",json);
        [self.stationDataSource removeAllObjects];
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSString *currentStation = [def objectForKey:UserInfoKeySubstation];
        
        for(NSDictionary *dic in json[@"Substation"]){
            //[self.stationDataSource addObject:dic];
            if ([currentStation isEqualToString:dic[@"Value"]]) {
                //[self.stationName setTitle:[NSString stringWithFormat:@"%@",dic[@"Text"]] forState:UIControlStateNormal];
                NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
                [udf setObject:[NSString stringWithFormat:@"%@",dic[@"Text"]] forKey:@"SubstationName"];
                 [udf synchronize];

            }
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"获取分站信息请求失败，原因：%@",error);
    }];
    

}


- (void)getUserInformation
{
    NSMutableDictionary *dic = [NSMutableDictionary  dictionary];//访客，订单数，分享链接
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    
    hudView.labelText = @"加载中...";
    
    [hudView show:YES];
    
    [HomeHttpTool getIndexHeadWithParam:dic success:^(id json) {
        
        NSLog(@"首页个人消息汇总%@",json);
        
        NSMutableDictionary *muta = [NSMutableDictionary cleanNullResult:json];
        
       // self.yesterDayOrderCount.text = [NSString stringWithFormat:@"%@单",muta[@"OrderCount"]];
       
        NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已被光顾了%@次",muta[@"VisitorCount"]]];
        NSString *visitors = [NSString stringWithFormat:@"%@",muta[@"VisitorCount"]];
        
        [newStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,visitors.length)];
        self.yesterdayVisitors.attributedText = newStr;

        NSString *head = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginAvatar];
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"bigIcon"]];
        self.userName.text = muta[@"ShowName"];
        self.shareLink = muta[@"LinkUrl"];
        if (![muta[@"ShareInfo"] isKindOfClass:[NSNull class]]) {
            NSMutableDictionary *info = [NSMutableDictionary cleanNullResult:muta[@"ShareInfo"]];
            self.shareDic = info;
        }
    } failure:^(NSError *error) {
        NSLog(@"首页个人消息汇总失败%@",error);
    }];
    
    
    [hudView hide:YES];
}



- (void)getNotifiList
{
    NSMutableDictionary *dic = [NSMutableDictionary  dictionary];
    [HomeHttpTool getActivitiesNoticeListWithParam:dic success:^(id json) {
        NSLog(@"首页公告消息列表%@",json);
        NSMutableArray *arr = json[@"ActivitiesNoticeList"];
        
        BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;
       

        int count = 0;
        [self.isReadArr addObjectsFromArray:[WriteFileManager WMreadData:@"messageRead"]];
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            if (![_isReadArr containsObject:dic[@"ID"]]) {
                count += 1;
            }
        }
        barButton.badgeValue = [NSString stringWithFormat:@"%d",count];
      
    } failure:^(NSError *error) {
        NSLog(@"首页公告消息列表失败%@",error);
    }];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.userName.text =  [UserInfo shareUser].userName;
    [MobClick beginLogPageView:@"ShouKeBao"];
    
    [self getNotifiList];
    
//    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
//    NSString *subStationName = [udf stringForKey:@"SubstationName"];
//    if (subStationName) {
//        [self.stationName setTitle:subStationName forState:UIControlStateNormal];
//    }else{
//        [self.stationName setTitle:@"上海" forState:UIControlStateNormal];
//    }
    
    [self getStationName];
    
    [self setUpNavBarView];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBao"];

    [self.navBarView removeFromSuperview];
}


#pragma mark - getter

-(NSMutableArray *)isReadArr
{
    if (_isReadArr == nil) {
        self.isReadArr = [NSMutableArray array];
    }
    return _isReadArr;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 164)];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 54, 0);
        _tableView.rowHeight = 105;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:237/255.0 alpha:1];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}


- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


-(NSMutableArray *)stationDataSource
{
    if (_stationDataSource == nil) {
        self.stationDataSource = [NSMutableArray array];
    }
    return _stationDataSource;
}

- (MeProgressView *)progressView
{
    if (!_progressView) {
        self.progressView = [MeProgressView creatProgressViewWithFrame:[UIScreen mainScreen].bounds];
        self.progressView.hidden = YES;
    }
    return _progressView;
}

#pragma mark - loadDataSource
- (void)loadContentDataSource
{
    NSDictionary *param = @{};// 基本参数即可
    
    [HomeHttpTool getIndexContentWithParam:param success:^(id json) {
        NSLog(@"------------------------新接口是%@---------------------",json);
        
        if (![json[@"OrderList"] isKindOfClass:[NSNull class]]) {
            
            dispatch_queue_t q = dispatch_queue_create("homelist_q", DISPATCH_QUEUE_SERIAL);
            dispatch_async(q, ^{
                NSLog(@"-----count %lu",(unsigned long)[json[@"OrderList"] count]);
                [self.dataSource removeAllObjects];
                
                self.recommendCount = [json[@"RecommendProduct"][@"Count"] integerValue];
                NSLog(@"%ld$$$$", (long)self.recommendCount);
                // 添加精品推荐 如果有推荐的话
                if ([json[@"RecommendProduct"][@"Count"] integerValue] > 0) {
                
//                    [HomeHttpTool getRecommendProductListWithParam:@{@"DateRangeType":@"1"} success:^(id recommendJson) {
//                        NSLog(@"-------------今日推荐新接口数据是:%@--------------",recommendJson);
//                    } failure:^(NSError *error) {
//                        
//                    }];
                    
                    Recommend *recommend = [Recommend recommendWithDict:json[@"RecommendProduct"]];
                    HomeBase *base = [[HomeBase alloc] init];
                    base.time = recommend.CreatedDate;
                    base.model = recommend;
                    base.idStr = @"recommend";
                    [self.dataSource addObject:base];
                }
                
                // 添加订单
              
                for (NSDictionary *dic in json[@"OrderList"]) {

                    HomeList *list = [HomeList homeListWithDict:dic];
                    
                    HomeBase *base = [[HomeBase alloc] init];
                    base.time = list.CreatedDate;
                    base.model = list;
                    base.idStr = list.ID;
                    
                    [self.dataSource addObject:base];
                }
                  NSLog(@"orderJson is  %@",json[@"NoticeCenterList"]);
                for(NSDictionary *dic in json[@"NoticeCenterList"]){
                    messageModel *message = [messageModel modalWithDict:dic];
                    HomeBase *base = [[HomeBase alloc] init];
                    base.time = message.CreatedDate;
                    base.model = message;
                    base.idStr = message.ID;
                    [self.dataSource addObject:base];
                }
                // 加载未查看的提醒
                [self showOldRemind];
                
                // 排序
                [self sortDataSource];
                
                // 清理数据 看有没有隐藏的 有就不要显示
                [self cleanDataSource];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
        }

    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - private
//第一次开机引导
-(void)Guide
{
    self.guideView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _guideView.backgroundColor = [UIColor clearColor];
    self.guideImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_guideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)]];
    self.guideImageView.image = [UIImage imageNamed:@"GuideSKB1"];


    NSUserDefaults *guideDefault = [NSUserDefaults standardUserDefaults];
    [guideDefault setObject:@"1" forKey:@"SKBGuide"];
     [guideDefault synchronize];
    
    [self.guideView addSubview:_guideImageView];
    [[[UIApplication sharedApplication].delegate window] addSubview:_guideView];
}

-(void)click
{
        self.guideIndex++;
    
    NSString *str = [NSString stringWithFormat:@"GuideSKB%d",self.guideIndex+1];
    self.guideImageView.image = [UIImage imageNamed:str];
    
    CATransition *an1 = [CATransition animation];
    an1.type = @"rippleEffect";
    an1.subtype = kCATransitionFromRight;//用kcatransition的类别确定cube翻转方向
    an1.duration = 2;
    [self.guideImageView.layer addAnimation:an1 forKey:nil];
    
    if (self.guideIndex == 3) {
        
        [self.guideView removeFromSuperview];
        
       
    }

    
    NSLog(@"被店家－－－－－－－－－－－－－indexi is %d－－",_guideIndex);

}
// 显示提醒
- (void)showRemind:(NSTimer *)timer
{
//    NSLog(@"-----remind-");
    NSArray *remindArr = [WriteFileManager readData:@"remindData"];
    for (remondModel *remind in remindArr) {
        NSDate *now = [NSDate date];
        NSTimeInterval time = [now timeIntervalSince1970];
        if ([remind.RemindTime integerValue] == (NSInteger)time) {
            
            HomeBase *base = [[HomeBase alloc] init];
            base.time = remind.RemindTime;
            base.model = remind;
            base.idStr = remind.ID;
            [self.dataSource addObject:base];
            
            [self sortDataSource];
            [self.tableView reloadData];
        }
    }
}

// 显示过去没有消失的提醒 避免一直刷新列表的解决办法
- (void)showOldRemind
{
    NSArray *remindArr = [WriteFileManager readData:@"remindData"];
    for (remondModel *remind in remindArr) {
        NSDate *now = [NSDate date];
        NSInteger time = [now timeIntervalSince1970];
        if ([remind.RemindTime integerValue] <= time) {
            
            HomeBase *base = [[HomeBase alloc] init];
            base.time = remind.RemindTime;
            base.model = remind;
            base.idStr = remind.ID;
            [self.dataSource addObject:base];
        }
    }
}

// 去掉隐藏的数据
- (void)cleanDataSource
{
    NSArray *hideData = [WriteFileManager readData:@"hideData"];
    for (int i = 0; i < self.dataSource.count; i ++) {
        HomeBase *new = self.dataSource[i];
        
        // 精品推荐隐藏更假 所以不做去除
        if (![new.model isKindOfClass:[Recommend class]]) {
            for (int j = 0; j < hideData.count; j ++) {
                HomeBase *hide = hideData[j];
                if ([new.idStr isEqualToString:hide.idStr]) {
                    [self.dataSource removeObjectAtIndex:i];
                }
            }
        }
    }
}

// 根据时间排序
- (void)sortDataSource
{
    // 排序
    NSArray *tmp = [self.dataSource sortedArrayUsingComparator:^NSComparisonResult(HomeBase *obj1, HomeBase *obj2) {
        
      
     if ([obj1.time integerValue] > [obj2.time integerValue]) {
            return NSOrderedAscending;
        }
        if ([obj1.time integerValue] < [obj2.time integerValue]) {
            return NSOrderedDescending;
        }
                return NSOrderedSame;
    }];
    
    // 排序好的数组替换数据源数组
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:tmp];
}

-(void)pushToStore
{
    StoreViewController *store =  [[StoreViewController alloc] init];
    store.PushUrl = _shareLink;
    
    
      [self.navigationController pushViewController:store animated:YES];
}
-(void)pushToStoreFromButton
{
    StoreViewController *store =  [[StoreViewController alloc] init];
    store.PushUrl = _shareLink;
    
    store.needOpenShare = YES;
   
    [self.navigationController pushViewController:store animated:YES];
}
- (void)changeStation{
   
   
    StationSelect *stationSelect = [[StationSelect alloc] init];

    [self.navigationController pushViewController:stationSelect animated:YES];
}

- (IBAction)phoneToService:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    SosViewController *sos = [sb instantiateViewControllerWithIdentifier:@"Sos"];
    
    [self.navigationController pushViewController:sos animated:YES];
    
}

// 长按搬救兵打电话
- (void)longPressCall:(UILongPressGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateEnded) {
        
    }
    else {
        NSString *mobile = [UserInfo shareUser].sosMobile;
        if (!mobile) {
            return;
        }
        NSString *phone = [NSString stringWithFormat:@"tel://%@",mobile];
        NSLog(@"----------------手机号码%@------------------",phone);
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
}

- (void)search
{
   
    SearchProductViewController *searchVC = [[SearchProductViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
    
   
}

-(void)addAlert
{
    // 获取到现在应用中存在几个window，ios是可以多窗口的
    NSArray *windowArray = [UIApplication sharedApplication].windows;
    // 取出最后一个，因为你点击分享时这个actionsheet（其实是一个window）才会添加
    UIWindow *actionWindow = (UIWindow *)[windowArray lastObject];
    // 以下就是不停的寻找子视图，修改要修改的
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat labY;
    if (screenH == 667) {
          labY = 260;
    }else if (screenH == 568){
        labY = 160;
    }else if (screenH == 480){
        labY = 180;
    }else if (screenH == 736){
        labY = 440;
    }
   
    
    CGFloat labW = self.view.bounds.size.width;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH, labW, 30)];
    lab.text = @"您分享出去的内容对外只显示门市价";
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    [actionWindow addSubview:lab];
    [UIView animateWithDuration:0.4 animations:^{
        lab.transform = CGAffineTransformMakeTranslation(0, labY-screenH);
    }];
    
    self.warningLab = lab;

}

- (IBAction)add:(id)sender
{
   
//构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:self.shareDic[@"Desc"]
                                       defaultContent:self.shareDic[@"Desc"]
                                                image:[ShareSDK imageWithUrl:self.shareDic[@"Pic"]]
                                                title:self.shareDic[@"Title"]
                                                  url:self.shareDic[@"Url"]                                          description:self.shareDic[@"Desc"]
                                            mediaType:SSPublishContentMediaTypeNews];
    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@   ,  %@,地址：%@",_shareDic[@"Tile"],_shareDic[@"Desc"],_shareDic[@"Url"]] image:nil];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender  arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 [self.warningLab removeFromSuperview];
                                if (state == SSResponseStateSuccess)
                                {
                                    [self.warningLab removeFromSuperview];
                                    
                                    [MBProgressHUD showSuccess:@"分享成功"];
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                                       
                                        [IWHttpTool postWithURL:@"Common/SaveShareRecord" params:@{@"ShareType":@"1"} success:^(id json) {
                                                                                    } failure:^(NSError *error) {
                                            
                                        }];
                                    
                                        [MBProgressHUD hideHUD];

                                    });
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    [self.warningLab removeFromSuperview];
                                    
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }else if (state == SSResponseStateCancel){
                                  
                                    [self.warningLab removeFromSuperview];
                                }
                            }];
    
     [self addAlert];
   
    
}


-(void)customLeftBarItem
{
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [customButton addTarget:self action:@selector(ringAction) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"lingdang1"] forState:UIControlStateNormal];
    
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    
   barButton.shouldHideBadgeAtZero = YES;
    
    self.navigationItem.leftBarButtonItem = barButton;
    
   
}

-(void)customRightBarItem
{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];;
    [btn addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"itemsaomiao"] forState:UIControlStateNormal];
   UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
}

-(void)ringAction
{

    messageCenterViewController *messgeCenter = [[messageCenterViewController alloc] init];
    messgeCenter.delegate = self;
    
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;
   
self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[self.tabBarItem.badgeValue intValue] - [barButton.badgeValue intValue]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [self.tabBarItem.badgeValue integerValue];
   
    if ([self.tabBarItem.badgeValue intValue] <= 0) {
        self.tabBarItem.badgeValue = nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
        [self.navigationController pushViewController:messgeCenter animated:YES];
    
}


-(void)codeAction
{
   
   
    ScanningViewController *scan = [[ScanningViewController alloc] init];
    scan.isLogin = YES;
    [self.navigationController pushViewController:scan animated:YES];
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeBase *model = self.dataSource[indexPath.row];
    
    if ([model.model isKindOfClass:[HomeList class]]) {
        
        ShouKeBaoCell *cell = [ShouKeBaoCell cellWithTableView:tableView];
        cell.model = model.model;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
        
    }else if ([model.model isKindOfClass:[messageModel class]]){
       
        messageCellSKBTableViewCell *cell = [messageCellSKBTableViewCell cellWithTableView:tableView];
        cell.model = model.model;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
        
    }else if([model.model isKindOfClass:[Recommend class]]){
        RecommendCell *cell = [RecommendCell cellWithTableView:tableView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  
        cell.recommend = model.model;
        
        // 如果没有数据的话就隐藏这个红点
        cell.redTip.hidden = !(self.recommendCount > 0);
        
        return cell;
    }else{
       
        ShowRemindCell *cell = [ShowRemindCell cellWithTableView:tableView];
        cell.remind = model.model;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeBase *model = self.dataSource[indexPath.row];
    
    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[self.tabBarItem.badgeValue intValue] - 1];
    if ([self.tabBarItem.badgeValue intValue] <= 0) {
        self.tabBarItem.badgeValue = nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }

    if ([model.model isKindOfClass:[HomeList class]]) {
        HomeList *order = model.model;
        OrderDetailViewController *detail = [[OrderDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detail.url = order.LinkUrl;
        detail.title = @"订单详情";
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if([model.model isKindOfClass:[Recommend class]]){
        [self nitifiToPushRecommendListWithUrl];
       // RecommendViewController *rec = [[RecommendViewController alloc] init];
        
    }else if ([model.model isKindOfClass:[messageModel class]]){
        messageDetailViewController *msgDetail = [[messageDetailViewController alloc] init];
        messageModel *msg = model.model;
        msgDetail.messageURL = msg.LinkUrl;
        [self.navigationController pushViewController:msgDetail animated:YES];
        
    }
    else{//客户提醒
        remondModel *r = model.model;
        RemindDetailViewController *remondDetail = [[RemindDetailViewController alloc] init];
        remondDetail.time = r.RemindTime;
        remondDetail.note = r.Content;
        remondDetail.remindId = r.ID;
        remondDetail.delegate = self;
       

        [self.navigationController pushViewController:remondDetail animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma -mark 从recommendcell传过来的通知方法,避免uiimageview的tao对cell的点击冲突
-(void)pushToRecommendList
{
    [self nitifiToPushRecommendListWithUrl];
}


-(void)nitifiToPushRecommendListWithUrl
{
    RecomViewController *rec = [[RecomViewController alloc] init];
   [self.navigationController pushViewController:rec animated:YES];
    
    // 刷新下 隐藏红点
    self.recommendCount = 0;
   
       [_tableView reloadData];

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeBase *model = self.dataSource[indexPath.row];
    
    if ([model.model isKindOfClass:[Recommend class]]) {
        
        Recommend *rmodel = model.model;
        
        NSUInteger count = rmodel.RecommendIndexProductList.count;
       
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        
        double radious = screenH/667;
        
        NSLog(@"-----------------radious is %.3f---------",radious);
        
        if ( count == 2 || count == 3) {
       
            if (screenH == 480) {
                
                return 180*radious+25;
            }

                    return 180*radious;
                    
        }else if (count == 4 || count == 5 || count == 6){
          
            if (screenH == 480) {
               
                return 260*radious+25;
            }
           
            return 270*radious;
            
        }else if(count == 1){
            
            if (screenH == 480) {
               
                return 270*radious+25;
            }

        
            return 270*radious;
        }else{
            if (screenH == 480) {
                
                return 350*radious+25;
            }
            
            
            return 350*radious;

        }
        
    }else{
        
        return 110;
    }
}

/*
    右滑动删除
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 保存隐藏的模型
        HomeBase *base = self.dataSource[indexPath.row];
       
        NSArray *tmp = [WriteFileManager readData:@"hideData"];
        
        NSMutableArray *muta = [NSMutableArray arrayWithArray:tmp];
        
        [muta addObject:base];
        
        [WriteFileManager saveData:muta name:@"hideData"];
        
        // 删除这行
        [self.dataSource removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"隐藏";
}

#pragma mark - remindDetailDelegate
- (void)didLookUpRemind
{
    // 去除所有的提醒 重新添加 目前不能一个个加
    NSMutableArray *tmp = self.dataSource.copy;
  
    for (int i = 0; i < tmp.count; i ++) {
    
        HomeBase *base = tmp[i];
        
        if ([base.model isKindOfClass:[remondModel class]]) {
        
            [self.dataSource removeObject:base];
        }
    }
    
    [self showOldRemind];
    
    [self sortDataSource];
    [self.tableView reloadData];
}


#pragma mark - 登录成功时，将未登录时保存的记录传给后台来同步扫描记录
-(void)postwithNotLoginRecord
{
   NSArray *arr = [NSArray arrayWithArray:[WriteFileManager readData:@"record"]] ;
   
    
    if (arr.count>0) {
    
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:arr forKey:@"CredentialsPicRecordList"];
        
[IWHttpTool WMpostWithURL:@"Customer/SyncCredentialsPicRecord" params:dic success:^(id json) {
            NSLog(@"上传record成功");
    
//    UILabel *testLab = [[UILabel alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    
//    testLab.backgroundColor = [UIColor whiteColor];
//    
//    testLab.font = [UIFont systemFontOfSize:8];
//    
//    testLab.text = [NSString stringWithFormat:@"------/dic is %@ /json is %@-------",dic,json];
//    
//    testLab.numberOfLines = 0;
//    
//    [self.view.window addSubview:testLab];

                    NSArray *new = [NSArray array];
            [WriteFileManager saveData:new name:@"record"];
    [MBProgressHUD showSuccess:@"已同步未登录时的扫描信息"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        [MBProgressHUD hideHUD];
    });

        } failure:^(NSError *error) {
            NSLog(@"上传record失败");
        }];
    
    }
   
  
}

-(void)postWithNotLoginRecord2//未登录时添加的客户
{
    NSArray *arr = [NSArray arrayWithArray:[WriteFileManager readData:@"recoder2"]];//未登录时储存的客户;
   
    if (arr.count>0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:arr forKey:@"RecordIds"];
        [IWHttpTool WMpostWithURL:@"Customer/CopyCredentialsPicRecordToCustomer" params:dic success:^(id json) {
            NSLog(@"批量导入客户成功 返回json is %@",json);
            
            [MBProgressHUD showSuccess:@"已同步未登录时添加的客户信息"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                [MBProgressHUD hideHUD];
            });

        } failure:^(NSError *error) {
            NSLog(@"批量导入客户失败，返回error is %@",error);
        }];
}
   
   
}

@end
