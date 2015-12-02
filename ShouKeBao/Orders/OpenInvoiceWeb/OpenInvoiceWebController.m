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
#import "OrderModel.h"
#import "NSString+FKTools.h"
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
    NSLog(@"%@",self.OrderIDArr);
    if (self.OrderIDArr != nil) {
        for (NSInteger i = 0; i<self.OrderIDArr.count; i++) {
           self.NewParameterStr = [self.NewParameterStr stringByAppendingString:self.OrderIDArr[i]];
            NSLog(@"%@",self.NewParameterStr);
            if (i < self.OrderIDArr.count-1) {
               self.NewParameterStr = [self.NewParameterStr stringByAppendingString:@","];
            }
        }
    }
        NSLog(@"%@,%@",self.OrderIDArr,self.NewParameterStr);
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString  *urlSuffix = [NSString stringWithFormat:@"?isfromapp=1&apptype=1&version=%@&appuid=%@&orderIds=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"],self.NewParameterStr];
    self.urlSuffix = urlSuffix;

    NSString  *urlSuffix2 = [NSString stringWithFormat:@"&isfromapp=1&apptype=1&version=%@&appuid=%@&orderIds=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"],self.NewParameterStr];
    self.urlSuffix2 = urlSuffix2;
    NSLog(@"%@----%@",urlSuffix,urlSuffix2);
    [WMAnimations WMNewWebWithScrollView:self.webView.scrollView];
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:self.ParameterArr    forKey:@"OrderIds"];
    NSLog(@"----%@",dict);
    [IWHttpTool WMpostWithURL:@"/Order/GetInvoiceComitInfo" params:dict success:^(id json) {
        if (json) {
            NSLog(@"---%@",json);
            self.NewUrlStr = [NSString stringWithFormat:@"%@%@", json[@"InvoiceComitUrl"],self.urlSuffix2];
            [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:self.NewUrlStr]]];
        }
    } failure:^(NSError *error) {
        NSLog(@"请求失败");
    }];
    
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [_indicator setLoadText:@"拼命加载中..."];
    [self.view addSubview:_indicator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopIndictor:) name:@"stopIndictor" object:nil];

    [self.view addSubview:self.webView];
    [self.OrderIDArr removeAllObjects];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rightUrl = request.URL.absoluteString;
    if (![rightUrl myContainsString:_urlSuffix2]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", rightUrl, _urlSuffix2]]]];
        return YES;
    }else{
    NSLog(@"rightStr is %@--------",rightUrl);
        [_indicator startAnimation];
    }
    
    
    return YES;
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_indicator stopAnimationWithLoadText:@"加载完成" withType:YES];
}

-(UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,kScreenSize.width, kScreenSize.height-64)];
        [self.webView scalesPageToFit];
        [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
        [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];

        _webView.delegate = self;
    }
    return _webView;
}
-(NSString *)NewUrlStr{
    if (!_NewUrlStr) {
        _NewUrlStr = [[NSString alloc] init];
    }
    return _NewUrlStr;
}
-(NSMutableArray *)ParameterArr{
    if (_ParameterArr == nil) {
        _ParameterArr = [[NSMutableArray alloc] init];
    }
    return _ParameterArr;
}
-(NSString *)NewParameterStr{
    if (!_NewParameterStr) {
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
