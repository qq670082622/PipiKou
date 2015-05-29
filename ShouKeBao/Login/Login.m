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
#import "AppDelegate.h"
#import "ChildAccountViewController.h"
#import "WriteFileManager.h"
#import "LoginTool.h"
#import "UserInfo.h"
#import "Business.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "UIImage+QD.h"
#import "RegisterViewController.h"
#import "WMNavigationController.h"
#import "BindPhoneViewController.h"
#import "TravelLoginController.h"
#import "ScanningViewController.h"
@interface Login () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic,weak) UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UIImageView *imagebg2;

@property (nonatomic,assign) BOOL isModal;// 是否modal出来 是就不显示导航

@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollEnabled = NO;
    
    // 基本设置
    [self viewConfig];

    // 设置头部图标
    [self setupHeader];
    
    // 设置注册按钮
    [self setOtherBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    self.nameLab.text = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyPoneNum];
    
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.isModal) {
        self.navigationController.navigationBar.hidden = NO;
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - private
- (void)viewConfig
{
    // 背景
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    // 登录按钮样式
    self.imagebg2.image = [UIImage resizedImageWithName:@"bg_white"];
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.layer.masksToBounds = YES;
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"red-bg"] forState:UIControlStateNormal];
    
    // 退出编辑
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tanHandle:)];
    [self.view addGestureRecognizer:tap];
    
    if (self.autoLoginFailed) {// 如果自动登录失败
        
    }
}

// 返回
- (void)doBack:(UIBarButtonItem *)baritem
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 退出编辑
- (void)tanHandle:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
}

/**
 *  添加新用户按钮
 */
- (void)setOtherBtn
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 注册用户按钮
    CGFloat newW = 80;
    CGFloat newH = 30;
    CGFloat newX = 50;
    CGFloat newY = screenRect.size.height - newH - 10;
    UIButton *new = [[UIButton alloc] initWithFrame:CGRectMake(newX, newY, newW, newH)];
    new.layer.cornerRadius = 15;
    new.layer.masksToBounds = YES;
    [new addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    [new setTitle:@"新用户" forState:UIControlStateNormal];
    new.titleLabel.font = [UIFont systemFontOfSize:13];
    [new setBackgroundColor:[UIColor whiteColor]];
    [new setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [new setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [self.view addSubview:new];
    
    //证照神器
    CGFloat cardX = self.view.frame.size.width - 80 - newX;
    UIButton *card = [[UIButton alloc] initWithFrame:CGRectMake(cardX, newY, newW, newH)];
    card.layer.cornerRadius = 15;
    card.layer.masksToBounds = YES;
    [card addTarget:self action:@selector(Card:) forControlEvents:UIControlEventTouchUpInside];
    [card setTitle:@"证件神器" forState:UIControlStateNormal];
    card.titleLabel.font = [UIFont systemFontOfSize:13];
    [card setBackgroundColor:[UIColor whiteColor]];
    [card setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [card setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [self.view addSubview:card];

    
    // 切换用户按钮
    CGFloat changeW = 80;
    CGFloat changeX = screenRect.size.width - changeW - 10;
    UIButton *change = [[UIButton alloc] initWithFrame:CGRectMake(changeX, 30, changeW, 30)];
    [change setTitle:@"切换账号" forState:UIControlStateNormal];
    change.titleLabel.font = [UIFont systemFontOfSize:13];
    [change setTitleColor:[UIColor colorWithRed:66/255.0 green:99/255.0 blue:166/255.0 alpha:1] forState:UIControlStateNormal];
    [change setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [change addTarget:self action:@selector(changeUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:change];
    
    // 忘记密码
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 40)];
    
    CGFloat forgetW = 80;
    CGFloat forgetX = cover.frame.size.width - forgetW;
    UIButton *forget = [[UIButton alloc] initWithFrame:CGRectMake(forgetX, 0, forgetW, 40)];
    forget.titleLabel.font = [UIFont systemFontOfSize:13];
    [forget setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forget setTitleColor:[UIColor colorWithRed:66/255.0 green:99/255.0 blue:166/255.0 alpha:1] forState:UIControlStateNormal];
    [forget setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [forget addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [cover addSubview:forget];
    
    self.tableView.tableFooterView = cover;
}

/**
 *  跳转注册页面
 */
- (void)registerUser:(UIButton *)btn
{
    self.isModal = YES;
    
    RegisterViewController *reg = [[RegisterViewController alloc] init];
    WMNavigationController *nav = [[WMNavigationController alloc] initWithRootViewController:reg];
    [self presentViewController:nav animated:YES completion:nil];
}
//跳转证件页面
-(void)Card:(UIButton *)btn
{
   
    [self.navigationController pushViewController:[[ScanningViewController alloc] init] animated:YES];
}
// 设置头部
- (void)setupHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 205)];
    cover.backgroundColor = [UIColor clearColor];
    
    // 头像
    CGFloat iconX = (self.view.frame.size.width - 100) * 0.5;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 64, 100, 100)];
    iconView.backgroundColor = [UIColor orangeColor];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.backgroundColor = [UIColor clearColor];
    NSString *head = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginAvatar];
    [iconView sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"bigIcon"]];
    iconView.layer.cornerRadius = 50;
    iconView.layer.masksToBounds = YES;
    [cover addSubview:iconView];
    
    // 阴影
    UIImageView *shadow = [[UIImageView alloc] init];
    shadow.center = iconView.center;
    shadow.bounds = CGRectMake(0, 0, 120, 120);
    shadow.image = [UIImage imageNamed:@"yiny1"];
    [cover insertSubview:shadow atIndex:0];
    
    // 手机
    CGFloat nameY = CGRectGetMaxY(iconView.frame) + 10;
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200) * 0.5, nameY, 200, 20)];
    nameLab.textColor = [UIColor blackColor];
    nameLab.font = [UIFont systemFontOfSize:17];
    nameLab.textAlignment = NSTextAlignmentCenter;
    self.nameLab = nameLab;
    [cover addSubview:nameLab];

    self.tableView.tableHeaderView = cover;
}

