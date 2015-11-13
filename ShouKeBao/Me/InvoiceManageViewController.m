//
//  InvoiceManageViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/28.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "InvoiceManageViewController.h"
#import "MeHttpTool.h"
#import "BeseWebView.h"

@interface InvoiceManageViewController ()<UIWebViewDelegate>

@end

@implementation InvoiceManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataSource];
    self.webView.delegate = self;
    //self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - loadDataSource
- (void)loadDataSource
{
    [MeHttpTool getMeIndexWithParam:@{} success:^(id json) {
        if (json) {
            NSLog(@"-----**%@",json);
            [self loadWithUrl:json[@"InvoiceListUrl"]];
        }
    }failure:^(NSError *error){
        
    }];

}
#pragma mark - loadWebView
- (void)loadWithUrl:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:NO];
    }else{
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = leftItem;
        
    }
    [super webViewDidFinishLoad:webView];
    
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
