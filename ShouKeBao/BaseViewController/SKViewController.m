//
//  SKViewController.m
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

#import "UIViewController+MLTransition.h"
#import "ShouKeBao.h"
#import "Me.h"
#import "Orders.h"
#import "FindProduct.h"
@interface SKViewController ()

@end

@implementation SKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self addGest];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
}
- (void)addGest{
    UIScreenEdgePanGestureRecognizer *screenEdge = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreen:)];
    screenEdge.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdge];

}
- (void)setNav{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0,0,15,50);
//    [button setTitle:@"title" forState:UIControlStateNormal];
//    [button setImage:buttonImage forState:UIControlStateNormal];
//    button.imageEdgeInsets = UIEdgeInsetsMake(0.0, WIDTH(button.titleLabel) + 10.0, 0.0, 0.0);
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
//    leftBtn.imageView.image = [UIImage imageNamed:@"backarrow"];
//    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleScreen:(UIScreenEdgePanGestureRecognizer *)sender{
    CGPoint sliderdistance = [sender translationInView:self.view];
    if (sliderdistance.x>self.view.bounds.size.width/3) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
