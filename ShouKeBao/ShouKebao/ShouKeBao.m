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
#import <AudioToolbox/AudioToolbox.h>
#import "RecomViewController.h"
#import "ScanningViewController.h"
#define FiveDay 432000
#import "MeHttpTool.h"
#import "AFNetworking.h"
#import "MeProgressView.h"
#import "SKBNavBar.h"
#import "MessageModel2.h"
#import "messageCellSKBTableViewCell.h"
#import "SKBNavBarFor6OrP.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"
#import "UMessage.h"
#import "NewVersionWebViewController.h"
#import "Me.h"
#import "StrToDic.h"
#import "BaseWebViewController.h"
#import "FeedBcakViewController.h"
#import "ProductRecommendViewController.h"
#import "ProductList.h"
#import "FindProductNew.h"
#import "NSString+FKTools.h"
#import "CommandTo.h"
#import "invoiceCell.h"
#import "AppDelegate.h"
#import "NewMessageCenterController.h"
#import "SubscribeCell.h"
#import "HotLaButton.h"
#import "CircleHotNewsViewController.h"
#import "CommendToNo.h"
#import "LocationSeting.h"
#import "CircleModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "Double12TableViewCell.h"
#import "DoubleModel.h"
#import "ZhiVisitorDynamicController.h"
#define View_Width self.view.frame.size.width
#define View_Height self.view.frame.size.height

@interface ShouKeBao ()<UITableViewDataSource,UITableViewDelegate,notifiSKBToReferesh,remindDetailDelegate, CLLocationManagerDelegate /*定位代理*/>
//定位使用
@property (nonatomic, retain)CLLocationManager *locationManager;
@property (nonatomic, retain)CLLocation *loc;

@property (nonatomic, strong)RecommendCell *cell;
@property (nonatomic, strong)BBBadgeBarButtonItem *barButton;
@property (nonatomic, assign) NSInteger num;

@property (nonatomic, assign)BOOL yesorno;
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
@property(nonatomic,assign) CGRect titleViewFrame;
@property (nonatomic,assign) NSUInteger time;
@property(nonatomic,strong) NSTimer *pushTime;
@property (nonatomic, copy)NSString * IOSUpdateType;
@property (nonatomic, assign)BOOL isFromDowmload;
@property (nonatomic, assign)BOOL isMustUpdate;
@property (nonatomic, assign)BOOL isEmpty;

//轮播图
@property (weak, nonatomic) IBOutlet UIView *CarouselView;
@property (weak, nonatomic) IBOutlet UIImageView *hotView;
@property (weak, nonatomic) IBOutlet UIScrollView *CarouselSC;
@property(nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong) IBOutlet UIButton *buttonText;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger isPush;
- (IBAction)buttonText:(id)sender;
@property (nonatomic, strong)HotLaButton *hotLableButton;
@property (nonatomic, strong)NSMutableArray *circleArr;
@property (nonatomic, copy)NSString *CircleUrl;



@property (nonatomic,strong) AVAudioPlayer *player;


@end

@implementation ShouKeBao


#pragma mark - 定位
- (void)locationMethod{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.distanceFilter = 100;//设置为100米
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager requestWhenInUseAuthorization];//或者下一句
//        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"请检查网络");
    }
}
#pragma mark - CLLocationManagerDelegate的代理方法
//   获取到位置数据，返回的是一个CLLocation的数组
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.loc = [locations lastObject];
    //   horizontalAccuracy位置精度
    if(self.loc.horizontalAccuracy > 0){
        NSLog(@"纬度 = %f, 经度 = %f, (位置精度)半径 = %f", self.loc.coordinate.latitude, self.loc.coordinate.longitude, self.loc.horizontalAccuracy);
    }
    //    verticalAccuracy海拔高度的精度, altitude海拔高度
    if(self.loc.verticalAccuracy > 0){
        NSLog(@"当前海拔高度：%.0f +/- %.0f meters",self.loc.altitude, self.loc.verticalAccuracy);
    }
    
}

//获取用户位置数据失败的回调方法，在此通知用户
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code] == kCLErrorDenied) {
        
        [manager stopUpdatingLocation];
        
    }else if ([error code] == kCLErrorLocationUnknown){
        NSLog(@"无法获取位置信息");
        static NSInteger i = 1;
        if (i == 1) {
            UIAlertView *theAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法获取位置信息,推荐您切换分站到上海" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [theAlertView show];
            [self.view addSubview:theAlertView];
        }
        i++;
    }else if ([error code] == kCLErrorNetwork){
        NSLog(@"用于检索位置的网络不可用");
        UIAlertView *theAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不可用！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [theAlertView show];
        [self.view addSubview:theAlertView];
    }
}

#pragma mark - 轮播
- (void)CarouselAnimationAction{

    self.CarouselSC.pagingEnabled = YES;
    self.CarouselSC.scrollEnabled = YES;
    self.CarouselSC.showsHorizontalScrollIndicator = NO;
    self.CarouselSC.showsVerticalScrollIndicator = NO;
//        self.CarouselSC.delegate = self;
    self.CarouselSC.contentSize = CGSizeMake(View_Width-90,50*self.circleArr.count);
    for (NSInteger i = 0; i < self.circleArr.count; i++) {
        
        self.hotLableButton = [[HotLaButton alloc]initWithFrame:CGRectMake(0, i*self.CarouselSC.frame.size.height, self.CarouselSC.frame.size.width, self.CarouselSC.frame.size.height)];
        
        [self.hotLableButton.button setTitle: [NSString stringWithFormat:@"%@",[self.circleArr[i]ProductThemeName]] forState:UIControlStateNormal];
        
        [self.hotLableButton.button addTarget:self action:@selector(buttonText:) forControlEvents:UIControlEventTouchUpInside];
        [self.CarouselSC addSubview:self.hotLableButton];
        
    }
}
- (void)startTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(nextNews) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)nextNews{
    if (self.pageNum < self.circleArr.count) {
        [self.CarouselSC setContentOffset:CGPointMake(0, 50*(++self.pageNum)) animated:YES];
    }if (self.pageNum >= self.circleArr.count) {
        
        [self.CarouselSC setContentOffset:CGPointMake(0, self.CarouselSC.contentOffset.y-50 *(self.pageNum))];
        self.pageNum = 0;
        
    }
}

