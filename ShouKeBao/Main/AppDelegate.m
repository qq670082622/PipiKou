
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
#import <AudioToolbox/AudioToolbox.h>
#import "MeHttpTool.h"
#import "MobClick.h"
#import "UMessage.h"
#import "ShouKeBao.h"
#import "UIViewController+MLTransition.h"
#import "BaseClickAttribute.h"
#import "NSString+FKTools.h"
#import "CommandTo.h"
#import "LeaveShare.h"
#import "AppDelegate+Extend.h"
#import "HomeHttpTool.h"
#import <AudioToolbox/AudioToolbox.h>
#import "EaseMob.h"
#import "AppDelegate+EaseMob.h" 
#import "CommendToNo.h"
#import "LocationSeting.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
//#import "UncaughtExceptionHandler.h"
////aaaaa
@interface AppDelegate ()<WXApiDelegate>

@property (nonatomic,assign) BOOL isAutoLogin;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic, copy)NSString * urlstring;
@property (nonatomic, strong)ViewController * mainViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [LocationSeting defaultLocationSeting].carouselPageNumber = @"";
    [[LocationSeting defaultLocationSeting] setCarouselPageNumber:@""];
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    self.isAutoLogin = NO;

    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *isLogout = [def objectForKey:@"isLogoutYet"];
    NSLog(@"%@",isLogout);
    
    NSString *phone = [def objectForKey:UserInfoKeyPoneNum];
    NSString *password = [def objectForKey:UserInfoKeyPassword];
    if (phone.length && password.length) {
        [self autoLoginWithAccount:phone passWord:password];
    }else{
        self.isAutoLogin = NO;
    }
    return YES;
}
//3D Touch
//- (void)application:(UIApplication *)application
//performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
//  completionHandler:(void(^)(BOOL succeeded))completionHandler{
//    
//    
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    //    NSString *account = [def objectForKey:UserInfoKeyAccount];
//    //    NSString *password = [def objectForKey:UserInfoKeyAccountPassword];
//    //判断先前我们设置的唯一标识
//    NSString *isLogout = [def objectForKey:@"isLogoutYet"];
//    //if (![def boolForKey:@"isLogoutYet"]) {
//    NSLog(@"%@",isLogout);
//    if ([isLogout  isEqualToString: @"1"]) {
//        NSString *phone = [def objectForKey:UserInfoKeyPoneNum];
//        NSString *password = [def objectForKey:UserInfoKeyPassword];
//        NSDictionary *param = @{@"Mobile":phone,
//                                @"LoginPassword":password};
//        [LoginTool syncLoginWithParam:param success:^(id json) {
//            
//            
//            if ([json[@"IsSuccess"] integerValue] == 1) {
//                
//                if([shortcutItem.type isEqualToString:@"UITouchText.Product"]){
//                    [self setTabbarRoot];
//                    ((ViewController*)self.window.rootViewController).selectedViewController = [((ViewController*)self.window.rootViewController).viewControllers objectAtIndex:1];
//                }else if([shortcutItem.type isEqualToString:@"UITouchText.Order"]){
//                    [self setTabbarRoot];
//                    ((ViewController*)self.window.rootViewController).selectedViewController = [((ViewController*)self.window.rootViewController).viewControllers objectAtIndex:2];
//                }else if([shortcutItem.type isEqualToString:@"UITouchText.scan"]){
////                    ((ViewController*)self.window.rootViewController).selectedViewController = [((ViewController*)self.window.rootViewController).viewControllers objectAtIndex:4];
//                    self.window.rootViewController = nil;
//                    [self setTabbarRoot];
//                    [def setObject:@"UITouchText.scan" forKey:@"ThreeDTouch"];
//                    ((ViewController*)self.window.rootViewController).selectedViewController = [((ViewController*)self.window.rootViewController).viewControllers objectAtIndex:0];
//                }else if([shortcutItem.type isEqualToString:@"UITouchText.TodaySignIn"]){
//                    self.window.rootViewController = nil;
//                    [self setTabbarRoot];
//                    
//                    [def setObject:@"UITouchText.TodaySignIn" forKey:@"ThreeDTouch"];
//                    ((ViewController*)self.window.rootViewController).selectedViewController = [((ViewController*)self.window.rootViewController).viewControllers objectAtIndex:4];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"3dTouchPushYaoQianShu" object:nil];
//                    
//                }
//            }else{
//                if ([self.window.rootViewController isKindOfClass:[ViewController class]]) {
//                    if([shortcutItem.type isEqualToString:@"UITouchText.Product"]){
//                       [self setTabbarRoot];
//                        ((ViewController*)self.window.rootViewController).selectedViewController = [((ViewController*)self.window.rootViewController).viewControllers objectAtIndex:1];
//                    }else if([shortcutItem.type isEqualToString:@"UITouchText.Order"]){
//                        [self setTabbarRoot];
//                        ((ViewController*)self.window.rootViewController).selectedViewController = [((ViewController*)self.window.rootViewController).viewControllers objectAtIndex:2];
//                    }else if([shortcutItem.type isEqualToString:@"UITouchText.scan"]){
////                        ((ViewController*)self.window.rootViewController).selectedViewController = [((ViewController*)self.window.rootViewController).viewControllers objectAtIndex:4];
//                        self.window.rootViewController = nil;
//                        [self setTabbarRoot];
//                        
//                        [def setObject:@"UITouchText.scan" forKey:@"ThreeDTouch"];
//                        ((ViewController*)self.window.rootViewController).selectedViewController = [((ViewController*)self.window.rootViewController).viewControllers objectAtIndex:0];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"3dTouchPushScan" object:nil];
//                    }else if([shortcutItem.type isEqualToString:@"UITouchText.TodaySignIn"]){
//                        self.window.rootViewController = nil;
//                        [self setTabbarRoot];
//                        
//                        [def setObject:@"UITouchText.TodaySignIn" forKey:@"ThreeDTouch"];
//                        ((ViewController*)self.window.rootViewController).selectedViewController = [((ViewController*)self.window.rootViewController).viewControllers objectAtIndex:4];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"3dTouchPushYaoQianShu" object:nil];
//                    }
//                    
//                }
//            }
//        } failure:^(NSError *error) {
//            
//        }];
//        
//        
//    }else if ([isLogout  isEqualToString:@"2"]) {
//        [self setLoginRoot];//常规登录
//    }else{
//        
//        [self  setWelcome];
//    }
//}
//设置请求userAgent
+ (void)initialize {
    // Set user agent (the only problem is that we can't modify the User-Agent later in the program)
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];//下面mozilla。。。为打印的useragent
    NSString *currentVersion = [NSString stringWithFormat:@"Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F69(ios_skbapp_v%@)", [infoDic objectForKey:@"CFBundleVersion"]];
    NSLog(@"%@", currentVersion);
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:currentVersion, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}
//软件崩溃时回调此方法；
void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    NSString *crashLogInfo = [NSString stringWithFormat:@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr];
    NSString *urlStr = [NSString stringWithFormat:@"mailto://928572909@qq.com?subject=bug报告&body=感谢您的配合!错误详情:%@",crashLogInfo];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    //将崩溃日志写到本地；等程序再运行的时候再发送到服务器；
    [[NSUserDefaults standardUserDefaults] setValue:crashLogInfo forKey:@"crashLogInfo"];
    NSLog(@"$$$$$$$$$$$$$$$$$$$exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
}

