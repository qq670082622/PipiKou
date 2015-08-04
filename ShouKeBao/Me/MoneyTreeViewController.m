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
@interface MoneyTreeViewController ()<UIWebViewDelegate>

@end

@implementation MoneyTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataSource];
    self.webView.delegate  = self;
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
//    NSLog(@"%@", webView.request.URL.absoluteString);
//     NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('lyqwebview_title').value"];
//    if (![title isEqualToString:@""]) {
//        for (NSString * str in [title componentsSeparatedByString:@"摇钱树"]) {
//            if (![str isEqualToString:@""]) {
//                self.title = str;
//            }
//        }
//    }else{
//    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    }
//    
//    NSLog(@"%@", title);
}


@end
