//
//  RegisterViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "RegisterViewController.h"
#import "UINavigationController+SGProgress.h"

#define RegisterUrl @"http://www.lvyouquan.cn/MicroChannel/Reg"

@interface RegisterViewController () <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    
    [self.view addSubview:self.webView];
    [self loadWithUrl:RegisterUrl];
}

- (void)setNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
}

- (void)cancel:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
        _webView.delegate = self;
    }
    return _webView;
}

#pragma mark - loadWebView
- (void)loadWithUrl:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.webView loadRequest:request];
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