//-(void) creatItem{
//    
//    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"TouchPro"];
//    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"TouchOrder"];
//     UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"TouchScan"];
//    UIApplicationShortcutIcon *icon4 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"TouchSignIn"];
//    
//    UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"UITouchText.Product" localizedTitle:@"找产品" localizedSubtitle:nil icon:icon1 userInfo:nil];
//    UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"UITouchText.Order" localizedTitle:@"理订单" localizedSubtitle:nil icon:icon2 userInfo:nil];
//     UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"UITouchText.scan" localizedTitle:@"扫一扫" localizedSubtitle:nil icon:icon3 userInfo:nil];
//    UIMutableApplicationShortcutItem *item4 = [[UIMutableApplicationShortcutItem alloc] initWithType:@"UITouchText.TodaySignIn" localizedTitle:@"每日签到" localizedSubtitle:nil icon:icon4 userInfo:nil];
//    
//    NSArray *addArr = @[item4,item3,item2,item1];
//    NSArray *existArr = [UIApplication sharedApplication].shortcutItems;
//    [UIApplication sharedApplication].shortcutItems = [existArr arrayByAddingObjectsFromArray:addArr];
//    [UIApplication sharedApplication].shortcutItems = addArr;
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[[UIAlertView alloc]initWithTitle:@"a" message:@"\ue40a" delegate:nil cancelButtonTitle:@"aa" otherButtonTitles:nil, nil]show];
    //    if (sysVersion>=8.0) {
