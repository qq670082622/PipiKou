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
#import <ShareSDK/ShareSDK.h>
#import "StrToDic.h"
#import "IWHttpTool.h"
#import "NSString+FKTools.h"
#import "UpDateUserPictureViewController.h"
#import "ChatViewController.h"
//#define urlSuffix @"?isfromapp=1&apptype=1"
@interface OrderDetailViewController()<UIWebViewDelegate, DelegateToOrder, DelegateToOrder2>

@property (nonatomic,strong) BeseWebView *webView;
@property (nonatomic,strong) YYAnimationIndicator *indicator;
@property (nonatomic, strong)NSURLRequest * request;
@property (nonatomic, copy)NSString * telString;
@property (nonatomic,strong)NSTimer * timer;

@property (nonatomic,strong) UIBarButtonItem * rightButtonItem;
@property (nonatomic,assign) BOOL isSave;

@property(nonatomic,copy) NSString *urlSuffix;
@property(nonatomic,copy) NSString *urlSuffix2;
@property (nonatomic, strong)UIBarButtonItem * shareBtnItem;
@property (nonatomic, strong)NSMutableDictionary *shareInfo;
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
    [self initRightBtn];
    [self setUpleftBarButtonItems];
    //self.navigationItem.leftBarButtonItem.enabled = NO;
    [self.webView scalesPageToFit];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
    
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [self.view addSubview:_indicator];
   
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(findIsCall) userInfo:nil repeats:YES];
    self.timer = timer;
    self.isBack = NO;
