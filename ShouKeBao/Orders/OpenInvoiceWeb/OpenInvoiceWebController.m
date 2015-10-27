//
//  OpenInvoiceWebController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "OpenInvoiceWebController.h"
#import "YYAnimationIndicator.h"
#import "WMAnimations.h"
#import "IWHttpTool.h"
#import "Orders.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface OpenInvoiceWebController ()<UIWebViewDelegate>
@property (nonatomic,strong) YYAnimationIndicator *indicator;
@property (nonatomic, copy)NSString *urlSuffix;
@property (nonatomic, copy)NSString *urlSuffix2;

@end

@implementation OpenInvoiceWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开具发票";
    //拼接参数
    Orders *order = (Orders *)self.vvvc;
    if (order.invoiceArr != nil) {
        for (NSInteger i = 0; i<order.invoiceArr.count; i++) {
            self.ParameterStr = [self.ParameterStr stringByAppendingString:[NSString stringWithFormat:@"%@,",order.invoiceArr[i]]];
        }
    }
    NSRange range = [self.ParameterStr rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        self.NewParameterStr = [self.ParameterStr substringWithRange:NSMakeRange(0,range.location)];
    }
    self.view.backgroundColor = [UIColor whiteColor];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString  *urlSuffix = [NSString stringWithFormat:@"?isfromapp=1&apptype=1&version=%@&appuid=%@&orderIds=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"],self.NewParameterStr];
    self.urlSuffix = urlSuffix;

    NSString  *urlSuffix2 = [NSString stringWithFormat:@"&isfromapp=1&apptype=1&version=%@&appuid=%@&orderIds=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"],self.NewParameterStr];
    self.urlSuffix2 = urlSuffix2;
    
    [WMAnimations WMNewWebWithScrollView:self.webView.scrollView];
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
    
    
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [_indicator setLoadText:@"拼命加载中..."];
    [self.view addSubview:_indicator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopIndictor:) name:@"stopIndictor" object:nil];

    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:@"http://skbtest.lvyouquan.cn/mg/53af38b41b3440af83e2b4de5cfd094c/09a1a75c83b34a2e90b104a9c2167077/Product/e8287592c5484b90928de547930799f0?source=share_app&viewsource=8&isshareapp=1&apptype=1&version=1.3&appuid=32c5771375e249a898d7f3416e528822&substation=1"]]];

    [self.view addSubview:self.webView];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rightUrl = request.URL.absoluteString;
    NSLog(@"rightStr is %@--------",rightUrl);
    NSRange range = [rightUrl rangeOfString:_urlSuffix];//带？
    NSRange range2 = [rightUrl rangeOfString:_urlSuffix2];//不带?
    NSRange range3 = [rightUrl rangeOfString:@"?"];
    NSRange shareRange = [rightUrl rangeOfString:@"objectc:LYQSKBAPP_OpenShareProduct"];
    [_indicator startAnimation];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isQQReloadView"];
    
    if (range3.location == NSNotFound && range.location == NSNotFound) {//没有问号，没有问号后缀
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix]]]];
        NSLog(@"url＝ %@", [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix]]]);
        return YES;
    }else if (range3.location != NSNotFound && range2.location == NSNotFound ){//有问号没有后缀
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix2]]]];
        NSLog(@"url2＝ %@", [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix2]]]);
        return YES;
    }else{
        [_indicator startAnimation];
    }
    if (shareRange.location != NSNotFound) {
        [_indicator stopAnimationWithLoadText:@"" withType:YES];
    }
    return YES;
    
}

-(UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,kScreenSize.width, kScreenSize.height-64)];
        _webView.delegate = self;
    }
    return _webView;
}
-(NSString *)ParameterStr{
    if (_ParameterStr == nil) {
        _ParameterStr = [[NSString alloc] init];
    }
    return _ParameterStr;
}
-(NSString *)NewParameterStr{
    if (_NewParameterStr == nil) {
        _NewParameterStr = [[NSString alloc] init];
    }
    return _NewParameterStr;
}
- (void)stopIndictor:(NSNotification *)noty
{
    [self.webView reload];
    if ([_webView canGoBack] && self.indicator.isAnimating) {
        [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];
        [self.webView goBack];
    }
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
