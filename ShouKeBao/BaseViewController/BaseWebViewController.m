//
//  BaseWebViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/7/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BaseWebViewController.h"
#import "BeseWebView.h"
#import "UINavigationController+SGProgress.h"
#import "MeHttpTool.h"
@interface BaseWebViewController ()<UIWebViewDelegate>

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpleftBarButtonItems];
    self.title = self.webTitle;
    [self.view addSubview:self.webView];
    [self.webView scalesPageToFit];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.linkUrl]];
    [self.webView loadRequest:request];

    
    
}

#pragma mark - getter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[BeseWebView alloc] init];
        _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
        _webView.delegate = self;
    }
    return _webView;
}
-(void)setUpleftBarButtonItems
{
    
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(0, 0, 45, 10);
    [back setTitle:@"〈返回" forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:14];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    turnOff.titleLabel.font = [UIFont systemFontOfSize:14];
    turnOff.frame = CGRectMake(0, 0, 30, 30);
    [turnOff addTarget:self action:@selector(turnOff) forControlEvents:UIControlEventTouchUpInside];
    [turnOff setTitle:@"关闭"  forState:UIControlStateNormal];
    [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];
    
    [self.navigationItem setLeftBarButtonItems:@[backItem,turnOffItem] animated:YES];
    
    
}

-(void)back
{
    
    if ([_webView canGoBack]) {
        
        [self.webView goBack];
    }
    else  {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)turnOff
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  - mark delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rightUrl = request.URL.absoluteString;
    NSLog(@"rightStr is %@--------",rightUrl);
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isQQReloadView"];
    return YES;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.navigationController showSGProgressWithDuration:5 andTintColor:[UIColor colorWithRed:80/255.0 green:218/255.0 blue:85/255.0 alpha:1] andTitle:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.navigationController cancelSGProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.navigationController cancelSGProgress];
}

@end
