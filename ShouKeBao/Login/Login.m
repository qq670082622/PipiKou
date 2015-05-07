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

@interface Login () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UITextField *accountField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic,weak) UIButton *nameBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imagebg1;

@property (weak, nonatomic) IBOutlet UIImageView *imagebg2;

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
    
//    self.accountField.text = @"gaowei@pipikou.com";
//    self.passwordField.text = @"123456";
//    self.accountField.text = @"lxstest";
//    self.passwordField.text = @"A148A148";
    
    [self setWithName:[UserInfo shareUser].userName];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    
    [backBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - private
- (void)viewConfig
{
    // 背景
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"beijing"];
    self.tableView.backgroundView = bg;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 登录按钮样式
    self.imagebg1.image = self.imagebg2.image = [UIImage resizedImageWithName:@"bg_white"];
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.layer.masksToBounds = YES;
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"red-bg"] forState:UIControlStateNormal];
    
    // 退出编辑
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tanHandle:)];
    [self.view addGestureRecognizer:tap];
    
    
    if (self.autoLoginFailed) {// 如果自动登录失败
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        self.businessId = [def objectForKey:@"DistributionID"];
        self.distributeId = [def objectForKey:@"BusinessID"];
        self.chooseId = [def objectForKey:@"ChooseID"];
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

// 设置头部
- (void)setupHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 205)];
    cover.backgroundColor = [UIColor clearColor];
    
    CGFloat iconX = (self.view.frame.size.width - 100) * 0.5;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 64, 100, 100)];
    iconView.backgroundColor = [UIColor orangeColor];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.backgroundColor = [UIColor clearColor];
    [iconView sd_setImageWithURL:[NSURL URLWithString:[UserInfo shareUser].LoginAvatar] placeholderImage:nil];
    iconView.layer.cornerRadius = 50;
    iconView.layer.masksToBounds = YES;
    [cover addSubview:iconView];
    
    UIImageView *shadow = [[UIImageView alloc] init];
    shadow.center = iconView.center;
    shadow.bounds = CGRectMake(0, 0, 120, 120);
    shadow.image = [UIImage imageNamed:@"yiny1"];
    [cover insertSubview:shadow atIndex:0];
    
    CGFloat nameY = CGRectGetMaxY(iconView.frame) + 10;
    UIButton *nameBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150) * 0.5, nameY, 100, 20)];
    [nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nameBtn setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.3]];
    nameBtn.layer.cornerRadius = 5;
    nameBtn.layer.masksToBounds = YES;
    nameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cover addSubview:nameBtn];
    nameBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    self.nameBtn = nameBtn;

    self.tableView.tableHeaderView = cover;
}

// 设置用户名称
- (void)setWithName:(NSString *)name
{
    [self.nameBtn setTitle:name forState:UIControlStateNormal];
    [self.nameBtn sizeToFit];
    CGRect rect = self.nameBtn.frame;
    rect.origin.x = (self.view.frame.size.width - rect.size.width) * 0.5;
    self.nameBtn.frame = rect;
}



/**
 *  登录
 */
- (IBAction)loginAction:(UIButton *)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *param = @{@"LoginName":self.accountField.text,
                            @"LoginPassword":self.passwordField.text,
                            @"ChooseBusinessID":self.chooseId,
                            @"BusinessID":self.businessId,
                            @"DistributionID":self.distributeId};
    
    [LoginTool loginWithParam:param success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"----%@",json);
        
        if ([json[@"IsSuccess"] integerValue] == 1) {
            
            // 保存账号密码
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:self.accountField.text forKey:@"account"];
            [def setObject:self.passwordField.text forKey:@"password"];
            
            // 储存手机号 证明已经绑定过手机
            [def setObject:self.mobile forKey:@"phonenumber"];
            
            // 保存必要参数
            [def setObject:json[@"LoginType"] forKey:@"LoginType"];
            [def setObject:self.businessId forKey:@"BusinessID"];
            [def setObject:self.distributeId forKey:@"DistributionID"];
            [def setObject:self.chooseId forKey:@"ChooseID"];
            
            // 保存分站
            [def setObject:[NSString stringWithFormat:@"%ld",(long)[json[@"SubstationId"] integerValue]] forKey:@"Substation"];
            
            [def synchronize];
            
            // 给用户打上jpush标签
            [APService setAlias:self.businessId callbackSelector:nil object:nil];
            
            //[APService setTags:[NSSet setWithObject:self.businessId] alias:nil callbackSelector:nil object:nil];
            
            // 跳转主界面
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            [app setTabbarRoot];
            
        }else{
            if (![json[@"ErrorMsg"] isKindOfClass:[NSNull class]]) {
                [MBProgressHUD showError:json[@"ErrorMsg"]];
            }else{
                [MBProgressHUD showError:@"网络连接错误"];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


#pragma mark - uitableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, self.view.frame.size.width - 50, 20)];
    title.text = @"输入旅行社账号密码";
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = [UIColor whiteColor];
    [cover addSubview:title];
    
    return cover;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