//        UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
//        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
//        
//        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
//    }

    
//    [UIViewController validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
//    float  sysVersion = [[[UIDevice currentDevice]systemVersion]floatValue];//根据系统版本判断是否创建3D Touch
//    if (sysVersion >=9.0) {
//        [self creatItem];
//    }
//
    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];

    [UMessage startWithAppkey:@"55895cfa67e58eb615000ad8" launchOptions:launchOptions];
    [MobClick startWithAppkey:@"55895cfa67e58eb615000ad8" reportPolicy:BATCH   channelId:@"Web"];

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    
//    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    
    //判断程序是否在前台计时
     [self performSelector:@selector(changeDef) withObject:nil afterDelay:3];
    
    
//    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
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
        [self setWelcome];//初次登录进入欢迎界面
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSDictionary * dict = @{@"Version":currentVersion};
        [MobClick event:@"APPSetUpNumber" attributes:dict];
    }else{
        // 如果不是第一次就 显示常规登录
        if (self.isAutoLogin){
            [self setTabbarRoot];//登录到主界面
        }else{
            [self setLoginRoot];//常规登录
        }
    }
    [self setStartAnamation];

#pragma mark -about shareSDK
    [ShareSDK registerApp:@"8f5f9578ecf3"];//appKey
    //QQ空间
    [ShareSDK connectQZoneWithAppKey:@"1104801944"
                           appSecret:@"YxOiTnU0E1n2Jazq"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //QQ
    [ShareSDK connectQQWithQZoneAppKey:@"1104801944"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
   
    //微信
    [ShareSDK connectWeChatWithAppId:@"wxd8a389cef80dc827"
                           wechatCls:[WXApi class]];
    //微信(老王－收客宝)
//    [ShareSDK connectWeChatWithAppId:@"wx911143a1c860ef37"   //微信APPID
//                           appSecret:@"747908a80a1ee4681b131c384a275a46"  //微信APPSecret
//                           wechatCls:[WXApi class]];
    //(企业－收客宝app－微信支付)
    [ShareSDK connectWeChatWithAppId:@"wxd8a389cef80dc827"   //微信APPID
                           appSecret:@"c30ee5e1e98bebc7b28a214025feca9d"  //微信APPSecret
                           wechatCls:[WXApi class]];
    [WXApi registerApp:@"wxd8a389cef80dc827" withDescription:@"ShouKeBao"];

    //连接短信分享
    [ShareSDK connectSMS];
    //连接拷贝
    [ShareSDK connectCopy];
    
#pragma  mark - about UMeng
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
  
#endif
#pragma -mark 程序未运行此处处理推送通知
// NSDictionary *userInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
//    
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
//    //  NSString *noticeType = [userInfo valueForKey:@"noticeType"];
//    
//    
//    NSLog(@"--jpush---- orderid is %@ orderUri is%@ remindTime is %@ remindContent is %@  recommond is %@  productid is %@ messageid is %@ ,productUri %@,messageUri is %@",orderId,orderUri, remindTime,remindContent,recommond,productId,messageId,productUri,messageUri);
//    
//         if (orderUri.length>4) {
//            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//            NSMutableArray *arr = [NSMutableArray array];
//            [arr addObject:@"orderId"];
//            [arr addObject:orderId];
//            [arr addObject:orderUri];
//            [defaultCenter postNotificationName:@"pushWithCrash" object:arr];
//        }
//        if (remindContent.length>4) {
//            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//            NSMutableArray *arr = [NSMutableArray array];
//            [arr addObject:@"remind"];
//            [arr addObject:remindTime];
//            [arr addObject:remindContent];
//            [defaultCenter postNotificationName:@"pushWithCrash" object:arr];
//            
//        }
//        if ([recommond isEqualToString:@"123"]) {
//            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//            NSMutableArray *arr = [NSMutableArray array];
//            [arr addObject:@"recommond"];
//            [arr addObject:recommond];
//            [arr addObject:@"123"];
//            [defaultCenter postNotificationName:@"pushWithCrash" object:arr];
//            
//        }
//        if (productId.length>4) {
//            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//            NSMutableArray *arr = [NSMutableArray array];
//            [arr addObject:@"productId"];
//            [arr addObject:productId];
//            [arr addObject:productUri];
//            [defaultCenter postNotificationName:@"pushWithCrash" object:arr];
//        }
//        if (messageId.length>4) {
//            NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//            NSMutableArray *arr = [NSMutableArray array];
//            [arr addObject:@"messageId"];
//            [arr addObject:messageId];
//            [arr addObject:messageUri];
//            [defaultCenter postNotificationName:@"pushWithCrash" object:arr];
//            
//        }
//    
//    
//       //  IOS 7 Support Required
//    [APService handleRemoteNotification:userInfo];
    

    
    
    
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
    //    NSLog(@"gggg...");
 
//    
    return YES;
    //后台返回一个字典包含:messageId,noticeType,_j_msgid,messageUri,aps(5个)
}


#pragma mark - jpush信息处理集中在此方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    [UMessage registerDeviceToken:deviceToken];
    // Required
//    [APService registerDeviceToken:deviceToken];
}


