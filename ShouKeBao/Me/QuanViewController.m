//
//  QuanViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "QuanViewController.h"
#import "MeHttpTool.h"
#import "UINavigationController+SGProgress.h"

@interface QuanViewController () <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,assign) int webLoadCount;
@property (nonatomic,strong) NSMutableArray *webUrlArr;
@property (nonatomic,copy) NSString *linkUrl;
@end

@implementation QuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"圈付宝";
    [self setNav];
    
    [self.view addSubview:self.webView];
    
    [self loadDataSource];
    
    [self.webView scalesPageToFit];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    

}

// 先一个个页面设置吧 以后再搞一起的
- (void)setNav
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
}

#pragma -mark private
-(void)back
{
    if (self.webUrlArr.count >2) {
        
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[self.webUrlArr objectAtIndex:self.webUrlArr.count - 2]]]];
        [self.webUrlArr removeLastObject];
    }
    
    else if (self.webUrlArr.count == 2) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    NSLog(@"返回后arr.count is %lu",(unsigned long)self.webUrlArr.count);
    
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

-(NSMutableArray *)webUrlArr
{
    if (_webUrlArr == nil) {
        self.webUrlArr = [NSMutableArray array];
    }
    return _webUrlArr;
}

-(NSString *)linkUrl
{
    if (_linkUrl == nil) {
        self.linkUrl = [NSString string];
    }
    return _linkUrl;
}

#pragma mark - loadDataSource
- (void)loadDataSource
{
    [MeHttpTool getMeIndexWithParam:@{} success:^(id json) {
        if (json) {
            NSLog(@"-----%@",json);
            [self loadWithUrl:json[@"QFBLinkUrl"]];
            self.linkUrl = json[@"QFBLinkUrl"];
            [self.webUrlArr addObject:_linkUrl];
            self.webLoadCount = 1;
        }
    }failure:^(NSError *error){
        
    }];
}

#pragma  - mark delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rightStr = request.URL.absoluteString;
    
    if ((![rightStr isEqualToString:[_webUrlArr lastObject]]) && (rightStr.length>8) && (![rightStr isEqualToString:_linkUrl])) {
        
        [self.webUrlArr addObject:rightStr];
    }
    
    
    return YES;
    
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