- (IBAction)buttonText:(id)sender {
    //- (void)buttonText:(HotLaButton *)sender {
    [self ClickCarouselSCAction:self.pageNum];
    NSLog(@"diandian  %ld", self.pageNum);
    
}
- (void)ClickCarouselSCAction:(NSInteger)pageNum{
    CircleHotNewsViewController *circleHotVC = [[CircleHotNewsViewController alloc]init];
    circleHotVC.title = @"圈热点";
    circleHotVC.CircleUrl = self.CircleUrl;
    circleHotVC.m = 1;
    [self.navigationController pushViewController:circleHotVC animated:YES];
}
- (void)CarouselNews{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickCarouselSCAction:)];
    [self.CarouselView addGestureRecognizer:tap];
}

//离开页面时,关闭定位
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isPush = 1;
    NSUserDefaults *guiDefault = [NSUserDefaults standardUserDefaults];
    NSString *isTop = [guiDefault objectForKey:@"ThreeDTouch"];
    if ([isTop isEqualToString:@"UITouchText.scan"]) {
        ScanningViewController *scan = [[ScanningViewController alloc] init];
        scan.isLogin = YES;
        [guiDefault removeObjectForKey:@"ThreeDTouch"];
        [self.navigationController pushViewController:scan animated:YES];
    }

}
/*
- (BOOL) prepAudio

{
    
    NSError *error;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"message" ofType:@"mp3"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return NO;
        
    }
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]error:&error];
    
    if (!_player)
        
    {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        
        return NO;
        
    }
    
    [self.player prepareToPlay];
    [self.player play];
    //就是这行代码啦
    
    [self.player setNumberOfLoops:1];
    
    return YES;
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self prepAudio];
    [self loadCarouselNewsData];
    [self.view addSubview:self.tableView];
//    UITouch* touch = [[event touchesForView:btn] anyObject];
//    
//    CGPoint rootViewLocation = [touch locationInView:[UIApplication sharedApplication]];
    [self performSelector:@selector(checkNewVerSion) withObject:nil afterDelay:1.5];
    [self initPull];
    [self performSelector:@selector(checkProductOrder2) withObject:nil afterDelay:1.5];

    [self postwithNotLoginRecord];//上传未登录时保存的扫描记录
    [ self postWithNotLoginRecord2];//上传未登录时保存的客户
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.userIcon.layer andBorderColor:[UIColor clearColor] andBorderWidth:0.5 andNeedShadow:NO];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.SKBNewBtn.layer andBorderColor:[UIColor redColor] andBorderWidth:0.5 andNeedShadow:NO ];
    [self.SKBNewBtn addTarget:self action:@selector(pushToStoreFromButton) forControlEvents:UIControlEventTouchUpInside];

    [WMAnimations WMAnimationMakeBoarderWithLayer:self.searchBtn.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.5 andNeedShadow:NO];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thirdTouchPushScan:) name:@"3dTouchPushScan" object:nil];//3D Touch通知跳转二维码界面
    
//    [self.view addSubview:self.tableView];
    
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
  //  [self loadContentDataSource];
    
    [self  getUserInformation];
    
    
    
    // 长按搬救兵 打电话
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCall:)];
    longPress.minimumPressDuration = 1;
    [self.phoneBtn addGestureRecognizer:longPress];
    
    // 显示提醒
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(showRemind:) userInfo:nil repeats:YES];
    self.pushTime = timer;
    [[NSRunLoop currentRunLoop] addTimer:self.pushTime forMode:NSRunLoopCommonModes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealPushBackGround:) name:@"pushWithBackGround" object:nil];//若程序在前台，直接调用，在后台被点击则调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FromiMessage:) name:@"FromiMesseage" object:nil];
    NSUserDefaults *guiDefault = [NSUserDefaults standardUserDefaults];
    [guiDefault setObject:@"1" forKey:@"isLogoutYet"];//3Dtouch的类型
    NSString *SKBGuide = [guiDefault objectForKey:@"SKBGuide"];
    if ([SKBGuide integerValue] != 1) {// 是否第一次打开app
        [self Guide];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToRecommendList) name:@"notifiToPushToRecommed" object:nil];

    [[[UIApplication sharedApplication].delegate window]addSubview:self.progressView];
    
    [self setTagAndAlias];

     [self setUpNavBarView];
    //第一次加载
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstFindMoneyTree"]) {
//        Me * meVC = (Me *)[self.navigationController.tabBarController.viewControllers objectAtIndex:4];
        //        meVC.tabBarItem.badgeValue = @"";
        UIView *badgeView = [[UIView alloc]init];
        badgeView.tag = 888;
        badgeView.layer.cornerRadius = 5;
        badgeView.backgroundColor = [UIColor redColor];
        CGRect tabFrame = self.tabBarController.tabBar.frame;
        float percentX = (4 +0.6) / 5;
        CGFloat x = ceilf(percentX * tabFrame.size.width);
        CGFloat y = ceilf(0.1 * tabFrame.size.height);
        badgeView.frame = CGRectMake(x, y, 10, 10);
        [self.tabBarController.tabBar addSubview:badgeView];
    }
}
- (void)checkProductOrder2{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app checkProductOrder];
}
//给推送打tag和标签
-(void)setTagAndAlias
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    // 给用户打上jpush标签
    
//    NSString *alias = [def objectForKey:UserInfoKeyBusinessID];
//    [APService setAlias:alias callbackSelector:nil object:nil];
    [UMessage removeAllTags:nil];
    NSString *tag = [NSString stringWithFormat:@"substation_%@",[def objectForKey:UserInfoKeySubstation]];
//    [APService setTags:[NSSet setWithObject:tag] callbackSelector:nil object:nil];
//
//    [APService setTags:[NSSet setWithObject:[def objectForKey:UserInfoKeyBusinessID]] callbackSelector:nil object:nil];
    //给用户打上友盟标签
    [UMessage addTag:tag
            response:^(id responseObject, NSInteger remain, NSError *error) {
                
            }];
    NSString * string = [NSString stringWithFormat:@"business_%@", [def objectForKey:UserInfoKeyBusinessID]];
//    [UMessage addTag:string response:nil];
    [UMessage addTag:string response:^(id responseObject, NSInteger remain, NSError *error) {
        
    }];

    [UMessage getTags:^(NSSet *responseTags, NSInteger remain, NSError *error) {
        NSLog(@"%@", responseTags);
    }];
    [UMessage removeAlias:[NSString stringWithFormat:@"appuser_%@", [def valueForKey:@"AppUserID"]] type:@"appuser" response:^(id responseObject, NSError *error) {
        
    }];

    [UMessage addAlias:[NSString stringWithFormat:@"appuser_%@", [def valueForKey:@"AppUserID"]] type:@"appuser" response:^(id responseObject, NSError *error) {
    }];

}
-(void)thirdTouchPushScan:(NSNotification *)notiP{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [[[UIAlertView alloc] initWithTitle:@"哈哈" message:@"hah" delegate:self cancelButtonTitle:@"hah" otherButtonTitles: nil]show];
    [def removeObjectForKey:@"ThreeDTouch"];
    if (self.isPush == 1) {
        self.isPush = 0;
        ScanningViewController *scan = [[ScanningViewController alloc] init];
        scan.isLogin = YES;
        [self.navigationController pushViewController:scan animated:YES];

    }
}

//设置头部搜索与分站按钮
-(void)setUpNavBarView
{
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    
    if (screenW<375) {
        SKBNavBar *navBar = [SKBNavBar SKBNavBar];
        self.navigationItem.titleView = navBar;
        self.titleViewFrame = navBar.frame;


    }else{
        
        SKBNavBarFor6OrP *navBar = [SKBNavBarFor6OrP SKBNavBarFor6OrP];
        self.navigationItem.titleView = navBar;
        self.titleViewFrame = navBar.frame;

        
    }
   
}
//给navbar上控制蒙层
-(void)setCoverOnTitileViewWithFrame:(CGRect )frame
{
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    
    if (screenW<375) {
        
        UIView *cover = [[UIView alloc] init];
        CGFloat navBarW = frame.size.width;
        cover.frame = CGRectMake(screenW/2 - navBarW/2,5, frame.size.width-40, 34);
      //  cover.frame =CGRectMake(48, 25, navBarW-40, 34);
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
        
         self.navBarView = cover;
        
       // [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:cover];
        
     
        [self.navigationController.navigationBar addSubview:_navBarView];
        
    }else{
        UIView *cover = [[UIView alloc] init];
        CGFloat navBarW = frame.size.width;
        cover.frame = CGRectMake(screenW/2 - navBarW/2,5, frame.size.width-40, 34);
        //   cover.frame =CGRectMake(48, 25, navBarW, 34);
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
        self.navBarView = cover;
        [self.navigationController.navigationBar addSubview:_navBarView];
        // [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:cover];
        
       
        
    }

}
-(void)initPull
{

    //下拉
    [self.tableView addHeaderWithTarget:self action:@selector(headerPull)];
    self.tableView.headerPullToRefreshText =@"刷新内容";
    self.tableView.headerRefreshingText = @"正在刷新";
}
-(void)headerPull
{
     //[self.tableView headerBeginRefreshing];
    [self loadContentDataSource];
    [self.tableView headerEndRefreshing];
//    if (self.pushTime) {
//        [self.pushTime setFireDate:[NSDate distantFuture]];
//    }
}

#pragma mark - CheckNewVersion
- (void)checkNewVerSion{
    
    NSDictionary * param = @{};
    [MeHttpTool inspectionWithParam:param success:^(id json) {
        NSDictionary * dic = json[@"NewVersion"];
        NSLog(@"%@", json);
        self.checkVersionLinkUrl = dic[@"LinkUrl"];
        self.IOSUpdateType = [NSString stringWithFormat:@"%@", dic[@"IOSUpdateType"]];
        NSString * isMust = @"残忍拒绝";
        if ([dic[@"IsMustUpdate"] integerValue] == 1) {
            self.isMustUpdate = YES;
            isMust = @"退出程序";
        }
        NSArray * infoArray = dic[@"VersionInfo"];
        NSMutableString * infoString = [NSMutableString stringWithCapacity:1];
        for (int i = 0; i < infoArray.count; i++) {
            [infoString appendFormat:@"%d.%@\n",i + 1, [infoArray objectAtIndex:i]];
        }
        if ([dic[@"IsHaveNewVersion"]integerValue] == 1) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:infoString delegate:self cancelButtonTitle:isMust otherButtonTitles:@"立即更新", nil];
            [alertView show];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        /*
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
         */
        if ([self.IOSUpdateType isEqualToString:@"0"]) {
            NewVersionWebViewController * NVWVC = [[NewVersionWebViewController alloc]init];
            NVWVC.LinkUrl = self.checkVersionLinkUrl;
            [NVWVC isFromBlock:^(BOOL isFromDown) {
                NSLog(@"%d", isFromDown);
                self.isFromDowmload = isFromDown;
            }];
            [self.navigationController pushViewController:NVWVC animated:YES];
        }else{
//             NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8", @"797395756"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.checkVersionLinkUrl]];
        }
    }else{
        if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"退出程序"]) {
            exit(0);
        }
    }
}



