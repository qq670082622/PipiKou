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

@interface BindPhoneViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;// 手机号

@property (weak, nonatomic) IBOutlet UITextField *code;// 验证码

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;// 下一步按钮

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    self.nextBtn.layer.cornerRadius = 25;
    self.nextBtn.layer.masksToBounds = YES;
    
    // 设置头部图标
    [self setupHeader];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beijing"]];
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

#pragma mark - private
/**
 *  设置头部图标
 */
- (void)setupHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 190)];
    cover.backgroundColor = [UIColor clearColor];
    
    CGFloat iconX = (self.view.frame.size.width - 150) * 0.5;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 0, 170, 170)];
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
    NSDictionary *param = @{@"Mobile" :self.phoneNum.text};
    
    [LoginTool getCodeWithParam:param success:^(id json) {
        NSLog(@"---%@",json);
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  绑定账号
 */
- (IBAction)bindAccount:(id)sender
{
        
//        NSDictionary *param = @{@"Mobile":self.phoneNum.text,
//                                @"VerficationCode":self.code.text};
//        [LoginTool bindPhoneWithParam:param success:^(id json) {
//            
//            NSLog(@"-----%@",json);
//            if ([json[@"IsSuccess"] integerValue] == 1) {
//                [UserInfo shareUser].DistributionID = json[@"DistributionID"];
//                // 保存账号密码
//                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//                [def setObject:self.phoneNum.text forKey:@"phonenumber"];
//                [def synchronize];
//                
//                AppDelegate *app = [UIApplication sharedApplication].delegate;
//                [app setTabbarRoot];
//            }
//        } failure:^(NSError *error) {
//            
//        }];
    ChildAccountViewController *child = [[ChildAccountViewController alloc] init];
    [self.navigationController pushViewController:child animated:YES];
}

#pragma mark - tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 20)];
    title.text = @"输入手机号码绑定您的个人收客宝账号";
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = [UIColor blackColor];
    [cover addSubview:title];
    
    return cover;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
