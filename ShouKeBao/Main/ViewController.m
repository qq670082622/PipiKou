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
#define UserInfoKeyLYGWIsOpenVIP @"LVGWIsOpenVIP"//是否开通vip
@interface ViewController ()
@property (copy ,nonatomic) NSMutableString *skbValue;
@property (copy ,nonatomic) NSMutableString *fdpValue;
@property (copy ,nonatomic) NSMutableString *odsValue;
@property (copy ,nonatomic) NSMutableString *cstmValue;
@property (copy ,nonatomic) NSMutableString *meValue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
   self.skbValue = [NSMutableString stringWithFormat:@"%d",0];
    self.fdpValue = [NSMutableString stringWithFormat:@"%d",0];
    self.odsValue = [NSMutableString stringWithFormat:@"%d",0];
    self.cstmValue = [NSMutableString stringWithFormat:@"%d",0];
    self.meValue = [NSMutableString stringWithFormat:@"%d",0];

    
    ShouKeBao *skb = [[ShouKeBao alloc] init];
    
    [self addChildVc:skb title:@"旅游圈" image:@"skb2" selectedImage:@"skb"];
    

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
        Customers *cstm = [[Customers alloc] init];
        [self addChildVc:cstm title:@"管客户" image:@"kehu2" selectedImage:@"kehu"];
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

@end
