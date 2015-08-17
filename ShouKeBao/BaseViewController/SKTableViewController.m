//
//  SKTableViewController.m
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKTableViewController.h"

#import "UIViewController+MLTransition.h"
@interface SKTableViewController ()

@end

@implementation SKTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self addGest];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//  因为iOS7鼓励全屏布局，它的默认值很自然地是UIRectEdgeAll，四周边缘均延伸，设置为UIRectEdgeNone避免此问题
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
- (void)setNav{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,15)];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateHighlighted];
    
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(-1, -10, 0, 50);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    turnOff.titleLabel.font = [UIFont systemFontOfSize:15];
    turnOff.frame = CGRectMake(0, 0, 30, 10);
    [turnOff addTarget:self action:@selector(turnOff) forControlEvents:UIControlEventTouchUpInside];
    [turnOff setTitle:@"关闭"  forState:UIControlStateNormal];
    turnOff.titleEdgeInsets = UIEdgeInsetsMake(-2, -35, 0, 0);
    [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];

    
}
-(void)turnOff
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)addGest{
    UIScreenEdgePanGestureRecognizer *screenEdge = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreen:)];
    screenEdge.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdge];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleScreen:(UIScreenEdgePanGestureRecognizer *)sender{
    CGPoint sliderdistance = [sender translationInView:self.view];
    if (sliderdistance.x>self.view.bounds.size.width/3) {
        [self back];
    }
    //NSLog(@"%f",sliderdistance.x);
}
@end