#pragma -mark is true!~~
//此为应用程序在后台，点击后会被调用
//若应用程序在前期，会直接调用
//若应用程序为关闭状态则调用：didFinishLaunchingWithOptions方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage setAutoAlert:NO];

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
//    //  NSString *noticeType = [userInfo valueForKey:@"noticeType"];
//    
//    
//    NSLog(@"--jpush---- orderid is %@ orderUri is%@ remindTime is %@ remindContent is %@  recommond is %@  productid is %@ messageid is %@ ,productUri %@,messageUri is %@",orderId,orderUri, remindTime,remindContent,recommond,productId,messageId,productUri,messageUri);
//    
//    
//           if (orderUri.length>4) {
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
    
    [UMessage didReceiveRemoteNotification:userInfo];   
        // Required
//    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    //判断提醒震动
    NSString *NewsShakeDefine = [[NSUserDefaults standardUserDefaults] objectForKey:@"NewsShakeRemind"];
    NSLog(@"%@", NewsShakeDefine);
    if ([NewsShakeDefine integerValue] != 1) {//震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NewsVoiceRemind"] integerValue] != 1) {
        [self prepAudio];//声音
    }
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isReceveNoti"];
    NSString *noticeType = [userInfo valueForKey:@"noticeType"];
    NSString * objID = [userInfo valueForKey:@"objectId"];
    NSString * objUri = [userInfo valueForKey:@"objectUri"];
    NSString * objTitle = [userInfo valueForKey:@"noticeTitle"];

    if ([noticeType isEqualToString:@"SingleOrder"]) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"orderId"];
        [arr addObject:objID];
        [arr addObject:objUri];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        
    }else if([noticeType isEqualToString:@"PerfectProduct"]) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"recommond"];
        [arr addObject:noticeType];
        [arr addObject:@"123"];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        
    }else if ([noticeType isEqualToString:@"SingleProduct"]) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"productId"];
        [arr addObject:objID];
        [arr addObject:objUri];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        
    }else if ([noticeType isEqualToString:@"SingleArticle"]) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"messageId"];
        [arr addObject:objID];
        [arr addObject:objUri];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        
    }else if([noticeType isEqualToString:@"Other"]){
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"OtherId"];
        [arr addObject:objID];
        [arr addObject:objUri];
        [arr addObject:objTitle];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        
    }else if([noticeType isEqualToString:@"SearchProduct"]){
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"SearchProduct"];
        [arr addObject:objID];
        [arr addObject:objUri];
        [arr addObject:objTitle];
        [defaultCenter postNotificationName:@"pushWithBackGroundFindProduct" object:arr];
