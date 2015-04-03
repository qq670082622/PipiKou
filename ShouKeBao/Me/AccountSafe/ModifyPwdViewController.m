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

@interface ModifyPwdViewController ()

@end

@implementation ModifyPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNextBtn];
}

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

- (void)next:(UIButton *)sender
{
    NSDictionary *param = @{};
    [MeHttpTool setPasswordWithParam:param success:^(id json) {
        if (json) {
            NSLog(@"------%@",json);
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
