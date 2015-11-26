//eeee
//  ViewController.m
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//
// RGB颜色
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#import "ViewController.h"
#import "Customers.h"
#import "OldCustomerViewController.h"
#import "FindProduct.h"
#import "Me.h"
#import "Orders.h"
#import "ShouKeBao.h"
#import "WMNavigationController.h"
#import "ResizeImage.h"
#import "FindProductNew.h"
#import "ChatViewController.h"
#import "EMCDDeviceManager.h"
#import "RobotManager.h"
#import "EaseMob.h"
#import "NewMessageCenterController.h"
#import "APNSHelper.h"
#import "LocationSeting.h"
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";


#define UserInfoKeyLYGWIsOpenVIP @"LVGWIsOpenVIP"//是否开通vip
@interface ViewController ()<IChatManagerDelegate, EMCallManagerDelegate>
@property (copy ,nonatomic) NSMutableString *skbValue;
@property (copy ,nonatomic) NSMutableString *fdpValue;
@property (copy ,nonatomic) NSMutableString *odsValue;
@property (copy ,nonatomic) NSMutableString *cstmValue;
@property (copy ,nonatomic) NSMutableString *meValue;
@property (nonatomic, strong)ShouKeBao * shoukebaoVC;
@property (nonatomic, strong)Customers * customers;

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    [self setupUnreadMessageCount];
    [self registerNotifications];
   self.skbValue = [NSMutableString stringWithFormat:@"%d",0];
    self.fdpValue = [NSMutableString stringWithFormat:@"%d",0];
    self.odsValue = [NSMutableString stringWithFormat:@"%d",0];
    self.cstmValue = [NSMutableString stringWithFormat:@"%d",0];
    self.meValue = [NSMutableString stringWithFormat:@"%d",0];

    
    self.shoukebaoVC = [[ShouKeBao alloc] init];
    
    [self addChildVc:self.shoukebaoVC title:@"旅游圈" image:@"skb2" selectedImage:@"skb"];
    

   // [[self.childViewControllers objectAtIndex:0] setBadgeValue:_skbValue];
    
    
    
    
    UIStoryboard * SB = [UIStoryboard storyboardWithName:@"FindProductNew" bundle:[NSBundle mainBundle]];
    FindProductNew * FPVC = (FindProductNew *)[SB instantiateViewControllerWithIdentifier:@"FindProductNewSB"];
    [self addChildVc:FPVC   title:@"找产品" image:@"fenlei2" selectedImage:@"fenlei"];

//    FindProduct *fdp = [[FindProduct alloc] init];
//    
//    [self addChildVc:fdp title:@"找产品" image:@"fenlei2" selectedImage:@"fenlei"];
    
    Orders *ods = [[Orders alloc] init];
    [self addChildVc:ods title:@"理订单" image:@"lidingdan" selectedImage:@"lidingdan2"];
   // [[self.childViewControllers objectAtIndex:2] setBadgeValue:_odsValue];

    
   
//    if([[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLYGWIsOpenVIP] isEqualToString:@"0"]){     //没有开通
//        
//        OldCustomerViewController *oldCustomerVC = [[OldCustomerViewController alloc]init];
//        [self addChildVc:oldCustomerVC title:@"管客户" image:@"kehu2" selectedImage:@"kehu"];
//    }else{
        self.customers = [[Customers alloc] init];
        [self addChildVc:self.customers title:@"管客户" image:@"kehu2" selectedImage:@"kehu"];
//    }

    
    Me *me = [[Me alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildVc:me title:@"我" image:@"wo2" selectedImage:@"wo"];
    
    NSLog(@"%@", self.selectedViewController);
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealPushForeground:) name:@"pushWithForeground" object:nil];
    
    NSUserDefaults *appIsBack = [NSUserDefaults standardUserDefaults];
    
    [appIsBack setObject:@"no" forKey:@"appIsBack"];
    
    [appIsBack synchronize];

}
#pragma  - mark程序在前台时远程推送处理函数
//-(void)dealPushForeground:(NSNotification *)noti
//{ //arr[0]是value arr[1]是key
//    //orderId ,userId ,recommond ,productId ,messageId
//       
//    
//    
//     NSMutableArray *message = noti.object;
//     NSLog(@"viewController 里取得值是 is %@",message);
//    
//    if ([message[0] isEqualToString:@"orderId"]) {
//        
//      self.odsValue = [NSMutableString stringWithFormat:@"%d",[self.odsValue intValue]+1];
//       
//    }
//    
//    else if ([message[0] isEqualToString:@"remind"]){
//        
//        
//        [[self.tabBarController.childViewControllers objectAtIndex:0] setBadgeValue:@"1"];
//    }
//    
//    else if ([message[0] isEqualToString:@"recommond"]){
//        
//        self.skbValue = [NSMutableString stringWithFormat:@"%d",[self.skbValue intValue]+1];
//    }
//    
//    else if ([message[0] isEqualToString:@"productId"]){
//        
//        
//          self.skbValue = [NSMutableString stringWithFormat:@"%d",[self.skbValue intValue]+1];
//    }
//    
//    else if ([message[0] isEqualToString:@"messageId"]){
//      self.skbValue = [NSMutableString stringWithFormat:@"%d",[self.skbValue intValue]+1];
//    }
//    
//    else if ([message[0] isEqualToString:@"noticeType"]){
//        
//       self.skbValue = [NSMutableString stringWithFormat:@"%d",[self.skbValue intValue]+1];
//        
//    }
//}
//

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title;
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];

    
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
//
    // 先给外面传进来的小控制器 包装 一个导航控制器
    WMNavigationController *nav = [[WMNavigationController alloc] initWithRootViewController:childVc];
    
   [self addChildViewController:nav];
}
// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    //    if (_chatListVC) {
    //        if (unreadCount > 0) {
    //            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
    //        }else{
    //            _chatListVC.tabBarItem.badgeValue = nil;
    //        }
    //    }
    NSLog(@"%ld", (long)unreadCount);
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
    //    [_chatListVC refreshDataSource];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineCmdMessages
{
    
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    NSLog(@"%@", _customers);
    if (_customers) {
        [_customers.table reloadData];
        [self customerInformationCenterTimePrompt];
    }
    
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
        //#if !TARGET_IPHONE_SIMULATOR
        
        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
            [self showNotificationWithMessage:message];
        }else {
            [self playSoundAndVibration];
        }
        //#endif
    }
}