-(void)FromiMessage:(NSNotification *)noti{

    self.navigationController.tabBarController.selectedViewController = [self.navigationController.tabBarController.viewControllers objectAtIndex:0];
    NSString * webStr = noti.object;
    if ([webStr myContainsString:@"&title="]) {
        NSArray * webArray = [webStr componentsSeparatedByString:@"&title="];
        if (webArray.count) {
            NSString * tempStr = webArray[1];
            NSArray * temparray = [tempStr componentsSeparatedByString:@"&type="];
            NSString * titleStr = temparray[0];
            
            NSString * typeStr = temparray[1];
//            [[[UIAlertView alloc]initWithTitle:@"chanpin" message:titleStr delegate:nil cancelButtonTitle:nil otherButtonTitles:typeStr, nil]show];
            
            if ([typeStr isEqualToString:@"product"]) {
                ProduceDetailViewController * Product = [[ProduceDetailViewController alloc]init];
                Product.noShareInfo = YES;
                Product.produceUrl = webArray[0];
                Product.titleName = [titleStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self.navigationController pushViewController:Product animated:YES];
            }
        }
    }else{
        BaseWebViewController * webView = [[BaseWebViewController alloc]init];
        webView.linkUrl = webStr;
//        [[[UIAlertView alloc]initWithTitle:@"putong" message:webStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"3", nil]show];

        [self.navigationController pushViewController:webView animated:YES];
    }
}


