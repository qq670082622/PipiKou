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
#import "BaseClickAttribute.h"
#import "ScanningViewController.h"
#import "QRCodeViewController.h"
#import <WebKit/WebKit.h>
#import "JSONKit.h"
#import "userIDTableviewController.h"
#import "CardTableViewController.h"
//#define urlSuffix @"?isfromapp=1&apptype=1"
@interface OrderDetailViewController()<UIWebViewDelegate, DelegateToOrder, DelegateToOrder2>

@property (nonatomic,strong) BeseWebView *webView;
@property (nonatomic,strong) YYAnimationIndicator *indicator;
@property (nonatomic, strong)NSURLRequest * request;
@property (nonatomic, copy)NSString * telString;
@property (nonatomic,strong)NSTimer * timer;

@property (nonatomic,strong) UIButton * rightButton;
@property (nonatomic,assign) BOOL isSave;

@property(nonatomic,copy) NSString *urlSuffix;
@property(nonatomic,copy) NSString *urlSuffix2;
@property(nonatomic,assign)BOOL isBack;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopIndictor) name:@"stopIndictor" object:nil];


    [self.view addSubview:self.webView];
    
    self.webView.delegate = self;
//    加载url
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
//    将方法添加到nsrunloop中
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self setRightBtn];
    
    // [self Guide];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSLog(@"jjj %@", infoDictionary);
    
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
    turnOff.frame = CGRectMake(0, 0, 30, 10);
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
    NSLog(@"$$$$www  %@", [self.webView stringByEvaluatingJavaScriptFromString:@"saveCustomer()"]);
    
    
    //    [self.webView goBack];
}

#pragma -mark private
-(void)back
{
    self.isBack = YES;
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
//    显示详情界面的url
    NSString *rightUrl = request.URL.absoluteString;
    NSLog(@"rightStr is %@--------",rightUrl);

    NSRange range = [rightUrl rangeOfString:_urlSuffix];//带？
    NSRange range2 = [rightUrl rangeOfString:_urlSuffix2];//不带?
    NSRange range3 = [rightUrl rangeOfString:@"?"];

        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isQQReloadView"];
    
    if (range3.location == NSNotFound && range.location == NSNotFound) {//没有问号，没有问号后缀
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix]]]];
         return YES;
    }else if (range3.location != NSNotFound && range2.location == NSNotFound ){//有问号没有后缀
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix2]]]];
         return YES;
    }else{
        
        [_indicator startAnimation];
        
    }
    
    if ([rightUrl containsString:@"objectc:LYQSKBAPP_OpenCardScanning"]) {
        [self LYQSKBAPP_OpenCardScanning];
//        return NO;
    }

    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"MeCancelMyStore" attributes:dict];

    
    return YES;
    
}
- (void)doIfInWebWithUrl:(NSString *)rightUrl{
    if ([rightUrl containsString:@"Product/ProductDetail"]) {
        self.title = @"产品详情";
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"OrderDetailProductDetailClick" attributes:dict];
    }else if([rightUrl containsString:@"Order/SKBOrderCancel"]){
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"OrderDetailOrderCancelClick" attributes:dict];
        self.title = @"订单详情";
    }else{
    self.title = @"订单详情";
    }
    if ([rightUrl containsString:@"/Order/Detail/"]) {
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"OrderDetailClick" attributes:dict];
    }
    if (self.isBack) {
        
        
        if ([rightUrl containsString:@"/ProductDetailExt/"]) {//订单价格
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"FromOrderDetailProductPrice" attributes:dict];
        }else if([rightUrl containsString:@"/Order/Create?"]){//填写联系人
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"FromOrderDetailProductWritecontacts" attributes:dict];
            
        }else if([rightUrl containsString:@"/Order/CreateSuccess/"]){//提交成功
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"FromOrderDetailProductOrderSuccess" attributes:dict];
            [MobClick event:@"OrderAll" attributes:dict];
            
        }
    }

}
-(void)webViewDidFinishLoad:(UIWebView *)webView

{
    [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];
    NSString *rightUrl = webView.request.URL.absoluteString;
    [self doIfInWebWithUrl:rightUrl];

    self.isBack = NO;
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

//js调取原生app的方法
-(void)LYQSKBAPP_OpenCardScanning
{

    ScanningViewController *scan = [[ScanningViewController alloc] init];
    scan.isFromOrder = YES;
    scan.isLogin = YES;
    scan.VC = self;
    [self.navigationController pushViewController:scan animated:YES];
//    [self giveJSCardScanningCallBackJson];
    
}
//app调取js方法并向js传json参数
- (void)giveJSCardScanningCallBackJson:(NSDictionary*)dic{
//    NSDictionary * dic = @{@"Name":@"tom",@"Sex":@"1(男)/0(女)",@"CardType":@"0(身份证)/1(护照)",@"出生日期":@"1900-01-01"};
    NSString * jsonStr = [dic JSONString];
    NSLog(@"%@", jsonStr);
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"LYQSKBAPP_OpenCardScanning_CallBack(%@, '%@')", @1, jsonStr]];
}

//- (void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame
//
//{
//    
//    [windowObject setValue:self forKey:@"controller"];
//    
//}
-(void)writeDelegate:(NSDictionary *)dic{
    [self giveJSCardScanningCallBackJson:dic];
}
@end
