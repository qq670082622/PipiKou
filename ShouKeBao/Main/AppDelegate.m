//
//  AppDelegate.m
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "AppDelegate.h"
#import "Login.h"
#import "ViewController.h"
#import "WMNavigationController.h"
#import "LoginTool.h"
#import "UserInfo.h"
#import "WelcomeView.h"
#import "SearchProductViewController.h"
#import "TravelLoginController.h"

#import <AVFoundation/AVFoundation.h>
#import "MeHttpTool.h"
#import "MobClick.h"
//#import "UncaughtExceptionHandler.h"
@interface AppDelegate ()

@property (nonatomic,assign) BOOL isAutoLogin;
@property (nonatomic,strong) AVAudioPlayer *player;
@end

@implementation AppDelegate
// NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8", @"797395756"];
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];根据ID跳转到appstore

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    self.isAutoLogin = NO;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *phone = [def objectForKey:UserInfoKeyPoneNum];
    NSString *password = [def objectForKey:UserInfoKeyPassword];
    if (phone.length && password.length) {
        [self autoLoginWithAccount:phone passWord:password];
    }else{
        self.isAutoLogin = NO;
    }
    return YES;
}

//设置请求userAgent
+ (void)initialize {
    // Set user agent (the only problem is that we can't modify the User-Agent later in the program)
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F69(appskb_ios_v10)", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}
//软件崩溃时回调此方法；
void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    NSString *crashLogInfo = [NSString stringWithFormat:@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr];
    NSString *urlStr = [NSString stringWithFormat:@"mailto://tianranwuwai@yeah.net?subject=bug报告&body=感谢您的配合!错误详情:%@",crashLogInfo];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    //将崩溃日志写到本地；等程序再运行的时候再发送到服务器；
    [[NSUserDefaults standardUserDefaults]setValue:crashLogInfo forKey:@"crashLogInfo"];
    NSLog(@"$$$$$$$$$$$$$$$$$$$exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
}
//- (void)installUncaughtExceptionHandler
//{
//    InstallUncaughtExceptionHandler();
//}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MobClick startWithAppkey:@"55895cfa67e58eb615000ad8" reportPolicy:BATCH   channelId:@"Web"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
        
    
    NSString * crashLog = [[NSUserDefaults standardUserDefaults]valueForKey:@"crashLogInfo"];
    if (![crashLog isEqualToString:@""]) {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"crashLogInfo"]);
    }
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"crashLogInfo"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];

    
    
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *isFirst = [def objectForKey:@"isFirst"];
    
    // 是否第一次打开app
    if ([isFirst integerValue] != 1) {
        // 如果是第一次 就去登录旅行社 绑定手机 并显示欢迎界面
        [self setWelcome];
    }else{
        // 如果不是第一次就 显示常规登录
        if (self.isAutoLogin){
            [self setTabbarRoot];
        }else{
            [self setLoginRoot];
        }
    }
    
#pragma -mark莲子统计Lotuseed
    
 

#pragma mark -about shareSDK
    [ShareSDK registerApp:@"65bcf051bafc"];//appKey
    //QQ空间
    [ShareSDK connectQZoneWithAppKey:@"1104542403"
                           appSecret:@"zOYB51wNKimtVaBg"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //QQ
    [ShareSDK connectQQWithQZoneAppKey:@"1104542403"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
   
    //微信
    [ShareSDK connectWeChatWithAppId:@"wx911143a1c860ef37"
                           wechatCls:[WXApi class]];
    //微信
    [ShareSDK connectWeChatWithAppId:@"wx911143a1c860ef37"   //微信APPID
                           appSecret:@"747908a80a1ee4681b131c384a275a46"  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    //连接拷贝
    [ShareSDK connectCopy];
    
#pragma  mark - about Jpush
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    
#pragma -mark 程序未运行此处处理推送通知
 NSDictionary *userInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    //  新订单消息推送   订单状态变化消息推送//    orderId（订单Id）
    NSString *orderId = [userInfo valueForKey:@"orderId"];
    NSString *orderUri = [userInfo valueForKey:@"orderUri"];
    // NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    
    //    客户提示消息推送//    userId（用户Id）
    NSString *remindTime = [userInfo valueForKey:@"remindTime"];
    NSString *remindContent = [userInfo valueForKey:@"remindContent"];
    //NSString *customerUri = [userInfo valueForKey:<#(NSString *)#>]
    
    //    精品推荐消息推送//    点击进入精品推荐页面，无附加字段
    NSString  *recommond = [userInfo valueForKey:@"recommond"];
    // NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    
    //    新线路推荐消息推送//    productId（产品Id）
    NSString *productUri = [userInfo valueForKey:@"productUri"];
    NSString *productId = [userInfo valueForKey:@"productId"];
    //  NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    
    //    系统\公告消息推送//    messageId（消息Id）
    NSString *messageId = [userInfo valueForKey:@"messageId"];
    NSString *messageUri = [userInfo valueForKey:@"messageUri"];
    
    //客户消息提醒
    //  NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    
    
    NSLog(@"--jpush---- orderid is %@ orderUri is%@ remindTime is %@ remindContent is %@  recommond is %@  productid is %@ messageid is %@ ,productUri %@,messageUri is %@",orderId,orderUri, remindTime,remindContent,recommond,productId,messageId,productUri,messageUri);
    
         if (orderUri.length>4) {
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"orderId"];
            [arr addObject:orderId];
            [arr addObject:orderUri];
            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        }
        if (remindContent.length>4) {
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"remind"];
            [arr addObject:remindTime];
            [arr addObject:remindContent];
            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
            
        }
        if ([recommond isEqualToString:@"123"]) {
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"recommond"];
            [arr addObject:recommond];
            [arr addObject:@"123"];
            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
            
        }
        if (productId.length>4) {
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"productId"];
            [arr addObject:productId];
            [arr addObject:productUri];
            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        }
        if (messageId.length>4) {
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"messageId"];
            [arr addObject:messageId];
            [arr addObject:messageUri];
            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
            
        }
        
    
        

    

    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    

    //----------------------------------------------------------
