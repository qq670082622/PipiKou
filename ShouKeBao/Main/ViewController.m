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
   
   
    ShouKeBao *skb = [[ShouKeBao alloc] init];
    [self addChildVc:skb title:@"收客宝" image:@"APPshoukebao2" selectedImage:@"APPshoukebao"];
    
    FindProduct *fdp = [[FindProduct alloc] init];
    [self addChildVc:fdp title:@"找产品" image:@"APPgengduo" selectedImage:@"APPfenlei"];
    
    Orders *ods = [[Orders alloc] init];
    [self addChildVc:ods title:@"理订单" image:@"APPdingdan" selectedImage:@"APPlidingdan"];
    
    Customers *cstm = [[Customers alloc] init];
    [self addChildVc:cstm title:@"管客户" image:@"APPkehuguanli2" selectedImage:@"APPkehuguanli"];
    
    Me *me = [[Me alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildVc:me title:@"我" image:@"APPyonghuming" selectedImage:@"APPyonghuicon"];
    
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    //    childVc.tabBarItem.title = title; // 设置tabbar的文字
    //    childVc.navigationItem.title = title; // 设置navigationBar的文字
    
    // 设置子控制器的图片
   // childVc.tabBarItem.image = [UIImage imageNamed:image];
   childVc.tabBarItem.image = [ResizeImage reSizeImage:[UIImage imageNamed:image] toSize:CGSizeMake(28, 28)];
    childVc.tabBarItem.selectedImage = [ResizeImage reSizeImage:[UIImage imageNamed:selectedImage] toSize:CGSizeMake(28, 28)];
    
    //childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
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
