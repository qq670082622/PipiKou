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
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "NSString+FKTools.h"
#define secret_key @"1LlYyQq2"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SuccessPayBack) name:@"SuccessPayBack" object:nil];

    NSString  *urlSuffix = [NSString stringWithFormat:@"?isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix = urlSuffix;
    
    NSString  *urlSuffix2 = [NSString stringWithFormat:@"&isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    
    self.urlSuffix2 = urlSuffix2;
    self.title = @"圈付宝";
    [self.view addSubview:self.webView];
    
    [self loadDataSource];
    
    [self.webView scalesPageToFit];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
//字符串加密;
//    NSString *encryptedData = [self encryptUseDES:@"www.lvyouquantest.cn" key:key];
//    NSLog(@"加密后的数据是:%@", encryptedData);

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
    
    //跟服务器统一一个key，用于加密解密；
    //    NSString *encryptedData = [self encryptUseDES:@"www.lvyouquantest.cn" key:key];
    //    NSLog(@"加密后的数据是:%@", encryptedData);
    //从url里面获取到js传过来的值；
    if ([rightUrl rangeOfString:@"objectc:LYQSKBAPP_WeixinPay"].location != NSNotFound) {
        //从url里面取出加密json串
        NSString * DESString = [rightUrl componentsSeparatedByString:@"?"][1];
        //将json串解密
        NSString * jsonString = [self decryptUseDES:DESString key:secret_key];
        //将解密后的json串转化成字典
        NSDictionary * jsonDic = [self dictionaryWithJsonString:jsonString];
        //用字典请求微信支付
        NSLog(@"jsonDic = %@", jsonDic);
        [self WXpaySendRequestWithDic:jsonDic];
        return NO;
    }
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
- (void)SuccessPayBack{
    for (int i = 0; i < 5; i++) {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }
    }
    [self loadWithUrl:self.linkUrl];
//    [self.webView reload];
}
- (void)WXpaySendRequestWithDic:(NSDictionary *)dic{
    //此处请求接口；
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = dic[@"partnerid"];
    request.prepayId= dic[@"prepayid"];
    request.package = dic[@"package"];
    request.nonceStr= dic[@"noncestr"];
    request.timeStamp= [dic[@"timestamp"]intValue];
    request.sign= dic[@"sign"];
    [WXApi sendReq:request];
}

/*字符串加密
 *参数
 *plainText : 加密明文
 *key        : 密钥 64位
 */
- (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    const char * textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    Byte iv[] = {1,2,3,4,5,6,7,8};
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}

//解密
- (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key
{
    NSData* cipherData = [GTMBase64 decodeString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    Byte iv[] = {1,2,3,4,5,6,7,8};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}
//根据json串得到dic
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
