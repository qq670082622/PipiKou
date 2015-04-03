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

@interface BindPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;// 手机号

@property (weak, nonatomic) IBOutlet UITextField *code;// 验证码

@property (weak, nonatomic) IBOutlet UITextField *passWord;// 密码

@property (weak, nonatomic) IBOutlet UITextField *confirm;// 确认密码

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    
    UIView *gap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    self.tableView.tableHeaderView = gap;
    // Do any additional setup after loading the view.
    
    [UserInfo shareUser].DistributionID = self.distributionId;
}

#pragma mark - private
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
    if ([self.passWord.text isEqualToString:self.confirm.text]) {
        
        NSDictionary *param = @{@"Mobile":self.phoneNum.text,
                                @"VerficationCode":self.code.text,
                                @"Password":self.passWord.text};
        [LoginTool bindPhoneWithParam:param success:^(id json) {
            
            NSLog(@"-----%@",json);
            if ([json[@"IsSuccess"] integerValue] == 1) {
                [UserInfo shareUser].DistributionID = json[@"DistributionID"];
                // 保存账号密码
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                [def setObject:self.phoneNum.text forKey:@"phonenumber"];
                [def setObject:self.passWord.text forKey:@"password"];
                [def synchronize];
                
                AppDelegate *app = [UIApplication sharedApplication].delegate;
                [app setTabbarRoot];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}


@end
