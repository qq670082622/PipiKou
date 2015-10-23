//
//  TravelConsultantViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/9/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "TravelConsultantViewController.h"

@interface TravelConsultantViewController ()
@property (strong, nonatomic) IBOutlet UILabel *bindingNum;//绑定数
@property (strong, nonatomic) IBOutlet UILabel *shareNum;//分享数
@property (strong, nonatomic) IBOutlet UILabel *reserveNum;//预订数

@end

@implementation TravelConsultantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"旅游顾问";
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