- (void)customerInformationCenterTimePrompt{
    NSDate *sendDate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *locationTimeString=[dateformatter stringFromDate:sendDate];
    _customers.timePrompt.text = locationTimeString;
    [LocationSeting defaultLocationSeting].customMessageDateStr = locationTimeString;
}


-(void)didReceiveCmdMessage:(EMMessage *)message
{
    //    [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        else if (message.messageType == eMessageTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName)
            {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}


- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NewMessageCenterController *messgeCenter = [[NewMessageCenterController alloc] init];
    [self.shoukebaoVC.navigationController pushViewController:messgeCenter animated:NO];
    self.selectedViewController = ((ShouKeBao *)self.viewControllers[0]);
    ChatViewController * chatVC = [[ChatViewController alloc]initWithChatter:userInfo[@"ConversationChatter"] conversationType:eConversationTypeChat];
    [chatVC hideImagePicker];
    [self.shoukebaoVC.navigationController pushViewController:chatVC animated:YES];
    /*
     if (userInfo)
     {
     if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
     ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
     [chatController hideImagePicker];
     }
     
     NSArray *viewControllers = self.navigationController.viewControllers;
     [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
     if (obj != self)
     {
     if (![obj isKindOfClass:[ChatViewController class]])
     {
     [self.navigationController popViewControllerAnimated:NO];
     }
     else
     {
     NSString *conversationChatter = userInfo[kConversationChatter];
     ChatViewController *chatViewController = (ChatViewController *)obj;
     if (![chatViewController.chatter isEqualToString:conversationChatter])
     {
     [self.navigationController popViewControllerAnimated:NO];
     EMMessageType messageType = [userInfo[kMessageType] intValue];
     chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
     switch (messageType) {
     case eMessageTypeGroupChat:
     {
     NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
     for (EMGroup *group in groupArray) {
     if ([group.groupId isEqualToString:conversationChatter]) {
     chatViewController.title = group.groupSubject;
     break;
     }
     }
     }
     break;
     default:
     chatViewController.title = conversationChatter;
     break;
     }
     [self.navigationController pushViewController:chatViewController animated:NO];
     }
     *stop= YES;
     }
     }
     else
     {
     ChatViewController *chatViewController = (ChatViewController *)obj;
     NSString *conversationChatter = userInfo[kConversationChatter];
     EMMessageType messageType = [userInfo[kMessageType] intValue];
     chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
     switch (messageType) {
     case eMessageTypeGroupChat:
     {
     NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
     for (EMGroup *group in groupArray) {
     if ([group.groupId isEqualToString:conversationChatter]) {
     chatViewController.title = group.groupSubject;
     break;
     }
     }
     }
     break;
     default:
     chatViewController.title = conversationChatter;
     break;
     }
     [self.navigationController pushViewController:chatViewController animated:NO];
     }
     }];
     }
     */
    //    else if (_chatListVC)
    //    {
    //        [self.navigationController popToViewController:self animated:NO];
    //        [self setSelectedViewController:_chatListVC];
    //    }
}

#pragma mark - public

- (void)jumpToChatList
{
    //    [[[UIAlertView alloc]initWithTitle:@"test" message:@"test" delegate:nil cancelButtonTitle:@"aaa" otherButtonTitles:nil, nil]show];
    //    self.selectedViewController = ((HomePage *)self.viewControllers[0]);
    //    ChatViewController * VC = [[ChatViewController alloc]initWithChatter:@"admin" conversationType:eConversationTypeChat];
    //    [VC hideImagePicker];
    //    [self.homePageNav pushViewController:VC animated:YES];
    //    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
    //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
    //        [chatController hideImagePicker];
    //    }
    //    else if(_chatListVC)
    //    {
    //        [self.navigationController popToViewController:self animated:NO];
    //        [self setSelectedViewController:_chatListVC];
    //    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMMessageType)type
{
    EMConversationType conversatinType = eConversationTypeChat;
    switch (type) {
        case eMessageTypeChat:
            conversatinType = eConversationTypeChat;
            break;
        case eMessageTypeGroupChat:
            conversatinType = eConversationTypeGroupChat;
            break;
        case eMessageTypeChatRoom:
            conversatinType = eConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

@end