#pragma  - mark程序未死亡时远程推送处理函数
-(void)dealPushBackGround:(NSNotification *)noti
{ //arr[0]是value arr[1]是key
    //orderId ,userId ,recommond ,productId ,messageId
   
    // [self getVoice];
    
    
//    self.tabBarItem.badgeValue = nil;
    [self headerPull];
    [self getUserInformation];
    

//    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isReceveNoti"];
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isReceveNoti"]) {
//    }
    
    
    NSMutableArray *message = noti.object;
    NSLog(@"viewController 里取得值是 is %@",message);
    
    
    NSUserDefaults *appIsBack = [NSUserDefaults standardUserDefaults];
    
//     NSString *result = [appIsBack objectForKey:@"appIsBack"];
    if([UIApplication sharedApplication].applicationState ==UIApplicationStateInactive){
//    if ([result isEqualToString:@"yes"]) {
        self.navigationController.tabBarController.selectedViewController = [self.navigationController.tabBarController.viewControllers objectAtIndex:0];
        [appIsBack setObject:@"no" forKey:@"appIsBack"];
        [appIsBack synchronize];

        if ([message[0] isEqualToString:@"orderId"]) {
            //已经处理的订单在发生变化时发送消息给用户，点击消息直接进入该订单消息的订单详情
            //message[2]是订单url
            OrderDetailViewController *detail = [[OrderDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
            detail.url = message[2];
            [self.navigationController pushViewController:detail animated:YES];
        }
        /*
        else if ([message[0] isEqualToString:@"remind"]){//客户提醒
            //跳remindDetail
            NSString *remindTime = message[1];
            NSString *remindContent = message[2];
            //time,note
            RemindDetailViewController *remindDetail = [[RemindDetailViewController alloc] init];
            remindDetail.time = remindTime;
            remindDetail.note = remindContent;
            [self.navigationController pushViewController:remindDetail animated:YES];
        }
        */
        else if ([message[0] isEqualToString:@"recommond"]){//精品推荐
            //精品推荐界面
            //无需参数，直接跳转到精品推荐
            UIStoryboard * SB = [UIStoryboard storyboardWithName:@"ProductRecommend" bundle:[NSBundle mainBundle]];
            ProductRecommendViewController * PRVC = (ProductRecommendViewController *)[SB instantiateViewControllerWithIdentifier:@"eeee"];
            [self.navigationController pushViewController:PRVC animated:YES];
        }
        
        else if ([message[0] isEqualToString:@"productId"]){
            
            //产品详情h5
            ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
            detail.produceUrl = message[2];
            detail.noShareInfo = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
        else if ([message[0] isEqualToString:@"messageId"]){//公告
            //进入h5
            NSString *messageURL = message[2];
            messageDetailViewController *messageDetail = [[messageDetailViewController alloc] init];
            messageDetail.messageURL = messageURL;
            [self.navigationController pushViewController:messageDetail animated:YES];
        }
        
        else if ([message[0] isEqualToString:@"OtherId"]){
            NSString * otherUrl = message[2];
            NSString * otherTitle = message[3];
            BaseWebViewController * webView = [[BaseWebViewController alloc]init];
            webView.linkUrl = otherUrl;
            webView.webTitle = otherTitle;
            [self.navigationController pushViewController:webView animated:YES];
        }else if([message[0] isEqualToString:@"SearchProduct"]){
            ProductList *list = [[ProductList alloc] init];
            list.productListFrom = FromKeyWord;
            list.pushedSearchK = message[3];
            list.title =  message[3];
//            NSDictionary * dic = @{@"TwoSubName": message[3]};
//            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:dic];
//            [MobClick event:@"FindProductList" attributes:dict];
            [self.navigationController pushViewController:list animated:YES];
            
        }else if ([message[0] isEqualToString:@"CustomerDynamic"]){//直客动态
            ZhiVisitorDynamicController *zhiVisit = [[ZhiVisitorDynamicController alloc] init];
            [self.navigationController pushViewController:zhiVisit animated:YES];
        }else{
        
        }

    }else{
       
        NSString *type = message[0];
        if (type.length>0) {
            if ([self.tabBarItem.badgeValue intValue]+1 > 99) {
              
                self.tabBarItem.badgeValue = @"99+";
                
            }else{
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[self.tabBarItem.badgeValue intValue]+1];
            }
            [UIApplication sharedApplication].applicationIconBadgeNumber = [self.tabBarItem.badgeValue integerValue];
            
//        [self getVoice];
        }
        if ([message[0] isEqualToString:@"messageId"]){//新公告
            self.barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;
            int valueCount = [self.barButton.badgeValue intValue];
            self.barButton.badgeValue = [NSString stringWithFormat:@"%d",valueCount+1];
            
          }
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


#pragma  - mark程序死亡时远程推送处理函数
-(void)dealPushForeground:(NSNotification *)noti
{ //arr[0]是value arr[1]是key
    //orderId ,userId ,recommond ,productId ,messageId
   
    NSMutableArray *message = noti.object;
    NSLog(@"viewController 里取得值是 is %@",message);
    
    [self headerPull];
    
    [self  getUserInformation];
  
    //[self getVoice];
    
    if ([message[0] isEqualToString:@"orderId"]) {
        //已经处理的订单在发生变化时发送消息给用户，点击消息直接进入该订单消息的订单详情
        //message[2]是订单url
        OrderDetailViewController *detail = [[OrderDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detail.url = message[2];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    else if ([message[0] isEqualToString:@"remind"]){//客户提醒
        //跳remindDetail
        NSString *remindTime = message[1];
        NSString *remindContent = message[2];
        //time,note
        RemindDetailViewController *remindDetail = [[RemindDetailViewController alloc] init];
        remindDetail.time = remindTime;
        remindDetail.note = remindContent;
        [self.navigationController pushViewController:remindDetail animated:YES];
    }
    
    else if ([message[0] isEqualToString:@"recommond"]){//精品推荐
        //精品推荐界面
        //无需参数，直接跳转到精品推荐
        UIStoryboard * SB = [UIStoryboard storyboardWithName:@"ProductRecommend" bundle:[NSBundle mainBundle]];
        ProductRecommendViewController * PRVC = (ProductRecommendViewController *)[SB instantiateViewControllerWithIdentifier:@"eeee"];
        [self.navigationController pushViewController:PRVC animated:YES];
    }
    
    else if ([message[0] isEqualToString:@"productId"]){
        
        //产品详情h5
        ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
        detail.produceUrl = message[2];
        detail.noShareInfo = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    else if ([message[0] isEqualToString:@"messageId"]){//公告
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


//-(void)getStationName
-(void)getStationName:(NSString *)latitude Longgitude:(NSString *)longitude
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
    
//    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    
//    hudView.labelText = @"加载中...";
    
//    [hudView show:YES];
    
    [HomeHttpTool getIndexHeadWithParam:dic success:^(id json){
        
        NSLog(@"首页个人消息汇总%@",json);
        
        NSMutableDictionary *muta = [NSMutableDictionary cleanNullResult:json];
        
       // self.yesterDayOrderCount.text = [NSString stringWithFormat:@"%@单",muta[@"OrderCount"]];
       
        NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已被光顾了%@次",muta[@"VisitorCount"]]];
        NSString *visitors = [NSString stringWithFormat:@"%@",muta[@"VisitorCount"]];
        
        [newStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,visitors.length)];
        self.yesterdayVisitors.attributedText = newStr;

        CGFloat screnW = [[UIScreen mainScreen] bounds].size.width;
        if (screnW == 320) {
            self.yesterdayVisitors.font = [UIFont systemFontOfSize:9];
        }else{
            self.yesterdayVisitors.font = [UIFont systemFontOfSize:11];
        }
        NSString *head = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginAvatar];
        NSString *IsLYGWStr = json[@"IsOpenConsultantApp"];
        NSLog(@"/// %@  ... %@",IsLYGWStr, head);
        [[NSUserDefaults standardUserDefaults] setObject:IsLYGWStr forKey:UserInfoKeyLYGWIsOpenVIP];
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"bigIcon"]];
        
//        self.userName.text = muta[@"ShowName"];
        self.shareLink = muta[@"LinkUrl"];
        if (![muta[@"ShareInfo"] isKindOfClass:[NSNull class]]) {
            NSMutableDictionary *info = [NSMutableDictionary cleanNullResult:muta[@"ShareInfo"]];
            self.shareDic = info;
        }
    } failure:^(NSError *error) {
        NSLog(@"首页个人消息汇总失败%@",error);
    }];
    
    
//    [hudView hide:YES];
}



- (void)getNotifiList
{
    NSMutableDictionary *dic = [NSMutableDictionary  dictionary];
    [HomeHttpTool getActivitiesNoticeListWithParam:dic success:^(id json) {
        NSLog(@"首页公告消息列表%@",json);
        NSMutableArray *arr = json[@"ActivitiesNoticeList"];
        
        self.barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;
       
        int count = 0;
        [self.isReadArr addObjectsFromArray:[WriteFileManager WMreadData:@"messageRead"]];
        for (int i = 0; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            if (![_isReadArr containsObject:dic[@"ID"]]) {
                count += 1;
            }
        }
        self.barButton.badgeValue = [NSString stringWithFormat:@"%d",count];        
    } failure:^(NSError *error) {
        NSLog(@"首页公告消息列表失败%@",error);
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isEmpty = NO;

//    [self.circleArr removeAllObjects];
    
    
//    视图将要出现时定位
//    [self locationMethod];
  
//    if (/* 如果没有推送数据就隐藏 */) {
//        self.CarouselView.hidden = YES;
//    }
    

    //我界面更改头像和名字之后  首页的同步
    self.userName.text =  [UserInfo shareUser].userName;
    NSString *head = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginAvatar];
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"bigIcon"]];

//    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userhead"]) {
//    self.userIcon.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"userhead"]];
//    }else{
//    NSString *head = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginAvatar];
//    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"bigIcon"]];
//    }
    [MobClick beginLogPageView:@"ShouKeBao"];
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBaoNum" attributes:dict];

    [MobClick event:@"ShouKeBaoAndFindproductNum" attributes:dict];

//    [self getNotifiList];
    
    NSString *latitude = [NSString stringWithFormat:@"%f", self.loc.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", self.loc.coordinate.longitude];
    
//    向接口传入经度纬度
    [self getStationName:latitude Longgitude:longitude];
    
//    [self getStationName];
    
    [self loadContentDataSource];
    [self setCoverOnTitileViewWithFrame:self.titleViewFrame];
    self.navBarView.userInteractionEnabled = YES;
    if (self.isFromDowmload && self.isMustUpdate) {
        [self checkNewVerSion];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

    NSString *numberStr = [NSString stringWithFormat:@"%ld", self.pageNum];
    [LocationSeting defaultLocationSeting].carouselPageNumber = numberStr;

//     [self.timer invalidate];
 
    [MobClick endLogPageView:@"ShouKeBao"];
    self.navBarView.userInteractionEnabled = NO;
    //[self.navBarView removeFromSuperview];
    
//    //            App图标上的角标
//    [UIApplication sharedApplication].applicationIconBadgeNumber = [self.tabBarItem.badgeValue intValue];
    
    
    
   }


#pragma mark - getter
- (NSTimer *)timer{
    if (!_timer) {
      self.timer = [[NSTimer alloc]init];
    }
    return _timer;
}
- (NSMutableArray *)circleArr{
    if (!_circleArr) {
        _circleArr = [NSMutableArray array];
    }
    return _circleArr;
}
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
         _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 214)];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 54, 0);
        _tableView.rowHeight = 105;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:237/255.0 alpha:1];
        [_tableView registerNib:[UINib nibWithNibName:@"invoiceCell" bundle:nil] forCellReuseIdentifier:@"invoiceCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SubscribeCell" bundle:nil] forCellReuseIdentifier:@"SubscribeCell"];
        //[_tableView registerClass:[SubscribeCell class] forCellReuseIdentifier:@"SubscribeCell"];
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
- (void)loadCarouselNewsData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [IWHttpTool WMpostWithURL:@"Home/GetCircleHotSpot" params:dic success:^(id json){
        NSLog(@"轮播json = %@", json);
        self.CircleUrl = json[@"CircleUrl"];
        for (NSDictionary *dic in json[@"CircleHotSporList"]) {
            CircleModel *model = [[CircleModel alloc]initWithDict:dic];
            [self.circleArr addObject:model];
        }
         NSLog(@"轮播  %@", self.circleArr);
        [self estimateCircleArrData];
        
      }failure:^(NSError *error) {
        NSLog(@"轮播接口请求失败 error is %@------",error);
    }];
}

