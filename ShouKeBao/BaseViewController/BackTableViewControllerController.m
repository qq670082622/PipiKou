//
//  BackTableViewControllerController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/5/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BackTableViewControllerController.h"

@interface BackTableViewControllerController ()

@end

@implementation BackTableViewControllerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setNav];
}


- (void)setNav
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