//    将方法添加到nsrunloop中
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // [self Guide];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSLog(@"jjj %@", infoDictionary);
    
    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    NSString  *urlSuffix = [NSString stringWithFormat:@"?isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix = urlSuffix;
    
    NSString  *urlSuffix2 = [NSString stringWithFormat:@"&isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    
    self.urlSuffix2 = urlSuffix2;

   }
-(NSMutableDictionary *)shareInfo
{
    if ( _shareInfo == nil ) {
        self.shareInfo = [NSMutableDictionary dictionary];
    }
    return _shareInfo;
}

-(void)setUpleftBarButtonItems
{
//    UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
//    turnOff.titleLabel.font = [UIFont systemFontOfSize:16];
//    turnOff.frame = CGRectMake(0, 0, 30, 10);
//    [turnOff addTarget:self action:@selector(turnOff) forControlEvents:UIControlEventTouchUpInside];
//    [turnOff setTitle:@"关闭"  forState:UIControlStateNormal];
//      turnOff.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
//    [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    UIBarButtonItem *turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];
    
    self.navigationItem.leftBarButtonItem = leftItem;
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
- (void)initRightBtn{
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,20)];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(writeVisitorsInfoWebViewGoBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.rightButtonItem = rightItem;
    //分享
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [button setImage:[UIImage imageNamed:@"APPfenxiang"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareLink:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.shareBtnItem = shareBarItem;
}
- (void)setRightBtnwithtype:(NSInteger)type{
    if (type==1) {
        self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    }else if(type == 2){
    self.navigationItem.rightBarButtonItem= self.shareBtnItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)writeVisitorsInfoWebViewGoBack{
    self.isSave = YES;
    [self.webView stringByEvaluatingJavaScriptFromString:@"saveCustomer()"];
    
    
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
    [_indicator setLoadText:@"拼命加载中..."];

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
    NSLog(@"%@", rightUrl);
    if ([rightUrl myContainsString:@"objectc:LYQSKBAPP_OpenCardScanning"]) {
        [self LYQSKBAPP_OpenCardScanning];
//        return NO;
    }else if([rightUrl myContainsString:@"objectc:LYQSKBAPP_UpDateUserPhotos"]){
        NSLog(@"aaaaa");
        [self LYQSKBAPP_UpDateUserPhotos:rightUrl];
    }else if ([rightUrl myContainsString:@"objectc:LYQSKBAPP_OpenCustomIM"]){
        [self LYQSKBAPP_OpenCustomIM:rightUrl];
    }


    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"MeCancelMyStore" attributes:dict];

    
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
        NSString * params = [NSString string];
        params = [resultStr stringByReplacingOccurrencesOfString:@"OpenCustomIM(" withString:@""];
        NSArray *strArray = [params componentsSeparatedByString:@")"];
        //       params = [params stringByReplacingOccurrencesOfString:@")" withString:@""];
        params = strArray[0];
        NSLog(@"%@--%@---%@",urlStr,resultStr, params);
        NSDictionary * dic = [NSString parseJSONStringToNSDictionary:params];

        /*
         {
         "MsgType": "OrderDetail",
         "ReceiveId": "接收人Id",
         "ObjectId": "订单Id"
         }
         */
        ChatViewController * chatVC = [[ChatViewController alloc]initWithChatter:dic[@"ReceiveId"] conversationType:eConversationTypeChat];
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
        [_indicator stopAnimationWithLoadText:@"" withType:YES];

        [self.navigationController pushViewController:UDUPVC animated:YES];
    }
    
    
}
- (void)doIfInWebWithUrl:(NSString *)rightUrl{
    if ([rightUrl myContainsString:@"Product/ProductDetail"]) {
        self.title = @"产品详情";
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"OrderDetailProductDetailClick" attributes:dict];
    }else if([rightUrl myContainsString:@"Order/SKBOrderCancel"]){
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"OrderDetailOrderCancelClick" attributes:dict];
        self.title = @"订单详情";
    }else{
    self.title = @"订单详情";
    }
    
    
    if ([rightUrl myContainsString:@"/Order/Detail/"]) {
        BaseClickAttribute *dict =
        [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"OrderDetailClick" attributes:dict];
    }
    if (self.isBack) {
        if ([self.webView canGoBack]) {
            [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:NO];
        }else{
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = leftItem;
        }

        if ([rightUrl myContainsString:@"/ProductDetailExt/"]) {//订单价格
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"FromOrderDetailProductPrice" attributes:dict];
        }else if([rightUrl myContainsString:@"/Order/Create?"]){//填写联系人
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"FromOrderDetailProductWritecontacts" attributes:dict];
            
        }else if([rightUrl myContainsString:@"/Order/CreateSuccess/"]){//提交成功
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"FromOrderDetailProductOrderSuccess" attributes:dict];
            [MobClick event:@"OrderAll" attributes:dict];
            [MobClick event:@"OrderAllJS" attributes:dict counter:3];
        }
    }else{

        
    }

}
-(void)webViewDidFinishLoad:(UIWebView *)webView

{
    if (self.isBack) {
        if ([self.webView canGoBack]) {
            [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:NO];
        }else{
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = leftItem;
        }
    }else{
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    self.isBack = NO;
    NSString *rightUrl = webView.request.URL.absoluteString;
    [self doIfInWebWithUrl:rightUrl];

    //self.isBack = NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isQQReloadView"];

     [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];
    [self setRightBtnwithtype:0];
//    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
    //rightbtn显示的内容
    BOOL isNeedBtn = [[self.webView stringByEvaluatingJavaScriptFromString:@"isShowSaveButtonForApp()"]intValue];
    BOOL isNeedShareInfo = [[self.webView stringByEvaluatingJavaScriptFromString:@"isShowShareButtonForApp()"]intValue];
    if (isNeedBtn) {
        [self setRightBtnwithtype:1];
    }
    if (isNeedShareInfo) {
        [self setRightBtnwithtype:2];
    }

    if (self.isSave) {
        //        NSLog(@"%ld", self.webView.pageCount);
        [self.webView goBack];
        [self.webView goBack];
    }
    self.isSave = NO;
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:rightUrl forKey:@"PageUrl"];
    [self.shareInfo removeAllObjects];
    
    [IWHttpTool WMpostWithURL:@"/Common/GetPageType" params:dic success:^(id json) {
        
        NSLog(@"-----分享返回数据json is %@------",json);
        NSString *str =  json[@"ShareInfo"][@"Desc"];
        if(str.length>1){
            // [self.shareInfo removeAllObjects];
            self.shareInfo = json[@"ShareInfo"];
            NSLog(@"%@99999", self.shareInfo);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"分享请求数据失败，原因：%@",error);
    }];

   // [MBProgressHUD showSuccess:@"加载完成"];
   // [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (self.isBack) {
        if ([self.webView canGoBack]) {
            [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:NO];
        }else{
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = leftItem;
        }
    }
    self.isBack = NO;
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

