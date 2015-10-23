//
//  ResultViewController.m
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ResultViewController.h"
#import "AppDelegate.h"
#import "MobClick.h"
@interface ResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *resultLab;

@property (weak, nonatomic) IBOutlet UIImageView *resultIcon;

@property (weak, nonatomic) IBOutlet UIButton *resultBtn;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账号安全设置";
    [self setNav];
    
    [self configureResult];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LoginResultView"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LoginResultView"];
}

- (void)setNav
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if (self.isSuccess) {
        leftBtn.enabled = NO;
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - configureview
- (void)configureResult
{
    self.resultLab.text = self.isSuccess ? @"密码修改成功" : @"密码修改失败";
    
    NSString *name = self.isSuccess ? @"mimaxiugai-chenggong" : @"mimaxiugai-shibai";
    self.resultIcon.image = [UIImage imageNamed:name];
    
    NSString *bgName = self.isSuccess ? @"denglu_bg" : @"fanhui_bg";
    NSString *text = self.isSuccess ? @"登录" : @"返回";
    UIColor *color = self.isSuccess ? [UIColor colorWithRed:1 green:149/255.0 blue:0 alpha:1] : [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
    [self.resultBtn setBackgroundImage:[UIImage imageNamed:bgName] forState:UIControlStateNormal];
    [self.resultBtn setTitle:text forState:UIControlStateNormal];
    [self.resultBtn setTitleColor:color forState:UIControlStateNormal];
}

- (IBAction)buttonClick:(id)sender
{
    if (self.isSuccess) {
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app setLoginRoot];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