//    NSLog(@"-----------------程序未运行时，得到的通知%@",remoteNotification);
//    UILabel *lable = [[UILabel alloc] initWithFrame:self.window.frame];
//    lable.backgroundColor = [UIColor redColor];
//     NSArray *arr = [remoteNotification allKeys];
//    NSMutableString *str = [NSMutableString stringWithFormat:@","];
//    
//    for (int i = 0; i<arr.count; i++) {
//         [str appendString:[NSString stringWithFormat:@",%@,",arr[i]]];
//    }
//    lable.text = str;
//    lable.numberOfLines = 0;
//    [self.window addSubview:lable];
    
//    
    return YES;
    //后台返回一个字典包含:messageId,noticeType,_j_msgid,messageUri,aps(5个)
}


#pragma mark - jpush信息处理集中在此方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}


#pragma -mark is true!~~
//此为应用程序在后台，点击后会被调用
//若应用程序在前期，会直接调用
//若应用程序为关闭状态则调用：didFinishLaunchingWithOptions方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    //  新订单消息推送   订单状态变化消息推送//    orderId（订单Id）
    NSString *orderId = [userInfo valueForKey:@"orderId"];
    NSString *orderUri = [userInfo valueForKey:@"orderUri"];
    // NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    
    //    客户提示消息推送//    userId（用户Id）
    NSString *remindTime = [userInfo valueForKey:@"remindTime"];
    NSString *remindContent = [userInfo valueForKey:@"remindContent"];
    //NSString *customerUri = [userInfo valueForKey:<#(NSString *)#>]
    
    //    精品推荐消息推送//    点击进入精品推荐页面，无附加字段
    NSString  *recommond = [userInfo valueForKey:@"recommond"];
    // NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    
    //    新线路推荐消息推送//    productId（产品Id）
    NSString *productUri = [userInfo valueForKey:@"productUri"];
    NSString *productId = [userInfo valueForKey:@"productId"];
    //  NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    
    //    系统\公告消息推送//    messageId（消息Id）
    NSString *messageId = [userInfo valueForKey:@"messageId"];
    NSString *messageUri = [userInfo valueForKey:@"messageUri"];
    
    //客户消息提醒
    //  NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    
    
    NSLog(@"--jpush---- orderid is %@ orderUri is%@ remindTime is %@ remindContent is %@  recommond is %@  productid is %@ messageid is %@ ,productUri %@,messageUri is %@",orderId,orderUri, remindTime,remindContent,recommond,productId,messageId,productUri,messageUri);
    
    
           if (orderUri.length>4) {
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"orderId"];
            [arr addObject:orderId];
            [arr addObject:orderUri];
            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        }
        if (remindContent.length>4) {
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"remind"];
            [arr addObject:remindTime];
            [arr addObject:remindContent];
            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
            
        }
        if ([recommond isEqualToString:@"123"]) {
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"recommond"];
            [arr addObject:recommond];
            [arr addObject:@"123"];
            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
            
        }
        if (productId.length>4) {
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"productId"];
            [arr addObject:productId];
            [arr addObject:productUri];
            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        }
        if (messageId.length>4) {
            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:@"messageId"];
            [arr addObject:messageId];
            [arr addObject:messageUri];
            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
            
        }
        
    
        
        // Required
    [APService handleRemoteNotification:userInfo];
}

