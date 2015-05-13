//
//  TravelLoginController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/5/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "TravelLoginController.h"
#import "BindPhoneViewController.h"
#import "UIImage+QD.h"
#import "ChildAccountViewController.h"
#import "LoginTool.h"
#import "MBProgressHUD+MJ.h"
#import "UserInfo.h"

@interface TravelLoginController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageBg1;

@property (weak, nonatomic) IBOutlet UIImageView *imageBg2;

@property (weak, nonatomic) IBOutlet UITextField *accountField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation TravelLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录旅游圈平台";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.enabled = NO;
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"red-bg"] forState:UIControlStateNormal];
    
    self.imageBg1.image = self.imageBg2.image = [UIImage resizedImageWithName:@"bg_white"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self.view addGestureRecognizer:tap];
    
    // 如果是切换用户进来的 就设置个取消
    if (self.isChangeUser) {
        [self setNavCancel];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountFieldTextChange:) name:UITextFieldTextDidChangeNotification object:self.accountField];
    
    self.accountField.text = @"huangfuyuhan@pipikou.com";
    self.passwordField.text = @"123456";
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private
// 监听输入
- (void)accountFieldTextChange:(NSNotification *)noty
{
    UITextField *field = (UITextField *)noty.object;
    
    self.loginBtn.enabled = field.text.length;
}

// 登录旅行社账号
- (IBAction)loginAction:(UIButton *)sender
{
    NSDictionary *param = @{@"LoginName":self.accountField.text,
                            @"LoginPassword":self.passwordField.text};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // 请求登录
    [LoginTool travelLoginWithParam:param success:^(id json) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"-----  %@",json);
        
        if ([json[@"IsSuccess"] integerValue] == 1) {
            
            // 保存businessid
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:json[@"BusinessID"] forKey:UserInfoKeyBusinessID];
            [def setObject:self.accountField.text forKey:UserInfoKeyAccount];
            [def setObject:self.passwordField.text forKey:UserInfoKeyPassword];
            [def synchronize];
            
            if (self.isChangeUser) {
                
                ChildAccountViewController *child = [[ChildAccountViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:child animated:YES];
            }else{
                
                // 成功后 继续绑定手机
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
                BindPhoneViewController *bind = [sb instantiateViewControllerWithIdentifier:@"BindPhone"];
                bind.isForget = NO;
                [self.navigationController pushViewController:bind animated:YES];
            }
        }else{
            [MBProgressHUD showError:json[@"ErrorMsg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

// 退出编辑
- (void)tapHandle:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
}

// 设置取消按钮
- (void)setNavCancel
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
}

// 取消
- (void)cancel:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