- (void)estimateCircleArrData{
    
    if (self.circleArr.count == 0) {
        self.CarouselView.hidden = YES;
        self.tableView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 164);
    }else{
        [self circleLayout];
        self.CarouselView.hidden = NO;
        self.tableView.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 214);
    }

}


- (void)loadContentDataSource
{
    NSDictionary *param = @{};// 基本参数即可
    [HomeHttpTool getIndexContentWithParam:param success:^(id json) {
        NSLog(@"------------------------新接口是%@---------------------",json);
//        if (self.pushTime) {
//            [self.pushTime setFireDate:[NSDate distantPast]];
//        }
        if (![json[@"OrderList"] isKindOfClass:[NSNull class]]) {
            
//            dispatch_queue_t q = dispatch_queue_create("homelist_q", DISPATCH_QUEUE_SERIAL);
//            dispatch_async(q, ^{
                NSLog(@"-----count %lu",(unsigned long)[json[@"OrderList"] count]);
                [self.dataSource removeAllObjects];
               
                self.recommendCount = [json[@"RecommendProduct"][@"Count"] integerValue];
                NSLog(@"%ld$$$$", (long)self.recommendCount);
                // 添加精品推荐 如果有推荐的话
                if ([json[@"RecommendProduct"][@"Count"] integerValue] > 0) {
                
//                    [HomeHttpTool getRecommendProductListWithParam:@{@"DateRangeType":@"1"} success:^(id recommendJson) {
                    
            NSLog(@"-------------今日推荐新接口数据是:%@--------------",json[@"RecommendProduct"]);
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
                NSLog(@"..... %@", dic);
                MessageModel2 *message = [MessageModel2 modalWithDict:dic];
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
            

            //     加载双12专题数据
            NSLog(@"..... %@", json[@"ThematicActivity"]);
            NSDictionary *dic = json[@"ThematicActivity"];
            
            if (![NSString stringIsEmpty:dic[@"AivityId"]]) {
                DoubleModel *doubleModel = [DoubleModel modalWithDict:dic];
                HomeBase *baseDouble = [[HomeBase alloc]init];
                baseDouble.time = doubleModel.CreatedDate;
                baseDouble.model = doubleModel;
                baseDouble.idStr = doubleModel.LinkUrl;
//                [self.dataSource addObject:baseDouble];
                [self.dataSource insertObject:baseDouble atIndex:1];
            }

                // 清理数据 看有没有隐藏的 有就不要显示
                [self cleanDataSource];
         
//                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
//                });
//            });
            

        }

    } failure:^(NSError *error) {
        
    }];
}
- (void)circleLayout{
    // 轮播
//   NSString *pageNumber = [[LocationSeting defaultLocationSeting] carouselPageNumber];

//    if ([pageNumber isEqualToString:@""]) {
//        self.pageNum = 0;
//    }else{
//        self.pageNum = [pageNumber integerValue];
//    }
    [self CarouselAnimationAction];
    [self CarouselNews];
    
//    if (!_timer) {
//        self.timer = [[NSTimer alloc]init];
//    }
    [self startTimer];
}



#pragma mark - private
//第一次开机引导
-(void)Guide
{
    NSUserDefaults *guideDefault = [NSUserDefaults standardUserDefaults];
    self.guideView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _guideView.backgroundColor = [UIColor clearColor];
    self.guideImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
#warning 这里上线前需要优化“根据等级判断显示引导图是一张还是多张”
    if ([[guideDefault objectForKey:UserInfoKeyLYGWIsOpenVIP] isEqualToString:@"0"]) {
        [_guideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click1)]];
    }else{
        [_guideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)]];
    }
    self.guideImageView.image = [UIImage imageNamed:@"NewGuideSKB1"];


    [guideDefault setObject:@"1" forKey:@"SKBGuide"];
     [guideDefault synchronize];
    
    [self.guideView addSubview:_guideImageView];
    [[[UIApplication sharedApplication].delegate window] addSubview:_guideView];
}

