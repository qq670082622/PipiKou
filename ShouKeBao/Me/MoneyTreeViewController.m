//
//  MoneyTreeViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/7/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MoneyTreeViewController.h"
#import "MeHttpTool.h"
#import "BeseWebView.h"
@interface MoneyTreeViewController ()

@end

@implementation MoneyTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataSource];
    
}
#pragma mark - loadDataSource
- (void)loadDataSource
{
    [MeHttpTool getMeIndexWithParam:@{} success:^(id json) {
        if (json) {
            NSLog(@"-----%@",json);
            [self loadWithUrl:json[@"MoneyTreeUrl"]];
            self.linkUrl = json[@"MoneyTreeUrl"];
        }
    }failure:^(NSError *error){
        
    }];
}
#pragma mark - loadWebView
- (void)loadWithUrl:(NSString *)url
{
    //    url = @"http://www.myie9.com/useragent/";
//    url = @"http://m.lvyouquan.cn/MoneyTree";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}


@end
