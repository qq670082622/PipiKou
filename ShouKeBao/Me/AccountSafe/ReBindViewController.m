//
//  ReBindViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/2.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ReBindViewController.h"
#import "ResultViewController.h"
#import "UserInfo.h"
#import "LoginTool.h"
@interface ReBindViewController ()

@property (weak, nonatomic) IBOutlet UITextField *setPhone;


@end

@implementation ReBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账号安全设置";
    
    [self setNextBtn];
    
   // [self setNav];
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

// 设置按钮
- (void)setNextBtn
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    CGFloat backX = (self.view.frame.size.width - 250) * 0.5;
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(backX, 20, 250, 45)];
    [submit setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [submit setTitle:@"下一步" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    [cover addSubview:submit];
    self.tableView.tableFooterView = cover;
}

// 下一步
- (void)next:(UIButton *)btn
{
    

}

// 获取验证码
- (IBAction)getValidateCode:(UIButton *)sender
{
    NSDictionary *param = @{@"Mobile" :self.setPhone.text};
    
    [LoginTool getCodeWithParam:param success:^(id json) {
        NSLog(@"---%@",json);
    } failure:^(NSError *error) {
        
    }];
}

// 头部文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[UserInfo shareUser].loginType integerValue] == 1) {
        return @"当前未绑定手机\n绑定手机后,下次登录可以使用新手机号码登录";
    }else{
        return @"当前绑定手机为18767155187\n更改手机后,下次登录可以使用新手机号码登录";
    }
}

@end
