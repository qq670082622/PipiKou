//
//  ProductListWebView.m
//  TravelConsultant
//
//  Created by 冯坤 on 15/11/19.
//  Copyright (c) 2015年 冯坤. All rights reserved.
//

#import "ProductListWebView.h"

@interface ProductListWebView ()

@end

@implementation ProductListWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品列表";
    
    // Do any additional setup after loading the view.
}
- (void)turnOff1{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