#pragma mark - share 出团通知书分享

-(void)shareLink:(id)sender
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:@"0" forKey:@"ShareType"];
    if (self.shareInfo[@"Url"]) {
        [postDic setObject:self.shareInfo[@"Url"]  forKey:@"ShareUrl"];
    }
    [postDic setObject:self.webView.request.URL.absoluteString forKey:@"PageUrl"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:self.shareInfo[@"Desc"]
                                       defaultContent:self.shareInfo[@"Desc"]
                                                image:[ShareSDK imageWithUrl:self.shareInfo[@"Pic"]]
                                                title:self.shareInfo[@"Title"]
                                                  url:self.shareInfo[@"Url"]                                           description:self.shareInfo[@"Desc"]
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@",self.shareInfo[@"Url"]] image:nil];
    NSLog(@"%@444", self.shareInfo);
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", self.shareInfo[@"Url"]]];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender  arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    
                                    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                                    [MobClick event:@"ShareSuccessAll" attributes:dict];
                                    [MobClick event:@"ShareSuccessAllJS" attributes:dict counter:3];
                                    
                                    //精品推荐填1
                                    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
                                    [postDic setObject:@"0" forKey:@"ShareType"];
                                    if (self.shareInfo[@"Url"]) {
                                        [postDic setObject:self.shareInfo[@"Url"]  forKey:@"ShareUrl"];
                                    }
                                    [postDic setObject:self.webView.request.URL.absoluteString forKey:@"PageUrl"];
                                    if (type ==ShareTypeWeixiSession) {
                                        [postDic setObject:@"1" forKey:@"ShareWay"];
                                    }else if(type == ShareTypeQQ){
                                        [postDic setObject:@"2" forKey:@"ShareWay"];
                                    }else if(type == ShareTypeQQSpace){
                                        [postDic setObject:@"3" forKey:@"ShareWay"];
                                    }else if(type == ShareTypeWeixiTimeline){
                                        [postDic setObject:@"4" forKey:@"ShareWay"];
                                    }
                                    [IWHttpTool postWithURL:@"Common/SaveShareRecord" params:postDic success:^(id json) {
                                        NSDictionary * dci = json;
                                        NSMutableString * string = [NSMutableString string];
                                        for (id str in dci.allValues) {
                                            [string appendString:str];
                                        }
                                        
                                    } failure:^(NSError *error) {
                                        
                                    }];
                                    //产品详情
                                    if (type == ShareTypeCopy) {
                                        [MBProgressHUD showSuccess:@"复制成功"];
                                    }else{
                                        [MBProgressHUD showSuccess:@"分享成功"];
                                    }
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                                        [MBProgressHUD hideHUD];
                                    });
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    //                                    [self.warningLab removeFromSuperview];
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }else if (state == SSResponseStateCancel){
                                    //                                [self.warningLab removeFromSuperview];
                                }
                            }];
    
}



//提交选择的客户图片；
- (void)postCustomerToServer:(NSArray * )customerIDs{
    NSDictionary * dic = @{@"CustomerList":customerIDs};
    NSString * jsonStr = [dic JSONString];
    NSLog(@"%@", dic);
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"LYQSKBAPP_GetCustomerSelectPicFromApp_CallBack(%@, '%@')", @1, jsonStr]];

    
}






@end