-(void)click
{
    self.guideIndex++;
    
    NSString *str = [NSString stringWithFormat:@"NewGuideSKB%d",self.guideIndex+1];
    self.guideImageView.image = [UIImage imageNamed:str];
    
    CATransition *an1 = [CATransition animation];
    an1.type = @"rippleEffect";
    an1.subtype = kCATransitionFromRight;//用kcatransition的类别确定cube翻转方向
    an1.duration = 0.2;
    [self.guideImageView.layer addAnimation:an1 forKey:nil];
    if (self.guideIndex == 2) {
        [self.guideView removeFromSuperview];
    }
    NSLog(@"被店家－－－－－－－－－－－－－indexi is %d－－",_guideIndex);
}
-(void)click1
{
        [self.guideView removeFromSuperview];
}
// 显示提醒
- (void)showRemind:(NSTimer *)timer
{
    NSLog(@"-----remind-");
    NSArray *remindArr = [WriteFileManager readData:@"remindData"];
    NSLog(@"%@", remindArr);
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
    
  //先确定今日推荐排到位置
    HomeBase *recom;
    int recomIndex = 0;
    for (int i = 0 ; i<self.dataSource.count; i++) {
        HomeBase *base = self.dataSource[i];
        if ([base.model isKindOfClass:[Recommend class]]) {
            recomIndex = i;
        }
    }
    if (recomIndex>1) {
        recom = self.dataSource[recomIndex];
        if (self.dataSource[recomIndex]) {
            [self.dataSource insertObject:recom atIndex:1];
        }
        [self.dataSource removeObjectAtIndex:recomIndex + 1];
    }
    
    
  }

-(void)pushToStore
{
    StoreViewController *store =  [[StoreViewController alloc] init];
    store.PushUrl = _shareLink;
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBaoStore" attributes:dict];

    
      [self.navigationController pushViewController:store animated:YES];
}
-(void)pushToStoreFromButton
{
    StoreViewController *store =  [[StoreViewController alloc] init];
    store.PushUrl = _shareLink;
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBaoStore" attributes:dict];

    store.needOpenShare = YES;
   
    [self.navigationController pushViewController:store animated:YES];
}
- (void)changeStation{
   
   
    StationSelect *stationSelect = [[StationSelect alloc] init];

    [self.navigationController pushViewController:stationSelect animated:YES];
}

