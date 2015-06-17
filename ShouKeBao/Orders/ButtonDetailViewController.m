//
//  OrderDetailViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ButtonDetailViewController.h"
#import "Lotuseed.h"
#import "MBProgressHUD+MJ.h"
#import "BeseWebView.h"
#define urlSuffix @"?isfromapp=1&apptype=1"
@interface ButtonDetailViewController()<UIWebViewDelegate>

@property (nonatomic,strong) BeseWebView *webView;
@property (nonatomic,assign) int webLoadCount;
@property (nonatomic,strong) NSMutableArray *webUrlArr;
@property (nonatomic,strong) UIButton * rightButton;
@property (nonatomic,assign) BOOL isSave;
@end

@implementation ButtonDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.linkUrl]];
    
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
    [self setRightBtn];
    
    
    [self.webView scalesPageToFit];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    
   }

- (void)setRightBtn{
    self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,20)];
    [self.rightButton setTitle:@"确定" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightButton addTarget:self action:@selector(writeVisitorsInfoWebViewGoBack) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.highlighted = YES;
//    rightBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.rightButton.hidden = YES;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Lotuseed onPageViewBegin:@"orderOperation"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Lotuseed onPageViewEnd:@"orderOperation"];
}

#pragma -mark private
- (void)writeVisitorsInfoWebViewGoBack{
    self.isSave = YES;
    [self.webView stringByEvaluatingJavaScriptFromString:@"saveCustomer()"];
//    [self.webView goBack];
}
-(void)back
{
    NSString *isFade = [self.webView stringByEvaluatingJavaScriptFromString:@"goBackForApp()"];
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
        _webView = [[BeseWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
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
        MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        hudView.labelText = @"拼命加载中...";
        
        [hudView show:YES];

        return YES;
    }
//    NSLog(@"----------right url is %@ ----------",rightUrl);
    
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.rightButton.hidden = YES;
    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
    //获取界面的
//    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
//    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    BOOL isNeedBtn = [[self.webView stringByEvaluatingJavaScriptFromString:@"isShowSaveButtonForApp()"]intValue];
    if (isNeedBtn) {
        self.rightButton.hidden = NO;
    }
    if (self.isSave) {
//        NSLog(@"%ld", self.webView.pageCount);
        [self.webView goBack];
        [self.webView goBack];
//        [self.webView goBackPageNum:1];
    }
    self.isSave = NO;
    //[MBProgressHUD showSuccess:@"加载完成"];
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
  
}

@end