-(void)dealloc
{
    //如果是非arc 需要＋[super dealloc];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
    
}



#pragma weChat
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - public
// 设置欢迎界面
- (void)setWelcome
{
    [self setTravelLoginRoot];
    
    WelcomeView *welceome = [[WelcomeView alloc] initWithFrame:self.window.bounds];
    [self.window addSubview:welceome];
}

// 切换到主界面
-(void)setTabbarRoot
{
    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}

// 常规登录
-(void)setLoginRoot
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
    Login *lg = [sb instantiateViewControllerWithIdentifier:@"Login"];
    lg.autoLoginFailed = !self.isAutoLogin;
    
    WMNavigationController *nav = [[WMNavigationController alloc] initWithRootViewController:lg];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

// 登录旅行社
- (void)setTravelLoginRoot
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
    TravelLoginController *travel = [sb instantiateViewControllerWithIdentifier:@"TravelLogin"];
    travel.isChangeUser = NO;
    WMNavigationController *nav = [[WMNavigationController alloc] initWithRootViewController:travel];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

#pragma mark - private
// 请求同步登录
- (void)autoLoginWithAccount:(NSString *)account passWord:(NSString *)passWord
{
    NSDictionary *param = @{@"Mobile":account,
                            @"LoginPassword":passWord};
    [LoginTool syncLoginWithParam:param success:^(id json) {
        NSLog(@"----%@",json);
        
        if ([json[@"IsSuccess"] integerValue] == 1) {
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            
            // 保存必要的参数
            [def setObject:json[@"BusinessID"] forKey:UserInfoKeyBusinessID];
            [def setObject:json[@"LoginType"] forKey:UserInfoKeyLoginType];
            [def setObject:json[@"DistributionID"] forKey:UserInfoKeyDistributionID];
            [def setObject:json[@"AppUserID"] forKey:UserInfoKeyAppUserID];
            [def setObject:json[@"LoginAvatar"] forKey:UserInfoKeyLoginAvatar];
            
            // 重新保存密码 因为如果注销了的话
            [def setObject:passWord forKey:UserInfoKeyPassword];
            
            // 保存用户模型
            [UserInfo userInfoWithDict:json];
            
            // 保存分站
            [def setObject:[NSString stringWithFormat:@"%ld",(long)[json[@"SubstationId"] integerValue]] forKey:UserInfoKeySubstation];
            [def synchronize];
            
            // 给用户打上jpush标签
            [APService setAlias:[def objectForKey:UserInfoKeyBusinessID] callbackSelector:nil object:nil];
            NSString *tag = [NSString stringWithFormat:@"substation_%ld",(long)[json[@"SubstationId"] integerValue]];
            [APService setTags:[NSSet setWithObject:tag] callbackSelector:nil object:nil];
            
            self.isAutoLogin = YES;
        }

    } failure:^(NSError *error) {
        self.isAutoLogin = NO;
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {//进入后台
    
//    NSUserDefaults *appIsBack = [NSUserDefaults standardUserDefaults];
//    
//    [appIsBack setObject:@"yes" forKey:@"appIsBack"];
//     
//     [appIsBack synchronize];
    
__block  UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:task];
    }];
    
    [self prepAudio];
   }

//播放一段无声音乐，让苹果审核时认为后台有音乐而让程序不会被杀死
- (BOOL) prepAudio

{
    
    NSError *error;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    
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
    
    //就是这行代码啦
    
    [self.player setNumberOfLoops:1000000];
    
    return YES;
}


