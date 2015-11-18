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
#import "UserInfo.h"
#import "BindPhoneViewController.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "NewNewsController.h"
@interface SafeSettingViewController()<UIAlertViewDelegate>

/**
 *  这三个纯粹解决问题
 */
@property (weak, nonatomic) IBOutlet UIImageView *ganTan;
@property (weak, nonatomic) IBOutlet UILabel *setPwdLab;
@property (weak, nonatomic) IBOutlet UITableViewCell *setPwdCell;

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
    
    self.accountLab.text = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyPoneNum];
    
    //[self setNav];
}

//- (void)setNav
//{
//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    
//    self.navigationItem.leftBarButtonItem = leftItem;
//}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - uitableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        NSLog(@"点击第一个了");
        NewNewsController *new = [[NewNewsController alloc] init];
        [self.navigationController pushViewController:new animated:YES];

    }else if(indexPath.section == 2){
        //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Safe" bundle:nil];
        //        ModifyPwdViewController *modify = [sb instantiateViewControllerWithIdentifier:@"ModifyPwd"];
        //        [self.navigationController pushViewController:modify animated:YES];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
        BindPhoneViewController *bind = [sb instantiateViewControllerWithIdentifier:@"BindPhone"];
        bind.isForget = YES;
        bind.isModefyPwd = YES;
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"MeChangeAccountPassWord" attributes:dict];
        
        [self.navigationController pushViewController:bind animated:YES];
    }else if(indexPath.section == 3){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出登录吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (self.isPerson && section == 1) {
//        return 0.01f;
//    }
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.isPerson && indexPath.section == 1) {
//        self.ganTan.hidden = YES;
//        self.setPwdLab.hidden = YES;
//        self.setPwdCell.accessoryType = UITableViewCellAccessoryNone;
//        return 0;
//    }
    return 55;
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
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"MeExitAccount" attributes:dict];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:@"2" forKey:@"isLogoutYet"];

        [def removeObjectForKey:UserInfoKeyPassword];
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app setLoginRoot];
    }
}

@end
