//
//  SafeSettingViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/1.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SafeSettingViewController.h"
#import "ReBindViewController.h"
#import "ModifyPwdViewController.h"
#import "AppDelegate.h"

@interface SafeSettingViewController()

@property (weak, nonatomic) IBOutlet UILabel *accountLab;// 显示当前账号

@property (weak, nonatomic) IBOutlet UIImageView *pwdStatus; // 密码状态图标

@property (weak, nonatomic) IBOutlet UILabel *pwdLevel; // 密码安全等级描述

//@property (weak, nonatomic) IBOutlet UIImageView *phoneStatus; // 手机是否绑定状态图标
//
//@property (weak, nonatomic) IBOutlet UILabel *bindPhone; // 当前绑定的手机
@end

@implementation SafeSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"账号安全设置";
}

// 修改密码
- (IBAction)modifyPwd:(UIButton *)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Safe" bundle:nil];
    ModifyPwdViewController *modify = [sb instantiateViewControllerWithIdentifier:@"ModifyPwd"];
    [self.navigationController pushViewController:modify animated:YES];
}

#pragma mark - uitableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def removeObjectForKey:@"account"];
        [def removeObjectForKey:@"password"];
        [def removeObjectForKey:@"phonenumber"];
        [def removeObjectForKey:@"LoginType"];
        [def removeObjectForKey:@"BusinessID"];
        [def removeObjectForKey:@"DistributionID"];
        [def removeObjectForKey:@"ChooseID"];
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app setBindRoot];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

// 修改绑定的手机
//- (IBAction)modifyBindPhone:(id)sender
//{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Safe" bundle:nil];
//    ReBindViewController *reBind = [sb instantiateViewControllerWithIdentifier:@"ReBind"];
//    [self.navigationController pushViewController:reBind animated:YES];
//}

@end
