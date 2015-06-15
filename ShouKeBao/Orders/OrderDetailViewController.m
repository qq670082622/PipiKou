//
//  OrderDetailViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderModel.h"
#import "Lotuseed.h"
#import "MBProgressHUD+MJ.h"
#import "YYAnimationIndicator.h"
#import "BeseWebView.h"
#define urlSuffix @"?isfromapp=1&apptype=1"
@interface OrderDetailViewController()<UIWebViewDelegate>

@property (nonatomic,strong) BeseWebView *webView;
@property (nonatomic,strong) YYAnimationIndicator *indicator;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
   

    
    [self.view addSubview:self.webView];
    
    self.webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    [self.webView loadRequest:request];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    [self.webView scalesPageToFit];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
    
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [_indicator setLoadText:@"拼命加载中..."];
    [self.view addSubview:_indicator];
   
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Lotuseed onPageViewBegin:@"orderDetail"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Lotuseed onPageViewEnd:@"orderDetail"];
}

#pragma -mark private
-(void)back
{
    NSString *isFade = [self.webView stringByEvaluatingJavaScriptFromString:@"goBackForApp();"];
    if (isFade.length && [isFade integerValue] == 0){
        // 这个地方上面的js方法自动处理
    }else{
        if ([self.webView canGoBack]){
            [self.webView goBack];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
}

#pragma -mark getter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[BeseWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
    }
    return _webView;
}





#pragma  - mark delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rightUrl = request.URL.absoluteString;
    NSRange range = [rightUrl rangeOfString:urlSuffix];
    if (range.location == NSNotFound) {
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:urlSuffix]]]];
    }else{
         [_indicator startAnimation];
//        MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//        
//        hudView.labelText = @"拼命加载中...";
//        
//        [hudView show:YES];
        return YES;
    }
    NSLog(@"----------right url is %@ ----------",rightUrl);
    
    return YES;
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
     [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];
//    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
    
    
   // [MBProgressHUD showSuccess:@"加载完成"];
   // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.navigationItem.leftBarButtonItem.enabled = YES;
}
@end
