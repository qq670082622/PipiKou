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
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,20)];
    [leftBtn setImage:[UIImage imageNamed:@"ip6"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"ip6"] forState:UIControlStateHighlighted];

    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(-1, -10, 0, 50);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-48, 0, 0);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
        UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
        turnOff.titleLabel.font = [UIFont systemFontOfSize:16];
        turnOff.frame = CGRectMake(0, 0, 30, 10);
        [turnOff addTarget:self action:@selector(turnOff) forControlEvents:UIControlEventTouchUpInside];
        [turnOff setTitle:@"关闭"  forState:UIControlStateNormal];
        turnOff.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
        [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];

    
}
-(void)turnOff
{
    [self.navigationController popViewControllerAnimated:YES];
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