- (IBAction)phoneToService:(id)sender
{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBaoSOSClickNum" attributes:dict];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    SosViewController *sos = [sb instantiateViewControllerWithIdentifier:@"Sos"];
    sos.isFromMe =NO;
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
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBaoSearchProductClick" attributes:dict];
    
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
    NSMutableDictionary *new =  [StrToDic dicCleanSpaceWithDict:self.shareDic];
    self.shareDic = new;
    NSLog(@"self.shareDic ＝ %@", self.shareDic);
    id<ISSContent> publishContent = [ShareSDK content:self.shareDic[@"Desc"]
                                       defaultContent:self.shareDic[@"Desc"]
                                                image:[ShareSDK imageWithUrl:self.shareDic[@"Pic"]]
                                                title:self.shareDic[@"Title"]
                                                  url:self.shareDic[@"Url"]                                          description:self.shareDic[@"Desc"]
                                            mediaType:SSPublishContentMediaTypeNews];
    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@   ,  %@,地址：%@",_shareDic[@"Tile"],_shareDic[@"Desc"],_shareDic[@"Url"]] image:nil];
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", self.shareDic[@"Url"]]];

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
                                    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                                    [MobClick event:@"ShareSuccessAll" attributes:dict];
                                    [MobClick event:@"ShareSuccessAllJS" attributes:dict counter:3];

                                    [self.warningLab removeFromSuperview];
                                    
                                    if (type == ShareTypeCopy) {
                                        [MBProgressHUD showSuccess:@"复制成功"];
                                    }else{
                                        [MBProgressHUD showSuccess:@"分享成功"];
                                    }
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                                        
                                        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
                                        [postDic setObject:@"0" forKey:@"ShareType"];
                                        if (self.shareDic[@"Url"]) {
                                            [postDic setObject:self.shareDic[@"Url"]  forKey:@"ShareUrl"];
                                        }
                                        [postDic setObject:@"" forKey:@"PageUrl"];
                                        if (type ==ShareTypeWeixiSession) {
                                            [postDic setObject:@"1" forKey:@"ShareWay"];
                                        }else if(type == ShareTypeQQ){
                                            [postDic setObject:@"2" forKey:@"ShareWay"];
                                        }else if(type == ShareTypeQQSpace){
                                            [postDic setObject:@"3" forKey:@"ShareWay"];
                                        }else if(type == ShareTypeWeixiTimeline){
                                            [postDic setObject:@"4" forKey:@"ShareWay"];
                                        }

                                        
                                       
                                        [IWHttpTool postWithURL:@"Common/SaveShareRecord" params:@{@"ShareType":@"0"} success:^(id json) {
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
    
    self.barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    
   self.barButton.shouldHideBadgeAtZero = YES;
    //增大点选面积；
    self.navigationItem.leftBarButtonItem = self.barButton;
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(-15, -15, 50, 50)];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(ringAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.leftBarButtonItem.customView addSubview:button];
   
}

-(void)customRightBarItem
{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];;
    [btn addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"itemsaomiao"] forState:UIControlStateNormal];
   UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    //增大点选面积；
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(-15, -15, 50, 50)];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.rightBarButtonItem.customView addSubview:button];

    
}

-(void)ringAction
{
    NewMessageCenterController *messgeCenter = [[NewMessageCenterController alloc] init];
    [self.navigationController pushViewController:messgeCenter animated:YES];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 8;
    /*
     原有内容
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"MesseageCenterClick" attributes:dict];
    
    //messageCenterViewController *messgeCenter = [[messageCenterViewController alloc] init];
    
    //messgeCenter.delegate = self;
    
    self.barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;

//   ***************************
    NSString *biao = [NSString stringWithFormat:@"%d",[self.tabBarItem.badgeValue intValue] - [self.barButton.badgeValue intValue]];
    
    if ([biao intValue] > 99) {
        
        self.tabBarItem.badgeValue = @"99+";
        
    }else{
     self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[self.tabBarItem.badgeValue intValue] - [self.barButton.badgeValue intValue]];
    }
    
    
    
  
    
//   ***************************
    
//     self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[self.barButton.badgeValue intValue]];
    

//    [UIApplication sharedApplication].applicationIconBadgeNumber = [self.tabBarItem.badgeValue integerValue];

    
    NSLog(@"[UIApplication sharedApplication].applicationIconBadgeNumber = %ld", [UIApplication sharedApplication].applicationIconBadgeNumber);

   
    NSLog(@"applicationIconBadgeNumber = %ld", [self.tabBarItem.badgeValue integerValue]);
//   ***************************
    if ([self.tabBarItem.badgeValue intValue] <= 0) {
        self.tabBarItem.badgeValue = nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
        [self.navigationController pushViewController:messgeCenter animated:YES];
//
     */
}


-(void)codeAction
{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"QRcodeClickInMainView" attributes:dict];

    ScanningViewController *scan = [[ScanningViewController alloc] init];
    scan.isLogin = YES;
    [self.navigationController pushViewController:scan animated:YES];

//    QRCodeViewController *qrc = [[QRCodeViewController alloc] init];
//    [self.navigationController pushViewController:qrc animated:YES];

}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        HomeBase *model = self.dataSource[indexPath.row];
     //[model retain];
