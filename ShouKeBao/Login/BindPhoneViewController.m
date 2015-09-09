//
//  BindPhoneViewController.m
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "WriteFileManager.h"
#import "LoginTool.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "ChildAccountViewController.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "Business.h"
#import "UIImage+QD.h"
#import "RegisterViewController.h"
#import "WMNavigationController.h"
#import "SetPhonePwdViewController.h"
#import "MobClick.h"
@interface BindPhoneViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageBg1;

@property (weak, nonatomic) IBOutlet UIImageView *imageBg2;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;// 手机号

@property (weak, nonatomic) IBOutlet UITextField *code;// 验证码

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;// 下一步按钮

@property (nonatomic,copy) NSString *getCode;

@property (nonatomic,strong) NSMutableArray *businessList;// 旅行社列表


@property (nonatomic,assign) NSInteger count;
@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定安全手机";
    self.imageBg1.image = self.imageBg2.image = [UIImage resizedImageWithName:@"bg_white"];
    self.nextBtn.layer.cornerRadius = 3;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.enabled = NO;
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"red-bg"] forState:UIControlStateNormal];
    
    // 设置头部图标
//    [self setupHeader];
//    self.phoneNum.text = @"11064808256";
    
    // 如果忘记密码的话就把 
    if (self.isForget) {
        self.phoneNum.text = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyPoneNum];
        self.phoneNum.enabled = NO;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self.view addGestureRecognizer:tap];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LoginBindPhoneView"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LoginBindPhoneView"];
}

#pragma mark - getter
- (NSMutableArray *)businessList
{
    if (!_businessList) {
        _businessList = [NSMutableArray array];
    }
    return _businessList;
}

#pragma mark - private
/**
 *  设置头部图标
 */
- (void)setupHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    cover.backgroundColor = [UIColor clearColor];
    
    CGFloat iconX = (self.view.frame.size.width - 120) * 0.5;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 25, 120, 120)];
    iconView.backgroundColor = [UIColor clearColor];
    iconView.image = [UIImage imageNamed:@"bigIcon"];
    [cover addSubview:iconView];
    
    self.tableView.tableHeaderView = cover;
}

/**
 *  获取验证码
 */
- (IBAction)getCode:(id)sender
{
//    移动光标
    [self.codeBtn resignFirstResponder];
    [self.code becomeFirstResponder];

    if (self.phoneNum.text.length) {
        
        NSDictionary *param = @{@"Mobile" :self.phoneNum.text,
                                @"Type":@"3"};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LoginTool getCodeWithParam:param success:^(id json) {
            NSLog(@"---%@",json);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if ([json[@"IsSuccess"] integerValue] == 1) {
                
                
                [MBProgressHUD showSuccess:@"短信发送成功"];
        
                self.count = 60;
                self.codeBtn.enabled = NO;
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                
                self.nextBtn.enabled = YES;
            }else{
                [MBProgressHUD showError:json[@"ErrorMsg"]];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}

// 倒计时
- (void)countDown:(NSTimer *)timer
{
    if (self.count > 0) {
        self.count --;
        self.codeBtn.titleLabel.text = [NSString stringWithFormat:@"重新发送(%ld)",(long)self.count];
        [self.codeBtn setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)self.count] forState:UIControlStateNormal];
//        [self.codeBtn resignFirstResponder];
//        [self.code becomeFirstResponder];
        
        
    }else{
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [timer invalidate];
    }
}

/**
 *  下一步
 */
- (IBAction)bindAccount:(id)sender
{
    [self goNext];
}

- (void)goNext
{
    if (self.isForget) {
        
        // 设置密码的流程
        [self setPhonePwdRequest];
    }else{
        
        // 绑定手机的流程
        [self bindPhoneRequest];
    }
}

/*
    触碰退出编辑
*/
- (void)tapHandle:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
}

#pragma mark - request
/**
 *  忘记密码要设置的时候用这个请求
 */
- (void)setPhonePwdRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *param = @{@"Mobile":self.phoneNum.text,
                            @"Captche":self.code.text,
                            @"Type":@"3"};
    [LoginTool checkCodeWithParam:param success:^(id json) {
        NSLog(@"---%@",json);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([json[@"IsSuccess"] integerValue] == 1 || ([self.phoneNum.text isEqualToString:@"15838378342"]&&[self.code.text isEqualToString:@"910621"])) {
            // 保存AppUserID
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            //苹果商城绿色通道
            if ([self.phoneNum.text isEqualToString:@"15838378342"]) {
                [def setObject:@"bdc45124fa474c7889414b55449e573e" forKey:UserInfoKeyAppUserID];
                [def setObject:self.phoneNum.text forKey:UserInfoKeyPoneNum];
            }else{
                [def setObject:json[@"AppUserID"] forKey:UserInfoKeyAppUserID];
                [def setObject:self.phoneNum.text forKey:UserInfoKeyPoneNum];
            }
            [def synchronize];
            
            // 去更改手机独立密码
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
            SetPhonePwdViewController *phonePwd = [sb instantiateViewControllerWithIdentifier:@"phonePwd"];
            phonePwd.isForget = self.isForget;
            phonePwd.isModefyPwd = self.isModefyPwd;
            phonePwd.phoneNum = self.phoneNum.text;
            [self.navigationController pushViewController:phonePwd animated:YES];
            
        }else{
            [MBProgressHUD showError:json[@"ErrorMsg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

/**
 *  第一次绑定手机的请求
 */
- (void)bindPhoneRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *param = @{@"Mobile":self.phoneNum.text,
                            @"Captche":self.code.text,
                            @"Type":@"3"};
    [LoginTool bindMobileAndCreateUserWithParam:param success:^(id json) {
        NSLog(@"---%@",json);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([json[@"IsSuccess"] integerValue] == 1 || ([self.phoneNum.text isEqualToString:@"15838378342"]&&[self.code.text isEqualToString:@"910621"])) {
            
            // 保存AppUserID
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            //苹果商城绿色通道
            if ([self.phoneNum.text isEqualToString:@"15838378342"]) {
                [def setObject:@"bdc45124fa474c7889414b55449e573e" forKey:UserInfoKeyAppUserID];
                [def setObject:self.phoneNum.text forKey:UserInfoKeyPoneNum];
            }else{
            [def setObject:json[@"AppUserID"] forKey:UserInfoKeyAppUserID];
            [def setObject:self.phoneNum.text forKey:UserInfoKeyPoneNum];
            }
            [def synchronize];
            
            // 跳转到选择分销人
            ChildAccountViewController *child = [[ChildAccountViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:child animated:YES];
            
        }else{
            [MBProgressHUD showError:json[@"ErrorMsg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"安全手机将作为您的手机登录账号";
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
