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
#import "MobClick.h"
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
    [MobClick beginLogPageView:@"Login"];
    
    self.nameLab.text = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyPoneNum];
    
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Login"];

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
    //********
    CGFloat newW = 25;
    CGFloat newH = 25;
    CGFloat newX = 50;
    CGFloat newY = screenRect.size.height - newH - 35 ;
//    CGFloat newW = 25;
//    CGFloat newH = 25;
//    CGFloat newX = screenRect.size.width/2 - 12.5;
//    CGFloat newY = screenRect.size.height - newH - 35 ;
    UIButton *new = [[UIButton alloc] initWithFrame:CGRectMake(newX, newY, newW, newH)];
    [new addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    
    [new setBackgroundColor:[UIColor clearColor]];
    [new setBackgroundImage:[UIImage imageNamed:@"newUserImage"] forState:UIControlStateNormal];
    new.contentMode = UIViewContentModeScaleAspectFill;
    
    CGFloat newBtnCenterX = new.center.x;
    UILabel *labNew = [[UILabel alloc] initWithFrame:CGRectMake(newBtnCenterX-20, CGRectGetMaxY(new.frame), 40, 20)];
    labNew.text = @"新用户";
    labNew.font = [UIFont systemFontOfSize:11];
    labNew.textColor = [UIColor grayColor];
    labNew.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labNew];
    [self.view addSubview:new];
    
    //分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(screenRect.size.width/2, newY, 0.5, 35)];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    //******
//    line.hidden = YES;
    //证照神器
    CGFloat cardX = self.view.frame.size.width - 50 - newW - 5;
    UIButton *card = [[UIButton alloc] initWithFrame:CGRectMake(cardX, newY - 18 , newW + 5, newH + 18)];
    [card addTarget:self action:@selector(Card:) forControlEvents:UIControlEventTouchUpInside];
    [card setBackgroundColor:[UIColor clearColor]];
    [card setBackgroundImage:[UIImage imageNamed:@"cardDigital"] forState:UIControlStateNormal];
    card.contentMode = UIViewContentModeScaleAspectFill;
    
    CGFloat cardCenterX = card.center.x;
    UILabel *labCard = [[UILabel alloc] initWithFrame:CGRectMake(cardCenterX-25, CGRectGetMaxY(card.frame), 50, 20)];
    labCard.text = @"证照神器";
    labCard.font = [UIFont systemFontOfSize:11];
    labCard.textColor = [UIColor blueColor];
    labCard.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labCard];
    
    [self.view addSubview:card];
    //********
//    labCard.hidden = YES;
//    card.hidden = YES;
    
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
    ScanningViewController *scan = [[ScanningViewController alloc] init];
    scan.isLogin = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:scan animated:YES];
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
        
        if ([json[@"IsSuccess"] integerValue] == 1 ) {
             
            // 保存必要的参数
            [def setObject:json[@"BusinessID"] forKey:UserInfoKeyBusinessID];
            [def setObject:json[@"LoginType"] forKey:UserInfoKeyLoginType];
            [def setObject:json[@"DistributionID"] forKey:UserInfoKeyDistributionID];
            [def setObject:json[@"AppUserID"] forKey:UserInfoKeyAppUserID];
            [def setObject:json[@"LoginAvatar"] forKey:UserInfoKeyLoginAvatar];

            NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
            [accountDefaults setObject:[NSString stringWithFormat:@"%@", json[@"SubstationId"]] forKey:UserInfoKeySubstation];
            [accountDefaults setObject:json[@"SubstationName"] forKey:@"SubstationName"];
            [accountDefaults setObject:@"yes" forKey:@"stationSelect"];//改变分站时通知Findproduct刷新列表
            [accountDefaults setObject:@"yes" forKey:@"stationSelect2"];//改变分站时通知首页刷新列表
            [accountDefaults synchronize];

            
            
//            if ([UserInfo isOnlineUserWithBusinessID:@"1"]) {
//                [MobClick startWithAppkey:@"55895cfa67e58eb615000ad8" reportPolicy:BATCH   channelId:@"Web"];
//                NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//                [MobClick setAppVersion:version];
//            }

            
            
            
            // 重新保存密码 因为如果注销了的话
            [def setObject:self.passwordField.text forKey:UserInfoKeyPassword];
            [def setObject:@"1" forKey:@"isLogoutYet"];

            // 保存用户模型
            [UserInfo userInfoWithDict:json];
            
            // 保存分站
            if (![def objectForKey:UserInfoKeySubstation]) {
                [def setObject:[NSString stringWithFormat:@"%ld",(long)[json[@"SubstationId"] integerValue]] forKey:UserInfoKeySubstation];
            }
            [def synchronize];
            
                       
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