// 直客动态
    }else if([noticeType isEqualToString:@"CustomerDynamic"]){
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:@"CustomerDynamic"];
        [arr addObject:objID];
        [arr addObject:objUri];
        [arr addObject:objTitle];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:arr];
        
    }else {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        NSArray * array = @[@"elseType", @"", @""];
        [defaultCenter postNotificationName:@"pushWithBackGround" object:array];
    }
}


#pragma weChat
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    [ShareSDK handleOpenURL:url
                 wxDelegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{

    NSString * urlString = url.absoluteString;
    self.urlstring = urlString;
    if ([urlString myContainsString:@"pipikou://url="]) {
        [self performSelector:@selector(StartGoWebView) withObject:nil afterDelay:0.5];
//        [[[UIAlertView alloc]initWithTitle:@"aaaa" message:urlString delegate:nil cancelButtonTitle:@"bbbbb" otherButtonTitles:nil, nil]show];

//        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
//        [MobClick event:@"OpenAppFromShortMessage" attributes:dict];
    }else{
//        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
//        [MobClick event:@"OpenAppFromShareLink" attributes:dict];
    }
    
//    if ([urlString containsString:@"QQ41D9B706"]) {
//        NSString * webStr = [urlString componentsSeparatedByString:@"url="][1];
//        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//        [defaultCenter postNotificationName:@"FromiMesseage" object:webStr];
//    }
    
//    [[[UIAlertView alloc]initWithTitle:@"zhifu" message:url.absoluteString delegate:nil cancelButtonTitle:@"a" otherButtonTitles:nil, nil]show];
//    [WXApi handleOpenURL:url delegate:self];

    [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
    return YES;
}
-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SuccessPayBack" object:nil];
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                
                [[[UIAlertView alloc]initWithTitle:@"支付成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];

                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                [[[UIAlertView alloc]initWithTitle:@"支付失败" message:resp.errStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];

                break;
        }
    }
}
#pragma mark - public
// 设置欢迎界面
- (void)setWelcome
{
    [self setTravelLoginRoot];
    
    WelcomeView *welceome = [[WelcomeView alloc] initWithFrame:self.window.bounds];
    [self.window addSubview:welceome];
}
- (void)StartGoWebView{
    [MobClick event:@"OpenAppFromShortMessage"];
    NSString * webStr = [self.urlstring stringByReplacingOccurrencesOfString:@"pipikou://url=" withString:@""];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:@"FromiMesseage" object:webStr];

}
// 切换到主界面
-(void)setTabbarRoot
{
    self.mainViewController = [[ViewController alloc] init];
    self.window.rootViewController = self.mainViewController;
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
            
            
//            if ([UserInfo isOnlineUserWithBusinessID:@"1"]) {
//                [MobClick startWithAppkey:@"55895cfa67e58eb615000ad8" reportPolicy:BATCH   channelId:@"Web"];
//                NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//                [MobClick setAppVersion:version];
//            }
            

            // 保存必要的参数
            [def setObject:json[@"BusinessID"] forKey:UserInfoKeyBusinessID];
            [def setObject:json[@"LoginType"] forKey:UserInfoKeyLoginType];
            
            NSString *IsLYGWStr = json[@"IsOpenConsultantApp"];
            NSLog(@"%@",IsLYGWStr);
            [[NSUserDefaults standardUserDefaults] setObject:IsLYGWStr forKey:UserInfoKeyLYGWIsOpenVIP];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:UserInfoKeyIsShowQuanTouTiao];

            if (![json[@"DistributionID"]isEqualToString:(NSString *)[NSNull null]]) {
                [def setObject:json[@"DistributionID"] forKey:UserInfoKeyDistributionID];
            }
            
            [def setObject:json[@"AppUserID"] forKey:UserInfoKeyAppUserID];
            [def setObject:json[@"EasemobPwd"] forKey:UserInfoKeyEasemobPassWord];
            
            
            if (![json[@"LoginAvatar"] isEqual:(NSString *)[NSNull null]]) {
                [def setObject:json[@"LoginAvatar"] forKey:UserInfoKeyLoginAvatar];
            }
            
            // 重新保存密码 因为如果注销了的话
            [def setObject:passWord forKey:UserInfoKeyPassword];
            
            // 保存用户模型
            [UserInfo userInfoWithDict:json];
            
            // 保存分站
            [def setObject:[NSString stringWithFormat:@"%ld",(long)[json[@"SubstationId"] integerValue]] forKey:UserInfoKeySubstation];
            [def synchronize];
            [UMessage removeAllTags:nil];
            NSString *tag = [NSString stringWithFormat:@"substation_%ld",(long)[json[@"SubstationId"] integerValue]];
            //给用户打上友盟标签
            [UMessage addTag:tag
                    response:^(id responseObject, NSInteger remain, NSError *error) {
                        //add your codes
                    }];
            NSString * string = [NSString stringWithFormat:@"business_%@", [def objectForKey:UserInfoKeyBusinessID]];
            [UMessage addTag:string response:^(id responseObject, NSInteger remain, NSError *error) {
                NSLog(@"%@", error);

            }];
            NSLog(@"%@%@", string, tag);
            
            [UMessage getTags:^(NSSet *responseTags, NSInteger remain, NSError *error) {
                NSLog(@"%@", responseTags);
            }];
            [UMessage addAlias:[NSString stringWithFormat:@"appuser_%@", [def valueForKey:@"AppUserID"]] type:@"appuser" response:^(id responseObject, NSError *error) {
                NSLog(@"%@", error);
            }];
            
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
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler NS_AVAILABLE_IOS(8_0){
//    [[[UIAlertView alloc] initWithTitle:@"Opened!" message:@"This action only open the app... 😀" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];



}

- (void)applicationDidEnterBackground:(UIApplication *)application {//进入后台
    
//    UILocalNotification *notification = [[UILocalNotification alloc]init];
//    notification.alertBody = @"本地推送测试";
//    notification.fireDate  = [NSDate dateWithTimeIntervalSinceNow:5];
//    notification.applicationIconBadgeNumber = 10;
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isQQReloadView"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopIndictor" object:nil];
        
    NSUserDefaults *appIsBack = [NSUserDefaults standardUserDefaults];
    
    [appIsBack setObject:@"yes" forKey:@"appIsBack"];
     
     [appIsBack synchronize];
        
//            UILocalNotification *localNotification = UILocalNotification.new;
//            
//            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
//            localNotification.alertBody = @"You've closed me?!? 😡";
//            localNotification.alertAction = @"Open 😉";
//            localNotification.category = @"default_category";
//            
//            [application scheduleLocalNotification:localNotification];

        
__block  UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:task];
    }];
    
