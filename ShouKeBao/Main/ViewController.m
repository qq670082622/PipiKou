//
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
#import "FindProduct.h"
#import "Me.h"
#import "Orders.h"
#import "ShouKeBao.h"
#import "WMNavigationController.h"
#import "ResizeImage.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
   
   
    ShouKeBao *skb = [[ShouKeBao alloc] init];
    [self addChildVc:skb title:@"收客宝" image:@"skb2" selectedImage:@"skb"];
    
    FindProduct *fdp = [[FindProduct alloc] init];
    [self addChildVc:fdp title:@"找产品" image:@"fenlei" selectedImage:@"fenlei2"];
    
    Orders *ods = [[Orders alloc] init];
    [self addChildVc:ods title:@"理订单" image:@"lidingdan" selectedImage:@"lidingdan2"];
    
    Customers *cstm = [[Customers alloc] init];
    [self addChildVc:cstm title:@"管客户" image:@"kehu2" selectedImage:@"kehu"];
    
    Me *me = [[Me alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildVc:me title:@"我" image:@"wo2" selectedImage:@"wo"];
    
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    
//    childVc.tabBarItem.image = [ResizeImage OriginImage:[UIImage imageNamed:image] scaleToSize:CGSizeMake(25, 25)]; ;
//        childVc.tabBarItem.selectedImage = [ResizeImage OriginImage:[UIImage imageNamed:selectedImage] scaleToSize:CGSizeMake(25, 25)];
    
//    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                [UIFont fontWithName:@"Helvetica" size:11.0], UITextAttributeFont, nil]
//                                      forState:UIControlStateNormal];
    
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    //    childVc.tabBarItem.title = title; // 设置tabbar的文字
    //    childVc.navigationItem.title = title; // 设置navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];

    
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
    // 先给外面传进来的小控制器 包装 一个导航控制器
    WMNavigationController *nav = [[WMNavigationController alloc] initWithRootViewController:childVc];
        
    // 添加navBar背景
    //[ nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarBack"] forBarMetrics:UIBarMetricsDefault];
           [self addChildViewController:nav];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
