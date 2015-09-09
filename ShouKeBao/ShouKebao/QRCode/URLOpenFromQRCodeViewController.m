//
//  URLOpenFromQRCodeViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "URLOpenFromQRCodeViewController.h"
#import "YYAnimationIndicator.h"
#import "WMAnimations.h"
#import "MobClick.h"
#import "NSString+FKTools.h"
@interface URLOpenFromQRCodeViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) YYAnimationIndicator *indicator;
@property (weak, nonatomic) IBOutlet UIWebView *web;
@property (nonatomic, copy)NSString *urlSuffix;
@property (nonatomic, copy)NSString *urlSuffix2;

@end

@implementation URLOpenFromQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.titleStr) {
        self.title = @"二维码网页";
    }else{
        self.title = self.titleStr;
        }
    [WMAnimations WMNewWebWithScrollView:self.web.scrollView];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:self.url]];
    [self.web loadRequest:request];
    [self setNav];
   
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
    
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [_indicator setLoadText:@"拼命加载中..."];
    [self.view addSubview:_indicator];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 30)];
    lab.text = _url;
    [self.view.window addSubview:lab];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    NSString  *urlSuffix = [NSString stringWithFormat:@"?isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix = urlSuffix;
    
    NSString  *urlSuffix2 = [NSString stringWithFormat:@"&isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix2 = urlSuffix2;

    
    
}
- (void)setNav{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,15)];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateHighlighted];
    
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(-1, -10, 0, 50);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
   UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
//    UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
//    turnOff.titleLabel.font = [UIFont systemFontOfSize:16];
//    turnOff.frame = CGRectMake(0, 0, 30, 10);
//    [turnOff addTarget:self action:@selector(turnOff1) forControlEvents:UIControlEventTouchUpInside];
//    [turnOff setTitle:@"关闭"  forState:UIControlStateNormal];
//    turnOff.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
//    [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//   UIBarButtonItem * turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];
    self.navigationItem.leftBarButtonItems = @[leftItem];
}
-(void)turnOff1
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShouKeBaoURLOpenFromQRCodeView"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaoURLOpenFromQRCodeView"];
}

-(void)back
{
    [self.delegate refresh];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"request..... = %@", request);
    NSString *rightUrl = request.URL.absoluteString;
    NSLog(@"rightStr is %@--------",rightUrl);
    NSRange range = [rightUrl rangeOfString:_urlSuffix];//带？
    NSRange range2 = [rightUrl rangeOfString:_urlSuffix2];//不带?
    NSRange range3 = [rightUrl rangeOfString:@"?"];
//    [[[UIAlertView alloc]initWithTitle:@"URL" message:rightUrl delegate:nil cancelButtonTitle:self.title otherButtonTitles:@"que", nil]show];
    [_indicator startAnimation];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isQQReloadView"];
    
    if (range3.location == NSNotFound && range.location == NSNotFound) {//没有问号，没有问号后缀
        [self.web loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix]]]];
        //        [self doIfInWebWithUrl:rightUrl];
        return YES;
    }else if (range3.location != NSNotFound && range2.location == NSNotFound ){//有问号没有后缀
        [self.web loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix2]]]];
        //        [self doIfInWebWithUrl:rightUrl];
        
        return YES;
    }else{
        //        [self doIfInWebWithUrl:rightUrl];
        [_indicator startAnimation];
    }
    
    if ([rightUrl myContainsString:@"objectc:LYQSKBAPP_LoginBackHomeView"]) {
        [self LoginBackHomeView];
    }
    return YES;
}
- (void)LoginBackHomeView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
 [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
