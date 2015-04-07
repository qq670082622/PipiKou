//
//  Login.m
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Login.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Register.h"
#import "AppDelegate.h"
#import "ChildAccountViewController.h"
#import "WriteFileManager.h"
#import "LoginTool.h"
#import "UserInfo.h"

@interface Login () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UITextField *accountField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsZero;
    
    // 基本设置
    [self viewConfig];

    // 设置头部图标
    [self setupHeader];
    
    // 设置底部按钮
    [self setupFooter];
    
    self.accountField.text = @"lxstest";
    self.passwordField.text = @"123456";
//    self.accountField.text = @"18767155187";
//    self.passwordField.text = @"222222";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - private
- (void)viewConfig
{
    // 背景
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"navBarBack"];
    self.tableView.backgroundView = bg;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 登录按钮样式
    self.loginBtn.layer.cornerRadius = 25;
    self.loginBtn.layer.masksToBounds = YES;
    
    // 退出编辑
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tanHandle:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tanHandle:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
}

- (void)setupHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
    cover.backgroundColor = [UIColor clearColor];
    
    CGFloat iconX = (self.view.frame.size.width - 150) * 0.5;
    CGFloat iconY = (cover.frame.size.height - 150) * 0.5 + 20;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, 150, 150)];
    iconView.backgroundColor = [UIColor clearColor];
    iconView.image = [UIImage imageNamed:@"bigIcon"];
    [cover addSubview:iconView];
    
    self.tableView.tableHeaderView = cover;
}

- (void)setupFooter
{
    
}

/**
 *  登录
 */
- (IBAction)loginAction:(UIButton *)sender
{
    NSDictionary *param = @{@"LoginName":self.accountField.text,
                            @"LoginPassword":self.passwordField.text};
    [LoginTool loginWithParam:param success:^(id json) {
        
        NSLog(@"----%@",json);
        
        if ([json[@"IsSuccess"] integerValue] == 1) {
            [UserInfo userInfoWithDict:json];
            if ([json[@"LoginType"] integerValue] == 1) {
                ChildAccountViewController *child = [[ChildAccountViewController alloc] init];
                [self.navigationController pushViewController:child animated:YES];
            }else{
                AppDelegate *app = [UIApplication sharedApplication].delegate;
                [app setTabbarRoot];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.view endEditing:YES];
}

@end