//    [self prepAudio];
   }
}
-(void)changeDef
{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@"no" forKey:@"appIsBack"];
    [def synchronize];
    NSLog(@"已经修改ddef＝＝＝＝＝＝＝＝＝＝＝＝＝＝");
    
}

//播放一段无声音乐，让苹果审核时认为后台有音乐而让程序不会被杀死
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
//密码修改的时候  强制下线
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:UserInfoKeyPassword];
    [self setTravelLoginRoot];
}

// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self loginApp];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKeyPassword]) {
        [self checkProductOrder];
    }
}
- (void)checkProductOrder{
    NSString * commandWords = [self getWordOfCommand];
    if (commandWords) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:commandWords forKey:@"CommandText"];
        
        [HomeHttpTool getAProductDetailWithCommandParam:dic success:^(id json) {
            NSDictionary *dataDic = json[@"ProductDetail"];
            NSLog(@"%@",json);
            if ([json[@"IsSuccess"] intValue]== 0 || [json[@"ErrorCode"] integerValue]==108) {
                NSLog(@"请求失败");
                if ([self.window viewWithTag:101] || [self.window viewWithTag:102]) {
                    UIView *background = [self.window viewWithTag:101];
                    UIView *commend = [self.window viewWithTag:102];
                    [background  removeFromSuperview];
                    [commend removeFromSuperview];
                }
                if (![self.window viewWithTag:117]) {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
                    view.backgroundColor = [UIColor blackColor];
                    view.alpha = 0.5;
                    view.tag = 117;
                    [self.window addSubview:view];
                }
                if (![self.window viewWithTag:116]) {
                    CommendToNo *commendtono = [[[NSBundle mainBundle] loadNibNamed:@"CommendToNo" owner:self options:nil] lastObject];
                    commendtono.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/4,[UIScreen mainScreen].bounds.size.width-22, 219);
                    commendtono.tag = 116;
                    [self.window addSubview:commendtono];
                }
            }else{
                NSLog(@"服务器返回有数据");
                if (![self.window.rootViewController isKindOfClass:[WMNavigationController class]]) {
                    NSInteger exite;
                    if ([self.window viewWithTag:117] || [self.window viewWithTag:116]) {
                        UIView *tallView =[self.window viewWithTag:117];
                        UIView *tallView1=[self.window viewWithTag:116];
                        [tallView removeFromSuperview];
                        [tallView1 removeFromSuperview];
                    }
                    if ([self.window viewWithTag:101]) {
                        NSLog(@"有口令框正在现实,无需创建");
                        exite = 1;
                    }else{
                        NSLog(@"没有口令框正在显示，需要创建");
                        exite = 0;
                        [NSString showbackgroundgray];
                    }
                    UINavigationController * nav = (UINavigationController *)((UITabBarController *)self.window.rootViewController).selectedViewController;
                    [NSString showcommendToDetailbody:dataDic[@"Name"]
                                                   Di:dataDic[@"PersonAlternateCash"]
                                                 song:dataDic[@"PersonCashCoupon"]
                                          retailsales:[NSString stringWithFormat:@"%@门市",dataDic[@"PersonPrice"]]
                                     CommandSamePrice:dataDic[@"PersonPeerPrice"]
                                               Picurl:dataDic[@"PicUrl"]
                                           NewPageUrl:dataDic[@"LinkUrl"]
                                            shareInfo:dataDic[@"ShareInfo"]
                                                exist:exite
                                                  Nav:nav];
                }
                
            }
        } failure:^(NSError *error) {
            NSLog(@"请求失败：%@",error);
        }];
    }
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (NSString *)getWordOfCommand{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    NSString * string = board.string;
    if (!string) {
        string = @"";
    }
    //创建正则表达式；pattern规则；
    NSString * pattern = @"¥.+¥";
    NSRegularExpression * regex = [[NSRegularExpression alloc]initWithPattern:pattern options:0 error:nil];
    NSString * pattern2 = @"￥.+￥";
    NSRegularExpression * regex2 = [[NSRegularExpression alloc]initWithPattern:pattern2 options:0 error:nil];

    //测试字符串；
    NSArray * result = [regex matchesInString:string options:0 range:NSMakeRange(0,string.length)];
    NSArray * result2 = [regex2 matchesInString:string options:0 range:NSMakeRange(0,string.length)];
    NSArray * newResult = [result arrayByAddingObjectsFromArray:result2];
    
    if (newResult.count) {
        //获取口令后，清空剪切版
        board.string = @"";
        //获取筛选出来的字符串
        NSString * resultStr = [string substringWithRange:((NSTextCheckingResult *)newResult[0]).range];
        if ([resultStr myContainsString:@"¥"]) {
           resultStr = [resultStr stringByReplacingOccurrencesOfString:@"¥" withString:@"￥"];
        }

       return resultStr;
    }
    return nil;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 回到前台
//    [[[UIAlertView alloc]initWithTitle:@"aa" message:@"aaa" delegate:nil cancelButtonTitle:@"aa" otherButtonTitles:nil, nil]show];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ThreeDTouch"] isEqualToString:@"UITouchText.scan"]) {
        ((ViewController*)self.window.rootViewController).selectedViewController = [((ViewController*)self.window.rootViewController).viewControllers objectAtIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"3dTouchPushScan" object:nil];

    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"ThreeDTouch"] isEqualToString:@"UITouchText.TodaySignIn"]){
        ((ViewController*)self.window.rootViewController).selectedViewController = [((ViewController*)self.window.rootViewController).viewControllers objectAtIndex:4];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"3dTouchPushYaoQianShu" object:nil];
    }

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_mainViewController) {
        [_mainViewController didReceiveLocalNotification:notification];
    }
}


@end
