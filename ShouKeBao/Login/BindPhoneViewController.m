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
#import "StepView.h"
#import "RegisterViewController.h"
#import "WMNavigationController.h"

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
    self.title = @"绑定手机";
    self.imageBg1.image = self.imageBg2.image = [UIImage resizedImageWithName:@"bg_white"];
    self.nextBtn.layer.cornerRadius = 3;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.enabled = NO;
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"red-bg"] forState:UIControlStateNormal];
    
    // 设置头部图标
    [self setupHeader];
    
    [self setFoot];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beijing"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
 *  添加新用户按钮
 */
- (void)setFoot
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    CGFloat newW = 80;
    CGFloat newH = 30;
    CGFloat newX = (self.view.frame.size.width - newW) * 0.5;
    CGFloat newY = screenRect.size.height - newH - 30;
    UIButton *new = [[UIButton alloc] initWithFrame:CGRectMake(newX, newY, newW, newH)];
    new.layer.cornerRadius = 15;
    new.layer.masksToBounds = YES;
    [new addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    [new setTitle:@"新用户" forState:UIControlStateNormal];
    new.titleLabel.font = [UIFont systemFontOfSize:13];
    [new setBackgroundColor:[UIColor whiteColor]];
    [new setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:new];
}

/**
 *  跳转注册页面
 */
- (void)registerUser:(UIButton *)btn
{
    RegisterViewController *reg = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:reg animated:YES];
}

/**
 *  获取验证码
 */
- (IBAction)getCode:(id)sender
{
    if (self.phoneNum.text.length) {
        
        NSDictionary *param = @{@"Mobile" :self.phoneNum.text,
                                @"Type":@"3"};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LoginTool getCodeWithParam:param success:^(id json) {
            NSLog(@"---%@",json);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if ([json[@"IsSuccess"] integerValue] == 1) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD showSuccess:@"短信发送成功"];
                });
            
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *param = @{@"Mobile":self.phoneNum.text,
                            @"Captche":self.code.text,
                            @"Type":@"3"};
    [LoginTool checkCodeWithParam:param success:^(id json) {
        NSLog(@"---%@",json);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([json[@"IsSuccess"] integerValue] == 1) {
            
            // 去选择旅行社
            ChildAccountViewController *child = [[ChildAccountViewController alloc] init];
            
            child.mobile = self.phoneNum.text;
            [self.navigationController pushViewController:child animated:YES];
            
        }else{
            [MBProgressHUD showError:json[@"ErrorMsg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

/*
    触碰退出编辑
*/
- (void)tapHandle:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
}

#pragma mark - tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    
    StepView *stepView = [[StepView alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 20)];
    [stepView setStepAtIndex:0];
    [cover addSubview:stepView];
    
    return cover;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
