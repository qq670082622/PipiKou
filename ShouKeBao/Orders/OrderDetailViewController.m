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
@interface OrderDetailViewController()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,assign) int webLoadCount;
@property (nonatomic,strong) NSMutableArray *webUrlArr;
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
//    if (self.webUrlArr.count >1) {
//        
//        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[self.webUrlArr objectAtIndex:self.webUrlArr.count - 2]]]];
//        [self.webUrlArr removeLastObject];
//    }
//    
//    else if (self.webUrlArr.count == 1) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    
//    NSLog(@"返回后arr.count is %lu",(unsigned long)self.webUrlArr.count);
    if ([self.webView canGoBack]){
        [self.webView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma -mark getter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
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




#pragma  - mark delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSString *rightStr = request.URL.absoluteString;
//    
//    if (![rightStr isEqualToString:[_webUrlArr lastObject]]) {
//        
//        [self.webUrlArr addObject:rightStr];
//    }
//    NSLog(@"\narr count is %lu  \n arr is %@\n",self.webUrlArr.count,_webUrlArr);
    
    return YES;
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *rightStr = webView.request.URL.absoluteString;
    
    if (![rightStr isEqualToString:[_webUrlArr lastObject]]) {
        
        [self.webUrlArr addObject:rightStr];
    }
    NSLog(@"\narr count is %lu  \n arr is %@\n",self.webUrlArr.count,_webUrlArr);
    self.navigationItem.leftBarButtonItem.enabled = YES;
}
@end