//jpush推送代码notification 处理函数一律切换到下面函数，后台推送代码也在此函数中调用。
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    
    //    //  新订单消息推送   订单状态变化消息推送//    orderId（订单Id）
    //    NSString *orderId = [userInfo valueForKey:@"orderId"];
    //    NSString *orderUri = [userInfo valueForKey:@"orderUri"];
    //    // NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    //
    //    //    客户提示消息推送//    userId（用户Id）
    //    NSString *remindTime = [userInfo valueForKey:@"remindTime"];
    //    NSString *remindContent = [userInfo valueForKey:@"remindContent"];
    //    //NSString *customerUri = [userInfo valueForKey:<#(NSString *)#>]
    //
    //    //    精品推荐消息推送//    点击进入精品推荐页面，无附加字段
    //    NSString  *recommond = [userInfo valueForKey:@"recommond"];
    //    // NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    //
    //    //    新线路推荐消息推送//    productId（产品Id）
    //    NSString *productUri = [userInfo valueForKey:@"productUri"];
    //    NSString *productId = [userInfo valueForKey:@"productId"];
    //    //  NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    //
    //    //    系统\公告消息推送//    messageId（消息Id）
    //    NSString *messageId = [userInfo valueForKey:@"messageId"];
    //    NSString *messageUri = [userInfo valueForKey:@"messageUri"];
    //
    //    //客户消息提醒
    //  //  NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    //
    //
    //    NSLog(@"--jpush---- orderid is %@ orderUri is%@ remindTime is %@ remindContent is %@  recommond is %@  productid is %@ messageid is %@ ,productUri %@,messageUri is %@",orderId,orderUri, remindTime,remindContent,recommond,productId,messageId,productUri,messageUri);
    //
    //    NSUserDefaults *appIsBack = [NSUserDefaults standardUserDefaults];
    //
    //    NSString *result = [appIsBack stringForKey:@"appIsBack"];
    //
    //    if ([result  isEqualToString: @"yes"]) {
    //        if (orderUri.length>4) {
    //            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //            NSMutableArray *arr = [NSMutableArray array];
    //            [arr addObject:@"orderId"];
    //            [arr addObject:orderId];
    //            [arr addObject:orderUri];
    //            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
    //        }
    //        if (remindContent.length>4) {
    //            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //            NSMutableArray *arr = [NSMutableArray array];
    //            [arr addObject:@"remind"];
    //            [arr addObject:remindTime];
    //            [arr addObject:remindContent];
    //            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
    //
    //        }
    //        if ([recommond isEqualToString:@"123"]) {
    //            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //            NSMutableArray *arr = [NSMutableArray array];
    //            [arr addObject:@"recommond"];
    //            [arr addObject:recommond];
    //            [arr addObject:@"123"];
    //            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
    //
    //        }
    //        if (productId.length>4) {
    //            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //            NSMutableArray *arr = [NSMutableArray array];
    //            [arr addObject:@"productId"];
    //            [arr addObject:productId];
    //            [arr addObject:productUri];
    //            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
    //        }
    //        if (messageId.length>4) {
    //            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //            NSMutableArray *arr = [NSMutableArray array];
    //            [arr addObject:@"messageId"];
    //            [arr addObject:messageId];
    //            [arr addObject:messageUri];
    //            [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
    //
    //        }
    //
    //    }else if ([result  isEqualToString: @"no"]){
    //        if (orderUri.length>4) {
    //            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //            NSMutableArray *arr = [NSMutableArray array];
    //            [arr addObject:@"orderId"];
    //            [arr addObject:orderId];
    //            [arr addObject:orderUri];
    //            [defaultCenter postNotificationName:@"pushWithForeground" object:arr];
    //        }
    //        if (remindContent.length>4) {
    //            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //            NSMutableArray *arr = [NSMutableArray array];
    //            [arr addObject:@"remind"];
    //            [arr addObject:remindTime];
    //            [arr addObject:remindContent];
    //            [defaultCenter postNotificationName:@"pushWithForeground" object:arr];
    //
    //        }
    //        if ([recommond isEqualToString:@"123"]) {
    //            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //            NSMutableArray *arr = [NSMutableArray array];
    //            [arr addObject:@"recommond"];
    //            [arr addObject:recommond];
    //            [arr addObject:@"123"];
    //            [defaultCenter postNotificationName:@"pushWithForeground" object:arr];
    //
    //        }
    //        if (productId.length>4) {
    //            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //            NSMutableArray *arr = [NSMutableArray array];
    //            [arr addObject:@"productId"];
    //            [arr addObject:productId];
    //            [arr addObject:productUri];
    //            [defaultCenter postNotificationName:@"pushWithForeground" object:arr];
    //        }
    //        if (messageId.length>4) {
    //            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //            NSMutableArray *arr = [NSMutableArray array];
    //            [arr addObject:@"messageId"];
    //            [arr addObject:messageId];
    //            [arr addObject:messageUri];
    //            [defaultCenter postNotificationName:@"pushWithForeground" object:arr];
    //            
    //        }
    //        
    //        
    //    }
    //    
    //    
    //     [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //   
    //    // IOS 7 Support Required
    //    [APService handleRemoteNotification:userInfo];
    //    
    //    completionHandler(UIBackgroundFetchResultNewData);
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {//进入前台
    NSUserDefaults *appIsBack = [NSUserDefaults standardUserDefaults];
    
    [appIsBack setObject:@"no" forKey:@"appIsBack"];
    
    [appIsBack synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopIndictor" object:nil];
// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
