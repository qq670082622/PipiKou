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

#import "BeseWebView.h"
#import "MobClick.h"
#import "WXApiObject.h"
#import "WXApi.h"
@interface QuanViewController () <UIWebViewDelegate>

@property (nonatomic,strong) BeseWebView *webView;
@property (nonatomic,assign) int webLoadCount;
@property (nonatomic,strong) NSMutableArray *webUrlArr;
@property (nonatomic,copy) NSString *linkUrl;
@property(nonatomic,copy) NSString *urlSuffix;
@property(nonatomic,copy) NSString *urlSuffix2;
@end

@implementation QuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    NSString  *urlSuffix = [NSString stringWithFormat:@"?isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix = urlSuffix;
    
    NSString  *urlSuffix2 = [NSString stringWithFormat:@"&isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    
    self.urlSuffix2 = urlSuffix2;
    [self WXpaySendRequest];
    self.title = @"圈付宝";
    [self.view addSubview:self.webView];
    
    [self loadDataSource];
    
    [self.webView scalesPageToFit];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    
//    NSString *oldAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//    NSLog(@"old agent :%@", oldAgent);
//    
//    //add my info to the new agent
//    NSString *newAgent = [oldAgent stringByAppendingString:@"(appskb_v10_ios)"];
//    NSLog(@"new agent :%@", newAgent);
//    
//    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
//    
//    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
   // [self setUpleftBarButtonItems];

}

//-(void)setUpleftBarButtonItems
//{
//  
//    UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
//    turnOff.titleLabel.font = [UIFont systemFontOfSize:16];
//    turnOff.frame = CGRectMake(0, 0, 30, 10);
//    [turnOff addTarget:self action:@selector(turnOff) forControlEvents:UIControlEventTouchUpInside];
//    [turnOff setTitle:@"关闭"  forState:UIControlStateNormal];
//     turnOff.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
//    [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    UIBarButtonItem *turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];
//    
//    [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:YES];
//
//    
//}
//
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MeQuanViewController"];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MeQuanViewController"];

}
// 先一个个页面设置吧 以后再搞一起的


#pragma -mark private
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
            NSLog(@"%@++++++", self.webUrlArr);
            self.webLoadCount = 1;
        }
    }failure:^(NSError *error){
        
    }];
}

#pragma  - mark delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rightUrl = request.URL.absoluteString;
    NSLog(@"rightStr is %@--------",rightUrl);
//    NSRange range = [rightUrl rangeOfString:_urlSuffix];//带？
//    NSRange range2 = [rightUrl rangeOfString:_urlSuffix2];//不带?
//    NSRange range3 = [rightUrl rangeOfString:@"?"];
    
   
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isQQReloadView"];
//    if ([rightUrl containsString:@"alipay"]) {
//        
//    }else{
//    if (range3.location == NSNotFound && range.location != NSNotFound) {//没有问号，没有问号后缀
//        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix]]]];
//        NSLog(@"%@", [rightUrl stringByAppendingString:_urlSuffix]);
//         return YES;
//    }else if (range3.location != NSNotFound && range2.location == NSNotFound ){//有问号没有后缀
//        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix2]]]];
//        NSLog(@"%@", [rightUrl stringByAppendingString:_urlSuffix]);
//
//         return YES;
//    }else{
//        
//        return YES;
//        }
//    }
    return YES;
}


#pragma mark - loadWebView
- (void)loadWithUrl:(NSString *)url
{
//    url = @"http://www.myie9.com/useragent/";
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
    if ([self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:NO];
    }else{
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = leftItem;
        
    }

    [self.navigationController cancelSGProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.navigationController cancelSGProgress];
}
- (void)WXpaySendRequest{
    //此处请求接口；
    
    PayReq *request = [[PayReq alloc] init];
    
    request.partnerId = @"10000100";
    
    request.prepayId= @"1101000000140415649af9fc314aa427";
    
    request.package = @"Sign=WXPay";
    
    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
    NSLog(@"woshi%f",   [[NSDate dateWithTimeIntervalSinceNow:0]timeIntervalSince1970]);
    request.timeStamp= @"1397527777";
    
    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
    
    [WXApi sendReq:request];


}
@end
