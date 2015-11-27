//
//  OrderDetailViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ButtonDetailViewController.h"

#import "MBProgressHUD+MJ.h"
#import "BeseWebView.h"
#import "MobClick.h"
#import "QRCodeViewController.h"
#import "ScanningViewController.h"
#import "BaseClickAttribute.h"
#import "userIDTableviewController.h"  
#import "CardTableViewController.h"
#import "JSONKit.h"
#import "NSString+FKTools.h"
#import "UpDateUserPictureViewController.h"
#import "ChatViewController.h"
@interface ButtonDetailViewController()<UIWebViewDelegate, DelegateToOrder, DelegateToOrder2>

@property (nonatomic,strong) BeseWebView *webView;
@property (nonatomic,assign) int webLoadCount;
@property (nonatomic,strong) NSMutableArray *webUrlArr;
@property (nonatomic,strong) UIButton * rightButton;
@property (nonatomic,assign) BOOL isSave;

@property(nonatomic,copy) NSString *urlSuffix;
@property(nonatomic,copy) NSString *urlSuffix2;

@end

@implementation ButtonDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.linkUrl]];
    NSLog(@"linkUrl = %@", self.linkUrl);
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
    [self setRightBtn];
    
    
    [self.webView scalesPageToFit];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    NSString  *urlSuffix = [NSString stringWithFormat:@"?isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix = urlSuffix;
    
    NSString  *urlSuffix2 = [NSString stringWithFormat:@"&isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    
    self.urlSuffix2 = urlSuffix2;
    [self setUpleftBarButtonItems];
    
   }
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"OrdersButtonDetailView"];
    if (self.userInfoDic) {
        NSLog(@"%@", self.userInfoDic);
    }

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OrdersButtonDetailView"];
}

-(void)setUpleftBarButtonItems
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,15)];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateHighlighted];
    
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(-1, -10, 0, 50);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    
//    UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
//    turnOff.titleLabel.font = [UIFont systemFontOfSize:14];
//    turnOff.frame = CGRectMake(0, 0, 30, 10);
//    [turnOff addTarget:self action:@selector(turnOff) forControlEvents:UIControlEventTouchUpInside];
//    [turnOff setTitle:@"关闭"  forState:UIControlStateNormal];
//    [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    UIBarButtonItem *turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];
    
    //[self.navigationItem setLeftBarButtonItems:@[backItem,turnOffItem] animated:YES];
    self.navigationItem.leftBarButtonItem = backItem;
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

#pragma -mark private
- (void)writeVisitorsInfoWebViewGoBack{
    self.isSave = YES;
    [self.webView stringByEvaluatingJavaScriptFromString:@"saveCustomer()"];
//    [self.webView goBack];
}
-(void)back
{
    NSString *isFade = [self.webView stringByEvaluatingJavaScriptFromString:@"goBackForApp()"];
    NSLog(@"$$$$$$$$$$$!!!!!!!!!%@", isFade);
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
    //[self.navigationController popViewControllerAnimated:YES];
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
    NSLog(@"rightStr is %@--------",rightUrl);
    NSRange range = [rightUrl rangeOfString:_urlSuffix];//带？
    NSRange range2 = [rightUrl rangeOfString:_urlSuffix2];//不带?
    NSRange range3 = [rightUrl rangeOfString:@"?"];
    

        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isQQReloadView"];
    
    if (range3.location == NSNotFound && range.location == NSNotFound) {//没有问号，没有问号后缀
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix]]]];
        NSLog(@"没有问号，没有问号后缀");
         return YES;
    }else if (range3.location != NSNotFound && range2.location == NSNotFound ){//有问号没有后缀
        NSLog(@"有问号没有后缀");

        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix2]]]];
         return YES;
    }else{
//        MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//        
//        hudView.labelText = @"拼命加载中...";
//        
//        [hudView show:YES];

//        return YES;
    }
    
    if ([rightUrl myContainsString:@"objectc:LYQSKBAPP_OpenCardScanning"]) {
        [self codeAction];
        //        return NO;
    }else if([rightUrl myContainsString:@"objectc:LYQSKBAPP_UpDateUserPhotos"]){
        NSLog(@"aaaaa");
        [self LYQSKBAPP_UpDateUserPhotos:rightUrl];
    }else if ([rightUrl myContainsString:@"objectc:LYQSKBAPP_OpenCustomIM"]){
        [self LYQSKBAPP_OpenCustomIM:rightUrl];
    }

