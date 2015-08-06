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
//    [SKTableViewController  validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypeScreenEdgePan];
   UIGestureRecognizer * gestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(__MLTransition_HandlePopRecognizer:)];
    ((UIScreenEdgePanGestureRecognizer*)gestureRecognizer).edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:gestureRecognizer];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//  因为iOS7鼓励全屏布局，它的默认值很自然地是UIRectEdgeAll，四周边缘均延伸，设置为UIRectEdgeNone避免此问题
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
- (void)__MLTransition_HandlePopRecognizer:(UIGestureRecognizer *)gest{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
