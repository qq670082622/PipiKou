//
//  SKViewController.m
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

@interface SKViewController ()

@end

@implementation SKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 70)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"版权所有  盗版必究";
//    label.font = [UIFont systemFontOfSize:20];
//    [self.view addSubview:label];
//    [self.view sendSubviewToBack:label];
    // Do any additional setup after loading the view.
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
}

@end
