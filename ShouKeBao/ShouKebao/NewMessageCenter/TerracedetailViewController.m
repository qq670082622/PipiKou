//
//  TerracedetailViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "TerracedetailViewController.h"
#import "BeseWebView.h"
#import "IWHttpTool.h"
@interface TerracedetailViewController ()<UIWebViewDelegate>

@end

@implementation TerracedetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataSource];
    self.title = @"消息详情";
    self.webView.delegate = self;
}
#pragma mark - loadDataSource
- (void)loadDataSource
{
    [self loadWithUrl:self.linkUrl];
}
#pragma mark - loadWebView
- (void)loadWithUrl:(NSString *)url
{
    //        url = @"http://www.myie9.com/useragent/";
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
@end
