//
//  MoreLvYouGuWenInfoViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MoreLvYouGuWenInfoViewController.h"
#import "MeHttpTool.h"
#import "BeseWebView.h"
#import "UserInfo.h"
@interface MoreLvYouGuWenInfoViewController ()<UIWebViewDelegate>


@end

@implementation MoreLvYouGuWenInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setRightBarButton];
    [self loadDataSource];
    self.webView.delegate = self;
    //self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setRightBarButton{
    UIButton * historyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    [historyBtn setTitle:@"纪录" forState:UIControlStateNormal];
    [historyBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [historyBtn addTarget:self action:@selector(historyClick) forControlEvents:UIControlEventTouchUpInside];
    historyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc]initWithCustomView:historyBtn];
    self.navigationItem.rightBarButtonItem = barButton;
}
- (void)historyClick{
    [self.webView stringByEvaluatingJavaScriptFromString:@"ShowHistoryInWebview()"];
}
#pragma mark - loadDataSource
- (void)loadDataSource
{
        [self loadWithUrl:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLYGWLinkUrl]];
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
