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
#import "Lotuseed.h"
#define FiveDay 432000

@interface ShouKeBao ()<UITableViewDataSource,UITableViewDelegate,notifiSKBToReferesh,remindDetailDelegate>

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
- (IBAction)changeStation:(id)sender;
- (IBAction)phoneToService:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;// 搬救兵电话按钮


@property (weak, nonatomic) IBOutlet UILabel *yesterDayOrderCount;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayVisitors;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;// 列表内容的数组

@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UIButton *stationName;
//@property (nonatomic,copy) NSMutableString *messageCount;
- (IBAction)search:(id)sender;

- (IBAction)add:(id)sender;//现改为share!!

@property (nonatomic,copy) NSMutableString *shareLink;
@property (nonatomic,strong) NSMutableDictionary *shareDic;

@property (nonatomic,assign) NSInteger recommendCount;// 今日推荐的数量

@property (nonatomic,strong) UIView *guideView;
@property (nonatomic,strong) UIImageView *guideImageView;
@property (nonatomic,assign) int guideIndex;
@end

@implementation ShouKeBao

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService setBadge:0];
    
    self.userIcon.layer.masksToBounds = YES;
    
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
   // [self customRightBarItem];
    
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
    
    NSUserDefaults *appIsBack = [NSUserDefaults standardUserDefaults];
    [appIsBack setObject:@"no" forKey:@"appIsBack"];
    [appIsBack synchronize];
    
     NSUserDefaults *guiDefault = [NSUserDefaults standardUserDefaults];
    NSString *SKBGuide = [guiDefault objectForKey:@"SKBGuide"];
    if ([SKBGuide integerValue] != 1) {// 是否第一次打开app
        [self Guide];
    }
//[self Guide];
}


#pragma  - mark程序在后台时远程推送处理函数
-(void)dealPushBackGround:(NSNotification *)noti
{ //arr[0]是value arr[1]是key
    //orderId ,userId ,recommond ,productId ,messageId
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService setBadge:0];
    
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [APService setBadge:0];
    
    NSMutableArray *message = noti.object;
    NSLog(@"viewController 里取得值是 is %@",message);
    
    [self loadContentDataSource];
    
    [self  getUserInformation];
  
    [self getVoice];
    //if ([self.tabBarItem.badgeValue intValue]>5) {
         self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[self.tabBarItem.badgeValue intValue]+1];
  //  }
   

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
    
//    else if ([message[0] isEqualToString:@"noticeType"]){
//      
//        BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;
//        int valueCount = [barButton.badgeValue intValue];
//        barButton.badgeValue = [NSString stringWithFormat:@"%d",valueCount+1];
//        
//        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[self.tabBarItem.badgeValue intValue]+1];
//
//    }
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

