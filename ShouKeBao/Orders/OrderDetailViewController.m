//
//  OrderDetailViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderModel.h"

#import "MBProgressHUD+MJ.h"
#import "YYAnimationIndicator.h"
#import "BeseWebView.h"
#import "MobClick.h"
//#define urlSuffix @"?isfromapp=1&apptype=1"
@interface OrderDetailViewController()<UIWebViewDelegate>

@property (nonatomic,strong) BeseWebView *webView;
@property (nonatomic,strong) YYAnimationIndicator *indicator;
@property (nonatomic, strong)NSURLRequest * request;
@property (nonatomic, copy)NSString * telString;
@property (nonatomic,strong)NSTimer * timer;

@property (nonatomic,strong) UIButton * rightButton;
@property (nonatomic,assign) BOOL isSave;

@property(nonatomic,copy) NSString *urlSuffix;
@property(nonatomic,copy) NSString *urlSuffix2;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopIndictor) name:@"stopIndictor" object:nil];


    
    [self.view addSubview:self.webView];
    
    self.webView.delegate = self;
    
    self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    [self.webView loadRequest:self.request];
    [self setUpleftBarButtonItems];

    self.navigationItem.leftBarButtonItem.enabled = NO;
    [self.webView scalesPageToFit];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
    
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [_indicator setLoadText:@"拼命加载中..."];
    [self.view addSubview:_indicator];
   
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(findIsCall) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self setRightBtn];
    // [self Guide];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    NSString  *urlSuffix = [NSString stringWithFormat:@"?isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix = urlSuffix;
    
    NSString  *urlSuffix2 = [NSString stringWithFormat:@"&isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    
    self.urlSuffix2 = urlSuffix2;

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
#pragma mark - telCall_js
- (void)findIsCall{
    NSString * string = [self.webView stringByEvaluatingJavaScriptFromString:@"getTelForApp()"];
    if (string.length != 0){
        self.telString = string;
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要拨打电话:%@吗?", string] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //打电话；
        NSString *phonen = [NSString stringWithFormat:@"tel://%@",self.telString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonen]];
    }
}
- (void)stopIndictor{
    [self.webView reload];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"OrderDetailView"];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    [MobClick endLogPageView:@"OrderDetailView"];

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
- (void)writeVisitorsInfoWebViewGoBack{
    self.isSave = YES;
    [self.webView stringByEvaluatingJavaScriptFromString:@"saveCustomer()"];
    //    [self.webView goBack];
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
-(void)turnOff
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark getter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[BeseWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
//        _webView.scrollView.bounces = NO;
    }
    return _webView;
}





#pragma  - mark delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *rightUrl = request.URL.absoluteString;
    NSLog(@"rightStr is %@--------",rightUrl);
    NSRange range = [rightUrl rangeOfString:_urlSuffix];//带？
    NSRange range2 = [rightUrl rangeOfString:_urlSuffix2];//不带?
    NSRange range3 = [rightUrl rangeOfString:@"?"];
    
   
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isQQReloadView"];
    
    if (range3.location == NSNotFound && range.location != NSNotFound) {//没有问号，没有问号后缀
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix]]]];
        // return YES;
    }else if (range3.location != NSNotFound && range2.location == NSNotFound ){//有问号没有后缀
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix2]]]];
        // return YES;
    }else{
        
        [_indicator startAnimation];
        return YES;
        
    }

    
    
    return YES;
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isQQReloadView"];

    self.rightButton.hidden = YES;

     [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];
//    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
    BOOL isNeedBtn = [[self.webView stringByEvaluatingJavaScriptFromString:@"isShowSaveButtonForApp()"]intValue];
    if (isNeedBtn) {
        self.rightButton.hidden = NO;
    }
    if (self.isSave) {
        //        NSLog(@"%ld", self.webView.pageCount);
        [self.webView goBack];
        [self.webView goBack];
    }
    self.isSave = NO;
   // [MBProgressHUD showSuccess:@"加载完成"];
   // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.navigationItem.leftBarButtonItem.enabled = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_indicator stopAnimationWithLoadText:@"加载失败" withType:YES];
    self.navigationItem.leftBarButtonItem.enabled = YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.webView.delegate = nil;
}
@end
