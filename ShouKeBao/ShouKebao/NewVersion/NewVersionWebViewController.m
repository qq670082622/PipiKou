//
//  NewVersionWebViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/7/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NewVersionWebViewController.h"
#import "BeseWebView.h"
@interface NewVersionWebViewController ()<UIWebViewDelegate >

@end

@implementation NewVersionWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.webView scalesPageToFit];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    self.title = @"更新软件";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.LinkUrl]];
    [self.webView loadRequest:request];
//    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    if (self.block != nil) {
        self.block(YES);
    }

    
    
    // Do any additional setup after loading the view.
}
- (void)isFromBlock:(ResturnBlock)returnBlock{
    self.block = returnBlock;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[BeseWebView alloc] init];
        _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
        _webView.delegate = self;
    }
    return _webView;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@", request.URL.absoluteString);
//    [[[UIAlertView alloc]initWithTitle:@"url" message:request.URL.absoluteString delegate:nil cancelButtonTitle:@"✅" otherButtonTitles:nil, nil]show];
    return YES;
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