- (void)getUserInformation
{
    NSMutableDictionary *dic = [NSMutableDictionary  dictionary];//访客，订单数，分享链接
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    
    hudView.labelText = @"加载中...";
    
    [hudView show:YES];
    
    [HomeHttpTool getIndexHeadWithParam:dic success:^(id json) {
        
        NSLog(@"首页个人消息汇总%@",json);
        
        NSMutableDictionary *muta = [NSMutableDictionary cleanNullResult:json];
        
        self.yesterDayOrderCount.text = [NSString stringWithFormat:@"%@单",muta[@"OrderCount"]];
        self.yesterdayVisitors.text = [NSString stringWithFormat:@"%@人",muta[@"VisitorCount"]];

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
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            if ([dic[@"IsRead"] isEqualToString:@"0"]) {
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
    
    [self getNotifiList];
    
NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    NSString *subStationName = [udf stringForKey:@"SubstationName"];
    if (subStationName) {
        [self.stationName setTitle:subStationName forState:UIControlStateNormal];
    }else if (!subStationName){
        [self.stationName setTitle:@"上海" forState:UIControlStateNormal];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 204)];
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


#pragma mark - loadDataSource
- (void)loadContentDataSource
{
    NSDictionary *param = @{};// 基本参数即可
    
    [HomeHttpTool getIndexContentWithParam:param success:^(id json) {
        NSLog(@"----%@",json);
        
        if (![json[@"OrderList"] isKindOfClass:[NSNull class]]) {
            
            dispatch_queue_t q = dispatch_queue_create("homelist_q", DISPATCH_QUEUE_SERIAL);
            dispatch_async(q, ^{
                NSLog(@"-----count %lu",(unsigned long)[json[@"OrderList"] count]);
                [self.dataSource removeAllObjects];
                
                self.recommendCount = [json[@"RecommendProduct"][@"Count"] integerValue];
                // 添加精品推荐 如果有推荐的话
                if ([json[@"RecommendProduct"][@"Count"] integerValue] > 0) {
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
    
    if (self.guideIndex == 4) {
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
    [Lotuseed onEvent:@"page1ClickToStore"];
    [self.navigationController pushViewController:store animated:YES];
}

- (IBAction)changeStation:(id)sender {
    
    [Lotuseed onEvent:@"page1ChangeStation"];
   
    StationSelect *stationSelect = [[StationSelect alloc] init];

    [self.navigationController pushViewController:stationSelect animated:YES];
}

- (IBAction)phoneToService:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    SosViewController *sos = [sb instantiateViewControllerWithIdentifier:@"Sos"];
    [Lotuseed onEvent:@"page1ClickToSos"];
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
        [Lotuseed onEvent:@"page1Tap3sToSos"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
}

- (IBAction)search:(id)sender
{
    [Lotuseed onEvent:@"Page1Search"];
    SearchProductViewController *searchVC = [[SearchProductViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:NO];
    
   
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
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    
                                    [MBProgressHUD showSuccess:@"分享成功"];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                                        [MBProgressHUD hideHUD];
                                    });
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    
    [self showAlert];
    [Lotuseed onEvent:@"page1ShareStore"];
    
}

-(void)showAlert
{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [accountDefaults stringForKey:@"shareCount"];
    
    if ([account intValue]<3){
        
        NSString *newCount =  [NSString stringWithFormat:@"%d",[account intValue]+1];
        [accountDefaults setObject:newCount forKey:@"shareCount"];
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"分享产品" message:@"您分享出去的产品对外只显示门市价" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
    }
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
    [btn setImage:[UIImage imageNamed:@"erweima"] forState:UIControlStateNormal];
   UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
}

-(void)ringAction
{

    messageCenterViewController *messgeCenter = [[messageCenterViewController alloc] init];
    messgeCenter.delegate = self;
    
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;
   
self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[self.tabBarItem.badgeValue intValue] - [barButton.badgeValue intValue]];
   
    if ([self.tabBarItem.badgeValue intValue] <= 0) {
        self.tabBarItem.badgeValue = nil;
    }
    [Lotuseed onEvent:@"page1ClickToMessageCenter"];
    [self.navigationController pushViewController:messgeCenter animated:YES];
    
}


-(void)codeAction
{
    [self.navigationController pushViewController:[[QRCodeViewController alloc] init] animated:YES];
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
        
        return cell;
    }else if([model.model isKindOfClass:[Recommend class]]){
        RecommendCell *cell = [RecommendCell cellWithTableView:tableView];
        cell.recommend = model.model;
        
        // 如果没有数据的话就隐藏这个红点
        cell.redTip.hidden = !(self.recommendCount > 0);
        return cell;
    }else{
        ShowRemindCell *cell = [ShowRemindCell cellWithTableView:tableView];
        cell.remind = model.model;
        
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
    }

    if ([model.model isKindOfClass:[HomeList class]]) {
        HomeList *order = model.model;
        OrderDetailViewController *detail = [[OrderDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detail.url = order.LinkUrl;
        detail.title = @"订单详情";
        [self.navigationController pushViewController:detail animated:YES];
        [Lotuseed onEvent:@"page1ClickToOrderDetail"];
    }else if([model.model isKindOfClass:[Recommend class]]){
        
        RecommendViewController *rec = [[RecommendViewController alloc] init];
        [self.navigationController pushViewController:rec animated:YES];
        
        // 刷新下 隐藏红点
        self.recommendCount = 0;
        [Lotuseed onEvent:@"page1ClickTorecommend"];

        [tableView reloadData];
    }else{
        remondModel *r = model.model;
        RemindDetailViewController *remondDetail = [[RemindDetailViewController alloc] init];
        remondDetail.time = r.RemindTime;
        remondDetail.note = r.Content;
        remondDetail.remindId = r.ID;
        remondDetail.delegate = self;
        [Lotuseed onEvent:@"page1ClickToRemondDetail"];

        [self.navigationController pushViewController:remondDetail animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        return 90;
    }else{
        return 105;
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

@end
