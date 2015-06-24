//
//  SetPhonePwdViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/5/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SetPhonePwdViewController.h"
#import "ChildAccountViewController.h"
#import "UIImage+QD.h"
#import "LoginTool.h"
#import "MBProgressHUD+MJ.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "MobClick.h"
@interface SetPhonePwdViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageBg1;

@property (weak, nonatomic) IBOutlet UIImageView *imageBg2;

@property (weak, nonatomic) IBOutlet UIButton *createBtn;

// 密码输入
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

// 确认密码
@property (weak, nonatomic) IBOutlet UITextField *confirmField;


@end

@implementation SetPhonePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"创建移动安全密码";
    
    self.imageBg1.image = self.imageBg2.image = [UIImage resizedImageWithName:@"bg_white"];
    
    self.createBtn.enabled = NO;
    self.createBtn.layer.cornerRadius = 3;
    self.createBtn.layer.masksToBounds = YES;
    [self.createBtn setBackgroundImage:[UIImage imageNamed:@"red-bg"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmFieldTextChange:) name:UITextFieldTextDidChangeNotification object:self.confirmField];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LoginSetPhonePwdView"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LoginSetPhonePwdView"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private
- (void)tapHandle:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
}

// 监听输入
- (void)confirmFieldTextChange:(NSNotification *)noty
{
    UITextField *field = (UITextField *)noty.object;
    
    self.createBtn.enabled = field.text.length;
}

#pragma mark - 创建手机独立密码
- (IBAction)createAction:(UIButton *)sender
{
    if ([self.passwordField.text isEqualToString:self.confirmField.text]) {
        NSDictionary *param = @{@"Mobile":self.phoneNum,
                                @"Password":self.passwordField.text,
                                };
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LoginTool bindPhonePwdWithParam:param success:^(id json) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSLog(@"---------  %@",json);
            
            if ([json[@"IsSuccess"] integerValue] == 1) {
                
                // 保存AppUserID
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                
                // 如果设置了该密码 就把该密码作为登录密码 而不是旅行社密码
                [def setObject:self.passwordField.text forKey:UserInfoKeyPassword];
                [def synchronize];
                
                // 跳转
//                if (self.isForget) {
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }else{
//                    ChildAccountViewController *child = [[ChildAccountViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                    [self.navigationController pushViewController:child animated:YES];
//                }
                
                // 如果是安全设置修改密码
                if (self.isModefyPwd) {
                    AppDelegate *app = [UIApplication sharedApplication].delegate;
                    [app setLoginRoot];
                }else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
            }else{
                [MBProgressHUD showError:json[@"ErrorMsg"] toView:self.view];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }else{
        [MBProgressHUD showError:@"两次输入密码不一致" toView:self.view];
    }
}

/**
 *  备用接口 防止又要改回来
 */
- (void)bak
{
    NSDictionary *param = @{@"Mobile":self.phoneNum,
                            @"Password":self.passwordField.text,
                            @"PasswordConfirm":self.confirmField.text};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [LoginTool bindPhonePwdWithParam:param success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSLog(@"---------  %@",json);
        
        if ([json[@"IsSuccess"] integerValue] == 1) {
            
            // 保存AppUserID
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:json[@"AppUserID"] forKey:UserInfoKeyAppUserID];
            [def setObject:self.phoneNum forKey:UserInfoKeyPoneNum];
            [def setObject:self.passwordField.text forKey:UserInfoKeyPassword];
            [def synchronize];
            
            // 跳转
            if (self.isForget) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                ChildAccountViewController *child = [[ChildAccountViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:child animated:YES];
            }
        }else{
            [MBProgressHUD showError:json[@"ErrorMsg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"移动安全密码将作为手机登录密码";
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