#pragma mark - 登录旅行社请求
- (IBAction)loginAction:(UIButton *)sender
{
    // 取出用户密码
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [def objectForKey:UserInfoKeyPoneNum];
    
    NSDictionary *param = @{@"Mobile":mobile,
                            @"LoginPassword":self.passwordField.text};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [LoginTool regularLoginWithParam:param success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"-----  %@",json);
        
        if ([json[@"IsSuccess"] integerValue] == 1) {
            
            // 保存必要的参数
            [def setObject:json[@"BusinessID"] forKey:UserInfoKeyBusinessID];
            [def setObject:json[@"LoginType"] forKey:UserInfoKeyLoginType];
            [def setObject:json[@"DistributionID"] forKey:UserInfoKeyDistributionID];
            [def setObject:json[@"AppUserID"] forKey:UserInfoKeyAppUserID];
            [def setObject:json[@"LoginAvatar"] forKey:UserInfoKeyLoginAvatar];
            
            // 重新保存密码 因为如果注销了的话
            [def setObject:self.passwordField.text forKey:UserInfoKeyPassword];
            
            // 保存用户模型
            [UserInfo userInfoWithDict:json];
            
            // 保存分站
            if (![def objectForKey:UserInfoKeySubstation]) {
                [def setObject:[NSString stringWithFormat:@"%ld",(long)[json[@"SubstationId"] integerValue]] forKey:UserInfoKeySubstation];
            }
            [def synchronize];
            
            // 给用户打上jpush标签
            [APService setAlias:[def objectForKey:UserInfoKeyBusinessID] callbackSelector:nil object:nil];
            NSString *tag = [NSString stringWithFormat:@"substation_%ld",(long)[json[@"SubstationId"] integerValue]];
            [APService setTags:[NSSet setWithObject:tag] callbackSelector:nil object:nil];
            
            // 跳转主界面
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            [app setTabbarRoot];
        }else{
            [MBProgressHUD showError:json[@"ErrorMsg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 切换用户
- (void)changeUser:(UIButton *)btn
{
    self.isModal = YES;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
    TravelLoginController *travel = [sb instantiateViewControllerWithIdentifier:@"TravelLogin"];
    travel.isChangeUser = YES;
    WMNavigationController *nav = [[WMNavigationController alloc] initWithRootViewController:travel];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 忘记密码
- (void)forgetPassword:(UIButton *)btn
{
    self.isModal = NO;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
    BindPhoneViewController *bind = [sb instantiateViewControllerWithIdentifier:@"BindPhone"];
    bind.isForget = YES;
    [self.navigationController pushViewController:bind animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