//    if([model.model isKindOfClass:[invoiceCell class]]){//发票
//       invoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"invoiceCell" forIndexPath:indexPath];
//        //[invoiceCell showDataWithModel:model];
//        return cell;
//    }
//    if ([model.model isKindOfClass:[SubscribeCell class]]) {//订阅
//        SubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubscribeCell" forIndexPath:indexPath];
//        return cell;
//    }
    if ([model.model isKindOfClass:[HomeList class]]) {//订单
        ShouKeBaoCell *cell = [ShouKeBaoCell cellWithTableView:tableView];
        cell.model = model.model;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
         return cell;
        
    }else if ([model.model isKindOfClass:[MessageModel2 class]]){//公告
       
        messageCellSKBTableViewCell *cell = [messageCellSKBTableViewCell cellWithTableView:tableView];
        cell.model = model.model;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
        
    }else if([model.model isKindOfClass:[DoubleModel class]]){
//        双12
        Double12TableViewCell *cell = [Double12TableViewCell cellWithTableView:tableView];
        cell.doubleModel = model.model;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
        
    }else if([model.model isKindOfClass:[Recommend class]]){//精品推荐

        
//之所以大费周章的取count 就是因为在返回首页的时候指定self.count=0,再执行这个方法点时候会以为图片为0，从而影响CollectionView的布局；
        Recommend *rmodel = model.model;
        NSUInteger count = rmodel.RecommendIndexProductList.count;
        
        //      RecommendCell *cell = [RecommendCell cellWithTableView:tableView];
        
        
        RecommendCell *cell = [RecommendCell cellWithTableView:tableView number:count];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ShouKeBaoNav = self.navigationController;
        
        NSLog(@"self.recommendCount)%ld", self.recommendCount);
        
        //
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.recommend = model.model;
        
        // 如果没有数据的话就隐藏这个红点
        cell.redTip.hidden = !(self.recommendCount > 0);
        
        //        self.yesorno = self.cell.redTip.hidden;
        
        //        if (!(self.recommendCount > 0)) {
        //            self.cell.redTip.hidden = !(self.recommendCount > 0);
        ////            隐藏
        //            self.yesorno = 0;
        //        }else{
        //
        ////          显示
        //            self.yesorno = 1;
        //
        //        }
        
        
        if ([cell.redTip.backgroundColor isEqual:[UIColor clearColor]]) {
            self.yesorno = YES;
        }else{
            self.yesorno = NO;
        }
        
        
        NSLog(@" -----self.yesorno = %d --- self.recommendCount)%ld", self.yesorno, self.recommendCount);
        
#warning 铃铛角标刷新
        [self getNotifiList];
        
        return cell;
        
        
    }else{//客户提醒
       
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
    NSLog(@"self.tabBarItem.badgeValue = %d", [self.tabBarItem.badgeValue intValue]);
    
    
    
    NSString *fff = [NSString stringWithFormat:@"%d",[self.tabBarItem.badgeValue intValue] - 1];
    if ([fff intValue] > 99) {
        self.tabBarItem.badgeValue = @"99+";
        
    }else{
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[self.tabBarItem.badgeValue intValue] - 1];
    }
    
    
    if ([self.tabBarItem.badgeValue intValue] <= 0) {
        self.tabBarItem.badgeValue = nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }

    if ([model.model isKindOfClass:[HomeList class]]) {
        [MobClick event:@"ShouKeBao_ClickHomeList"];
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"ShouKeBaoOrderDetailClick" attributes:dict];

        HomeList *order = model.model;
        OrderDetailViewController *detail = [[OrderDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detail.url = order.LinkUrl;
        detail.title = @"订单详情";
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if([model.model isKindOfClass:[Recommend class]]){
        
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"RecommendClick" attributes:dict];
//******************************
        self.isEmpty = YES;
        Recommend *mo = model.model;
        NSString *createDate = mo.CreatedDate;
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:createDate forKey:@"redTip"];
        [def synchronize];
        [self nitifiToPushRecommendListWithUrl];
        
       // RecommendViewController *rec = [[RecommendViewController alloc] init];
        
    }else if ([model.model isKindOfClass:[MessageModel2 class]]){
        messageDetailViewController *msgDetail = [[messageDetailViewController alloc] init];
        MessageModel2 *msg = model.model;
        msgDetail.messageURL = msg.LinkUrl;
        msgDetail.m = 1;
        [self.navigationController pushViewController:msgDetail animated:YES];
        
    }else if([model.model isKindOfClass:[DoubleModel class]]){
        CircleHotNewsViewController *themeDetailVC = [[CircleHotNewsViewController alloc]init];
        DoubleModel *double12 = model.model;
        themeDetailVC.title = double12.FirstTitle;
        themeDetailVC.CircleUrl = double12.LinkUrl;
//        NSLog(@"....%@....___ %@", self.dataSource, double12.LinkUrl);
        
        [self.navigationController pushViewController:themeDetailVC animated:YES];
        
    }else{//客户提醒
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
//    RecomViewController *rec = [[RecomViewController alloc] init];
//    NSLog(@"%d", self.isEmpty);
//    rec.isFromEmpty = self.isEmpty;
//   [self.navigationController pushViewController:rec animated:YES];
    
    

    UIStoryboard * SB = [UIStoryboard storyboardWithName:@"ProductRecommend" bundle:[NSBundle mainBundle]];
    ProductRecommendViewController * PRVC = (ProductRecommendViewController *)[SB instantiateViewControllerWithIdentifier:@"eeee"];
    [self.navigationController pushViewController:PRVC animated:YES];
//    NSUserDefaults *change = [NSUserDefaults standardUserDefaults];
//     [change setBool:YES forKey:@"change"];
//    [change synchronize];
    
    // 刷新下 隐藏红点
    NSLog(@"tableView y_________");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        
      self.recommendCount = 0;
        
        
    });

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
   
    //HomeBase *model = [[HomeBase alloc] init];
    HomeBase *model = self.dataSource[indexPath.row];
    if ([model.model isKindOfClass:[Recommend class]]) {
        
        Recommend *rmodel = model.model;
        
        NSUInteger count = rmodel.RecommendIndexProductList.count;
       
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        
        double radious = screenH/667;
        
        NSLog(@"-----------------radious is %.3f---------",radious);
        
//        NSInteger count = 3;
      
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
            return 180*radious;
        }else{
            if (screenH == 480) {
                
                return 400*radious+25;
            }
            
            return 368*radious;

        }
        
    }else if([model.model isKindOfClass:[SubscribeCell class]]){
        return 90;
     
    }else if([model.model isKindOfClass:[DoubleModel class]]){
        return 200;
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
    NSLog(@"arr = %@", arr);
    
    if (arr.count>0) {
    
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:arr forKey:@"CredentialsPicRecordList"];
        
        [IWHttpTool WMpostWithURL:@"Customer/SyncCredentialsPicRecord" params:dic success:^(id json) {
            NSLog(@"1上传record成功,json is %@",json);

                    NSArray *new = [NSArray array];
            [WriteFileManager saveData:new name:@"record"];
//    [MBProgressHUD showSuccess:@"已同步未登录时的扫描信息"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        [MBProgressHUD hideHUD];
    });

        } failure:^(NSError *error) {
            NSLog(@"上传record失败");
        }];
    
    }
   
  
}

-(void)postWithNotLoginRecord2//未登录时添加的客户
{
    NSArray *arr = [NSArray arrayWithArray:[WriteFileManager readData:@"record2"]];//未登录时储存的客户;
   
    if (arr.count>0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
          [dic setObject:arr forKey:@"CredentialsPicRecordList"];
        
        [IWHttpTool WMpostWithURL:@"Customer/SyncCredentialsPicRecord" params:dic success:^(id json) {
            NSLog(@"22222上传record成功,参数是%@,json is %@",arr,json);
            
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
            NSMutableArray *arr2 = [NSMutableArray array];
            for (int i = 0; i<arr.count; i++) {
                NSString *recodId = arr[i][@"RecordId"];
                [arr2 addObject:recodId];
            }
            [dic2 setObject:arr2 forKey:@"RecordIds"];
            [IWHttpTool WMpostWithURL:@"Customer/CopyCredentialsPicRecordToCustomer" params:dic2 success:^(id json) {
                NSLog(@"222222导入未登录客户成功 参数是%@,返回json is %@",dic2,json);
                
                NSArray *new = [NSArray array];
                [WriteFileManager saveData:new name:@"record2"];
//                [MBProgressHUD showSuccess:@"已同步未登录时添加的客户信息"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
//                    [MBProgressHUD hideHUD];
//                });
                
            } failure:^(NSError *error) {
                NSLog(@"批量导入客户失败，返回error is %@",error);
            }];

                  } failure:^(NSError *error) {
            NSLog(@"上传record失败");
        }];

       }
   
   
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
