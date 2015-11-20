//
//  ProductDetailWebView.m
//  TravelConsultant
//
//  Created by 冯坤 on 15/11/19.
//  Copyright (c) 2015年 冯坤. All rights reserved.
//

#import "ProductDetailWebView.h"

@interface ProductDetailWebView ()

@end

@implementation ProductDetailWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品详情";

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)turnOff1{
    [self.navigationController popViewControllerAnimated:YES];
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
