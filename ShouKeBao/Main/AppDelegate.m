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
#import "BindPhoneViewController.h"
#import "SearchProductViewController.h"
@interface AppDelegate ()

@property (nonatomic,assign) BOOL isAutoLogin;

@end

@implementation AppDelegate
// NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8", @"797395756"];
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];根据ID跳转到appstore

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    self.isAutoLogin = NO;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *account = [def objectForKey:@"account"];
    NSString *password = [def objectForKey:@"password"];
    if (account.length && password.length) {
        [self autoLoginWithAccount:account passWord:password];
    }else{
        self.isAutoLogin = NO;
    }
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];

    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *phone = [def objectForKey:@"phonenumber"];
    
    // 是否绑定
    if (phone) {
        // 如果自动登录了 就切到主界面
        if (self.isAutoLogin) {
            [self setTabbarRoot];
        }else{
            [self setLoginRoot];
        }
    }else{
        // 如果未绑定手机号 去绑定手机
        [self setBindRoot];
    }
    
#pragma mark -about shareSDK
    [ShareSDK registerApp:@"65bcf051bafc"];//appKey
    //QQ空间
    [ShareSDK connectQZoneWithAppKey:@"1104440028"
                           appSecret:@"2ANfew5nXyU5HOcz"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //QQ
    [ShareSDK connectQQWithQZoneAppKey:@"1104440028"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
   
    //微信
    [ShareSDK connectWeChatWithAppId:@"wx64b55294f9f074c9"
                           wechatCls:[WXApi class]];
    //微信
    [ShareSDK connectWeChatWithAppId:@"wx64b55294f9f074c9"   //微信APPID
                           appSecret:@"86715ba658374d84b7bc08514e0d0540"  //微信APPSecret
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
    
    
    return YES;
}


//#pragma mark - jpush信息处理集中在此方法
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    
//    
//    // IOS 7 Support Required
//    
//    [APService setBadge:0];
//    
//    [APService handleRemoteNotification:userInfo];
//    
//    completionHandler(UIBackgroundFetchResultNewData);
//}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}


//jpush推送代码notification 处理函数一律切换到下面函数，后台推送代码也在此函数中调用。如果是使用 iOS 7 的 Remote Notification 特性那么处理函数需要使用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    //    新订单消息推送//    orderId（订单Id）  //
   // NSString *newOrderID = [userInfo valueForKey:@"orderId"];
   // NSString *newOrderUri = [userInfo valueForKey:@"orderUri"];
   // NSString *noticeType = [userInfo valueForKey:@"noticeType"];

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
    
    NSLog(@"--jpush---- orderid is %@ orderUri is%@ remindTime is %@ remindContent is %@  recommond is %@  productid is %@ messageid is %@ ,productUri %@,messageUri is %@",orderId,orderUri, remindTime,remindContent,recommond,productId,messageId,productUri,messageUri);
   
    if (orderUri.length>4) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"orderId"];
        [arr addObject:orderId];
        [arr addObject:orderUri];
        [defaultCenter postNotificationName:@"push" object:arr];
}
    if (remindContent.length>4) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"remind"];
        [arr addObject:remindTime];
        [arr addObject:remindContent];
        [defaultCenter postNotificationName:@"push" object:arr];

    }
    if ([recommond isEqualToString:@"123"]) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"recommond"];
        [arr addObject:recommond];
        [arr addObject:@"123"];
        [defaultCenter postNotificationName:@"push" object:arr];

    }
    if (productId.length>4) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"productId"];
        [arr addObject:productId];
        [arr addObject:productUri];
        [defaultCenter postNotificationName:@"push" object:arr];
}
    if (messageId.length>4) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"messageId"];
        [arr addObject:messageId];
        [arr addObject:messageUri];
        [defaultCenter postNotificationName:@"push" object:arr];

    }



    [APService setBadge:0];
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    
      completionHandler(UIBackgroundFetchResultNewData);
    
}

-(void)dealloc
{
    //如果是非arc 需要＋[super dealloc];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
    
}
//app在前台或者后台运行中，则调用此函数
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
   
    // Required
    [APService handleRemoteNotification:userInfo];
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

#pragma public
-(void)setTabbarRoot
{
    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}

- (void)setBindRoot
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
    BindPhoneViewController *bind = [sb instantiateViewControllerWithIdentifier:@"BindPhone"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bind];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

}

-(void)setLoginRoot
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
    Login *lg = [sb instantiateViewControllerWithIdentifier:@"Login"];
    self.window.rootViewController = lg;
    [self.window makeKeyAndVisible];
}

#pragma mark - private
// 请求同步登录
- (void)autoLoginWithAccount:(NSString *)account passWord:(NSString *)passWord
{
    NSDictionary *param = @{@"LoginName":account,
                            @"LoginPassword":passWord};
    [LoginTool syncLoginWithParam:param success:^(id json) {
        NSLog(@"----%@",json);
        
        if ([json[@"IsSuccess"] integerValue] == 1) {
            [UserInfo userInfoWithDict:json];
            
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

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
