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

@interface SafeSettingViewController()<UIAlertViewDelegate>

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
    
    [self setNav];
}

- (void)setNav
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - uitableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Safe" bundle:nil];
        ModifyPwdViewController *modify = [sb instantiateViewControllerWithIdentifier:@"ModifyPwd"];
        [self.navigationController pushViewController:modify animated:YES];

    }else if(indexPath.section == 2){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出登录吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
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

@end