//    NSLog(@"----------right url is %@ ----------",rightUrl);
    
    return YES;
}

//js调用原生，调用IM入口；
- (void)LYQSKBAPP_OpenCustomIM:(NSString *)urlStr{
    NSString * pattern = @"OpenCustomIM(.+)";
    NSRegularExpression * regex = [[NSRegularExpression alloc]initWithPattern:pattern options:0 error:nil];
    //测试字符串；
    NSArray * result = [regex matchesInString:urlStr options:0 range:NSMakeRange(0,urlStr.length)];
    if (result.count) {
        //获取筛选出来的字符串
        NSString * resultStr = [urlStr substringWithRange:((NSTextCheckingResult *)result[0]).range];
        NSMutableString * params = [NSMutableString stringWithString:resultStr];
        [params stringByReplacingOccurrencesOfString:@"OpenCustomIM(" withString:@""];
        [params stringByReplacingOccurrencesOfString:@")" withString:@""];
        ChatViewController * chatVC = [[ChatViewController alloc]initWithChatter:params conversationType:eConversationTypeChat];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    
}


//js调原生，并且用js传过来的customerIDs 跳转到上传证件附件页面
-(void)LYQSKBAPP_UpDateUserPhotos:(NSString *)urlStr{
    NSLog(@"%@", urlStr);
    urlStr = [urlStr componentsSeparatedByString:@"?"][0];
    //创建正则表达式；pattern规则；
    NSString * pattern = @"Photos(.+)";
    NSRegularExpression * regex = [[NSRegularExpression alloc]initWithPattern:pattern options:0 error:nil];
    //测试字符串；
    NSArray * result = [regex matchesInString:urlStr options:0 range:NSMakeRange(0,urlStr.length)];
    if (result.count) {
        //获取筛选出来的字符串
        NSString * resultStr = [urlStr substringWithRange:((NSTextCheckingResult *)result[0]).range];
        NSArray * picArray = [resultStr componentsSeparatedByString:@","];
        NSMutableArray * customerIDsArray = [NSMutableArray array];
        for (NSString * str in picArray) {
            NSString * tempStr = @"";
            if ([str myContainsString:@"Photos("]) {
                tempStr = [str stringByReplacingOccurrencesOfString:@"Photos(" withString:@""];
            }else{
                tempStr = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
            }
            if (![tempStr isEqualToString:@""]) {
                [customerIDsArray addObject:tempStr];
            }
        }
        UIStoryboard * SB = [UIStoryboard storyboardWithName:@"Orders" bundle:nil];
        UpDateUserPictureViewController * UDUPVC = [SB instantiateViewControllerWithIdentifier:@"UpDateUserPictureVC"];
        UDUPVC.customerIds = customerIDsArray;
        UDUPVC.VC = self;
//        [_indicator stopAnimationWithLoadText:@"" withType:YES];
        
        [self.navigationController pushViewController:UDUPVC animated:YES];
    }
    
    
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
    }
    self.isSave = NO;
    //[MBProgressHUD showSuccess:@"加载完成"];
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
  
}
-(void)codeAction
{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"QRcodeClickInMainView" attributes:dict];
    
    ScanningViewController *scan = [[ScanningViewController alloc] init];
    scan.isLogin = YES;
    scan.VC = self;
    scan.isFromOrder = YES;
    [self.navigationController pushViewController:scan animated:YES];
    
    //    QRCodeViewController *qrc = [[QRCodeViewController alloc] init];
    //    [self.navigationController pushViewController:qrc animated:YES];
    
}
- (void)giveJSCardScanningCallBackJson:(NSDictionary*)dic{
    //    NSDictionary * dic = @{@"Name":@"tom",@"Sex":@"1(男)/0(女)",@"CardType":@"0(身份证)/1(护照)",@"出生日期":@"1900-01-01"};
    NSString * jsonStr = [dic JSONString];
    NSLog(@"%@", jsonStr);
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"LYQSKBAPP_OpenCardScanning_CallBack(%@, '%@')", @1, jsonStr]];
   
}


-(void)writeDelegate:(NSDictionary *)dic{
    [self giveJSCardScanningCallBackJson:dic];
}


//提交选择的客户图片；
- (void)postCustomerToServer:(NSArray * )customerIDs{
    NSDictionary * dic = @{@"CustomerList":customerIDs};
    NSString * jsonStr = [dic JSONString];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"LYQSKBAPP_GetCustomerSelectPicFromApp_CallBack(%@, '%@')", @1, jsonStr]];
    
    
}

@end
