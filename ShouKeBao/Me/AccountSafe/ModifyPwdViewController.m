//
//  ModifyPwdViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/2.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ModifyPwdViewController.h"
#import "ResultViewController.h"
#import "MeHttpTool.h"
#import "MBProgressHUD+MJ.h"

@interface ModifyPwdViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentAcount;

@property (weak, nonatomic) IBOutlet UITextField *oldPassword;

@property (weak, nonatomic) IBOutlet UITextField *setPassword;

@property (weak, nonatomic) IBOutlet UITextField *comfirmPassword;

@end

@implementation ModifyPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账号安全设置";
    [self.oldPassword becomeFirstResponder];
    
    [self setNextBtn];
    
    //[self setNav];
    
    self.currentAcount.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapHandle:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
}

//- (void)setNav
//{
//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
//    
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

- (void)setNextBtn
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    CGFloat backX = (self.view.frame.size.width - 250) * 0.5;
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(backX, 20, 250, 45)];
    [submit setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [submit setTitle:@"下一步" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    [cover addSubview:submit];
    self.tableView.tableFooterView = cover;
}

- (void)nextStep:(UIButton *)sender
{
    NSDictionary *param = @{@"OldPassword":self.oldPassword.text,
                            @"NewPassword":self.comfirmPassword.text};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MeHttpTool setPasswordWithParam:param success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (json) {
            NSLog(@"------%@",json);
            
            if ([json[@"IsSuccess"] integerValue] == 1) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
                ResultViewController *result = [sb instantiateViewControllerWithIdentifier:@"ResultView"];
                result.isSuccess = YES;
                [self.navigationController pushViewController:result animated:YES];
            }else{
                [MBProgressHUD showError:json[@"ErrorMsg"]];
            }
        }
    } failure:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
