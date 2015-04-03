//
//  PersonSettingViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "PersonSettingViewController.h"
#import "MeHttpTool.h"

@interface PersonSettingViewController ()


@end

@implementation PersonSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(submit)];
    
    [self loadDataSource];
}

#pragma mark - loadDataSource
- (void)loadDataSource
{
    [MeHttpTool getDistributionWithsuccess:^(id json) {
        if (json) {
            NSLog(@"-----%@",json);
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - private
- (void)submit
{
//    NSDictionary *param = @{};
//    [MeHttpTool setDistributionWithParam:param success:^(id json) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
}

@end
