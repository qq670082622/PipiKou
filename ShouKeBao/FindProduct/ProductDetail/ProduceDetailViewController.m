//
//  ProduceDetailViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ProduceDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"

#import "YYAnimationIndicator.h"
//#import "BeseWebView.h"
#import "WMAnimations.h"
#import "StrToDic.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"
#import "DayDetail.h"
#import "yesterDayModel.h"
#import "JSONKit.h"
#import "NSString+FKTools.h"
@interface ProduceDetailViewController ()<UIWebViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *coverView;
//@property (nonatomic,strong) NSMutableDictionary *shareInfo;

@property (nonatomic,strong) UIView *guideView;
@property (nonatomic,strong) UIImageView *guideImageView;
@property (nonatomic,assign) int guideIndex;
@property (nonatomic,strong) YYAnimationIndicator *indicator;
@property (nonatomic, strong)NSTimer *timer;
@property(nonatomic,weak) UILabel *warningLab;
@property (nonatomic, copy)NSString *telString;
@property (nonatomic, copy)NSString *urlSuffix;
@property (nonatomic, copy)NSString *urlSuffix2;
@property (nonatomic, strong)NSArray *eventArray;
@property (nonatomic, assign)BOOL isBack;
@property (nonatomic,strong) UIButton * rightButton;
@property (nonatomic,assign) BOOL isSave;
//FromQRcode,
//FromRecommend,
//FromStore,
//FromProductSearch,
//FromFindProduct,
//FromHotProduct

@property (nonatomic, strong)UISwipeGestureRecognizer * recognizer;

@end

@implementation ProduceDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.coverView.hidden = YES;

    
    if (self.fromType == FromFindProduct || self.fromType == FromHotProduct || self.fromType == FromProductSearch) {
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"FromFindProductAll" attributes:dict];
        
    }
    self.eventArray = @[@"FromQRcode", @"FromRecommend", @"FromStore", @"FromProductSearch",@"FromFindProduct", @"FromHotProduct", @"FromScanHistory"];
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ProductDetailAll" attributes:dict];
    [MobClick event:@"ProductDetailAllJS" attributes:dict counter:3];
    
    NSString * string = [NSString stringWithFormat:@"%@", [self.eventArray objectAtIndex:self.fromType]];
    [MobClick event:string attributes:dict];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
#warning 这里需要变动
//    NSString * orderIds = @"asdasd,asdasdas,grwtg";  //&orderIds=%@
    NSString  *urlSuffix = [NSString stringWithFormat:@"?isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix = urlSuffix;
    
    NSString  *urlSuffix2 = [NSString stringWithFormat:@"&isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix2 = urlSuffix2;

     [WMAnimations WMNewWebWithScrollView:self.webView.scrollView];
    
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
   
   
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [_indicator setLoadText:@"拼命加载中..."];
    [self.view addSubview:_indicator];
    if (!self.titleName) {
        self.title = @"产品详情";
    }else{
        self.title = self.titleName;
    }
       NSLog(@"--------link is %@ ",_produceUrl);
    
   // NSString *newUrl = [self.produceUrl stringByAppendingString:urlSuffix];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopIndictor:) name:@"stopIndictor" object:nil];


    
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:_produceUrl]]];
  

    [self customRightBarItemType:1];

        [self.webView scalesPageToFit];
     [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    
    NSUserDefaults *guideDefault = [NSUserDefaults standardUserDefaults];
    NSString *productDetailGuide = [guideDefault objectForKey:@"productDetailGuide"];
    if ([productDetailGuide integerValue] != 1) {// 是否第一次打开app
        [self Guide];
    }
    
//    self.recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [self.recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    [self.webView addGestureRecognizer:self.recognizer];
    
////    *******************
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(returnAction:)];
//    [swipeGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    [self.view addGestureRecognizer:swipeGesture];
    
    
    
    

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(findIsCall) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self setUpleftBarButtonItems];
//    UIScreenEdgePanGestureRecognizer *screenEdge = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreen:)];
//    screenEdge.edges = UIRectEdgeLeft;
//    [self.webView.scrollView addGestureRecognizer:screenEdge];
 }

//- (void)returnAction:(UISwipeGes  tureRecognizer *)swip
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}


-(void)setUpleftBarButtonItems
{
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
//    back.frame = CGRectMake(0, 0, 45, 10);
//    [back setTitle:@"〈返回" forState:UIControlStateNormal];
//    back.titleLabel.font = [UIFont systemFontOfSize:14];
//    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
//    UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
//    turnOff.titleLabel.font = [UIFont systemFontOfSize:16];
//    turnOff.frame = CGRectMake(0, 0, 30, 10);
//    [turnOff addTarget:self action:@selector(turnOff) forControlEvents:UIControlEventTouchUpInside];
//    [turnOff setTitle:@"关闭"  forState:UIControlStateNormal];
//    turnOff.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
//    [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    UIBarButtonItem *turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];
    //self.navigationItem.leftBarButtonItems = @[leftItem,turnOffItem];
    if (self.m == 0) {
        self.navigationItem.leftBarButtonItems = @[leftItem,turnOffItem];
    }else{
    self.navigationItem.leftBarButtonItem = leftItem;
    }
    //[self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:YES];
    
}
#pragma mark - telCall_js

- (void)findIsCall{
    NSString * string = [self.webView stringByEvaluatingJavaScriptFromString:@"getTelForApp()"];
    NSLog(@",,,, str = %@", string);
    if (string.length != 0) {
        self.telString = string;
        NSLog(@"%@", self.telString);
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要拨打电话:%@吗?", string] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
   
    
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.webView.delegate = nil;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //打电话；
        NSString *phonen = [NSString stringWithFormat:@"tel://%@",self.telString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonen]];
    }
}
- (void)stopIndictor:(NSNotification *)noty
{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"亲！欢迎回来" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
    [self.webView reload];
    if ([_webView canGoBack] && self.indicator.isAnimating) {
        [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];
        [self.webView goBack];
    }
}
//再次返回程序的时候， 弹出对话框；
#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if ([_webView canGoBack] && self.indicator.isAnimating) {
//        [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];
//        [self.webView goBack];
//    }
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ProduceDetailView"];
   }
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.delegate notiQRCToStartRuning];
    [MobClick endLogPageView:@"ProduceDetailView"];
    [self.timer invalidate];
}
//第一次开机引导
-(void)Guide
{
    self.guideView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _guideView.backgroundColor = [UIColor clearColor];
    self.guideImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_guideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)]];
    self.guideImageView.image = [UIImage imageNamed:@"productDetailShareGuide"];
    
    
    NSUserDefaults *guideDefault = [NSUserDefaults standardUserDefaults];
    [guideDefault setObject:@"1" forKey:@"productDetailGuide"];
    [guideDefault synchronize];
    
    [self.guideView addSubview:_guideImageView];
    [[[UIApplication sharedApplication].delegate window] addSubview:_guideView];
}
-(void)click
{
    CATransition *an1 = [CATransition animation];
    an1.type = @"rippleEffect";
    an1.subtype = kCATransitionFromRight;//用kcatransition的类别确定cube翻转方向
    an1.duration = 0.2;
    [self.guideImageView.layer addAnimation:an1 forKey:nil];
    [self.guideView removeFromSuperview];
       NSLog(@"被店家－－－－－－－－－－－－－indexi is %d－－",_guideIndex);
    
}


-(void)back
{
    //下边是未改动返回
//    self.isBack = YES;
//    if ([_webView canGoBack]) {
//        
//        [self.webView goBack];
//   }else  {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    //下边是正在增加退出分享的借口
    self.isBack = YES;
    if ([_webView canGoBack]) {
        
        [self.webView goBack];
    }else  {
        //NSLog(@"%@", [self.webView stringByEvaluatingJavaScriptFromString:@"AppIsShowShareWhenBack()"]);
        if ([[self.webView stringByEvaluatingJavaScriptFromString:@"AppIsShowShareWhenBack()"]isEqualToString:@"1"]) {//判断能否弹框
            [NSString showbackgroundgray];
            [NSString showLeaveShareNav:self.navigationController InVC:self];
            [self.webView stringByEvaluatingJavaScriptFromString:@"AppHadShowShareWhenBack()"];//提示弹框

        }else {//不能提示
            [self.webView stringByEvaluatingJavaScriptFromString:@"AppRecordBackNumber()"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
   
}
-(void)CancelLeaveShareBlock:(UINavigationController *)uinav{
    [uinav popViewControllerAnimated:YES];
}

-(void)turnOff
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(NSMutableDictionary *)shareInfo
//{
//    if ( _shareInfo == nil ) {
//        self.shareInfo = [NSMutableDictionary dictionary];
//    }
//    return _shareInfo;
//}

-(void)customRightBarItemType:(NSInteger)type
{
    //分享
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [button setImage:[UIImage imageNamed:@"APPfenxiang"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(shareIt:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    //确定
    self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,20)];
    [self.rightButton setTitle:@"确定" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightButton addTarget:self action:@selector(writeVisitorsInfoWebViewGoBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    if (type == 1) {
        self.navigationItem.rightBarButtonItem= shareBarItem;
    }else if (type == 2){
        self.navigationItem.rightBarButtonItem = rightItem;
    }
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
        [self shareIt:nil];
        [_indicator stopAnimationWithLoadText:@"" withType:YES];
    }
        return YES;
  
}

- (void)doIfInWebWithUrl:(NSString *)rightUrl{
//    if ([rightUrl myContainsString:@"mqq://"]) {
//        NSLog(@"%@", rightUrl);
//    }
    
    if (!self.isBack) {
        if ([rightUrl myContainsString:@"/ProductDetailExt/"]) {//订单价格
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            NSLog(@"%@", [NSString stringWithFormat:@"%@ProductPrice", [self.eventArray objectAtIndex:self.fromType]]);
            [MobClick event:[NSString stringWithFormat:@"%@ProductPrice", [self.eventArray objectAtIndex:self.fromType]] attributes:dict];
        }else if([rightUrl myContainsString:@"/Order/Create?"]){//填写联系人
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:[NSString stringWithFormat:@"%@ProductWritecontacts", [self.eventArray objectAtIndex:self.fromType]] attributes:dict];
            
        }else if([rightUrl myContainsString:@"/Order/CreateSuccess/"]){//提交成功
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:[NSString stringWithFormat:@"%@ProductOrderSuccess", [self.eventArray objectAtIndex:self.fromType]] attributes:dict];
            [MobClick event:@"OrderAll" attributes:dict];
            [MobClick event:@"OrderAllJS" attributes:dict counter:3];
        }
    }

}
- (void)writeVisitorsInfoWebViewGoBack{
    self.isSave = YES;
    [self.webView stringByEvaluatingJavaScriptFromString:@"saveCustomer()"];
    NSLog(@"$$$$www  %@", [self.webView stringByEvaluatingJavaScriptFromString:@"saveCustomer()"]);
    
    
    //    [self.webView goBack];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    NSLog(@"%@",webView.request.URL.absoluteString);
    //判断是否显示关闭按钮
    if (self.m == 0) {
        
    }else if(self.m == 1){
        if ([self.webView canGoBack]) {
//            self.navigationItem.leftBarButtonItem = nil;
            [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:NO];
        }else{
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = leftItem;
        }
        
    }
    
    [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];

    NSString *rightUrl = webView.request.URL.absoluteString;
    self.isBack = NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isQQReloadView"];
    [self customRightBarItemType:1];
    BOOL isNeedBtn = [[self.webView stringByEvaluatingJavaScriptFromString:@"isShowSaveButtonForApp()"]intValue];
    if (isNeedBtn) {
        [self customRightBarItemType:2];
    }
    if (self.isSave) {
        //        NSLog(@"%ld", self.webView.pageCount);
        [self.webView goBack];
        [self.webView goBack];
    }
    self.isSave = NO;
    // [MBProgressHUD showSuccess:@"加载完成"];



//    NSLog(@"right Str is %@",rightUrl);
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    
//    [dic setObject:rightUrl forKey:@"PageUrl"];
//     [self.shareInfo removeAllObjects];
//
//    [IWHttpTool WMpostWithURL:@"/Common/GetPageType" params:dic success:^(id json) {
//        
//        NSLog(@"-----分享返回数据json is %@------",json);
//      NSString *str =  json[@"ShareInfo"][@"Desc"];
//        if(str.length>1){
//          // [self.shareInfo removeAllObjects];
//            self.shareInfo = json[@"ShareInfo"];
//            NSLog(@"%@99999", self.shareInfo);
//        }
//    } failure:^(NSError *error) {
//        
//        NSLog(@"分享请求数据失败，原因：%@",error);
//    }];
    //如果没有shareInfo，请求接口
    if (self.noShareInfo) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:webView.request.URL.absoluteString forKey:@"PageUrl"];
        [IWHttpTool WMpostWithURL:@"/Common/GetPageType" params:dic success:^(id json) {
            NSLog(@"-----分享返回数据json is %@------",json);
            NSString *str =  json[@"ShareInfo"][@"Desc"];
//            [[[UIAlertView alloc]initWithTitle:str message:@"11" delegate:nil cancelButtonTitle:json[@"ShareInfo"][@"Url"] otherButtonTitles:nil, nil]show];
            if(str.length>1){
                // [self.shareInfo removeAllObjects];
                self.shareInfo = json[@"ShareInfo"];
                NSLog(@"%@99999", self.shareInfo);
                
            }
        } failure:^(NSError *error) {
            
            NSLog(@"分享请求数据失败，原因：%@",error);
        }];
        
    }

    [self doIfInWebWithUrl:rightUrl];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //判断是否应该显示关闭按钮
    if (self.m == 0) {
        
    }else if(self.m == 1){
        if ([self.webView canGoBack]) {
            //self.navigationItem.leftBarButtonItem = nil;
            [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:NO];
        }else{
            self.navigationItem.leftBarButtonItem = nil;
           self.navigationItem.leftBarButtonItem = leftItem;
           
        }

    }
//        [_indicator stopAnimationWithLoadText:@"加载失败" withType:YES];
}
-(void)addAlert
{
    
    
    // 获取到现在应用中存在几个window，ios是可以多窗口的
    
    NSArray *windowArray = [UIApplication sharedApplication].windows;
    
    // 取出最后一个，因为你点击分享时这个actionsheet（其实是一个window）才会添加
    
    UIWindow *actionWindow = (UIWindow *)[windowArray lastObject];
    
    // 以下就是不停的寻找子视图，修改要修改的
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat labY = 180;
    if (screenH == 667) {
        labY = 260;
    }else if (screenH == 568){
        labY = 160;
    }else if (screenH == 480){
        labY = 180;
    }else if (screenH == 736){
        labY = 440;
    }
    
    CGFloat labW = [[UIScreen mainScreen] bounds].size.width;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH, labW, 30)];
    lab.text = @"您分享出去的内容对外只显示门市价";
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    [actionWindow addSubview:lab];
    [UIView animateWithDuration:0.38 animations:^{
        lab.transform = CGAffineTransformMakeTranslation(0, labY-screenH - 8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.17 animations:^{
            lab.transform = CGAffineTransformMakeTranslation(0, labY-screenH);
        }];
    }];
    self.warningLab = lab;

}


#pragma 筛选navitem
-(void)shareIt:(id)sender
{
    //每次分享的时候调用此方法，让后台知道当前页面分享的产品
    [self.webView stringByEvaluatingJavaScriptFromString:@"AppHadShareWhenBack()"];

    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ClickShareAll" attributes:dict];
    [MobClick event:@"ProductDetailShareClickAll" attributes:dict];
    if (self.fromType == FromQRcode) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"ppkLYQAPP_ShareSuccess()"];
    }
    NSLog(@"%@", self.shareInfo);
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:@"0" forKey:@"ShareType"];
    if (self.shareInfo[@"Url"]) {
        [postDic setObject:self.shareInfo[@"Url"]  forKey:@"ShareUrl"];
    }
    [postDic setObject:self.webView.request.URL.absoluteString forKey:@"PageUrl"];
    NSLog(@"%@", postDic);
    //构造分享内容
//    NSString * str = [NSString stringWithFormat:@"%@%@%@", self.shareInfo[@"Title"], self.shareInfo[@"Desc"], self.shareInfo[@"Url"]];
    
    
//    NSMutableDictionary *new =  [StrToDic dicCleanSpaceWithDict:self.shareInfo];
//    self.shareInfo = new;
    
//    NSString * str = [[(NSString *)self.shareInfo[@"Url"] componentsSeparatedByString:@"?"]firstObject];
//    NSLog(@"shareInfoIs %@",new);
//    NSString * title = [(NSString *)self.shareInfo[@"Title"] stringByReplacingCharactersInRange:NSMakeRange(10, 10) withString:@".."];
//    if (self.detail) {
//        self.shareInfo = self.detail.ShareInfo;
//    }else{
//        self.shareInfo = self.detail2.ShareInfo;
//    }
    id<ISSContent> publishContent = [ShareSDK content:self.shareInfo[@"Desc"]
                                       defaultContent:self.shareInfo[@"Desc"]
                                                image:[ShareSDK imageWithUrl:self.shareInfo[@"Pic"]]
                                                title:self.shareInfo[@"Title"]
                                                  url:self.shareInfo[@"Url"]                                  description:self.shareInfo[@"Desc"]
                                            mediaType:SSPublishContentMediaTypeNews];

    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@",self.shareInfo[@"Url"]] image:nil];
    NSLog(@"%@444", self.shareInfo);
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", self.shareInfo[@"Url"]]];
   NSLog(@"self.shareInfo %@, %@", self.shareInfo[@"Url"], self.shareInfo[@"ShareUrl"]);
    
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
                                [self.warningLab removeFromSuperview];
                                if (state == SSResponseStateSuccess)
                                {
                                    
                                    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                                    [MobClick event:@"ShareSuccessAll" attributes:dict];
                                    [MobClick event:@"ShareSuccessAllJS" attributes:dict counter:3];
                                    [MobClick event:@"ProductDetailShareSuccessClickAll" attributes:dict];
                                    if (self.fromType == FromFindProduct || self.fromType == FromHotProduct || self.fromType == FromProductSearch) {
                                        [MobClick event:@"FromFindProductAllShareSuccess" attributes:dict];
                                    }
                                    if (self.fromType == FromRecommend) {
                                        [MobClick event:@"RecommendShareSuccessAll" attributes:dict];

                                    }
                                    
                                        [MobClick event:[NSString stringWithFormat:@"%@ShareSuccess", [self.eventArray objectAtIndex:self.fromType]] attributes:dict];

        
//                                    [self.warningLab removeFromSuperview];
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
                                        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                                        [MobClick event:@"ShareFailAll" attributes:dict];

                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }else if (state == SSResponseStateCancel){
//                                [self.warningLab removeFromSuperview];
                                }
                            }];
    
    NSLog(@"%@",self.shareInfo[@"Url"]);
    [self addAlert];
    
}

-(void)reloadStateWithType:(ShareType)type
{
    //现实授权信息，包括授权ID、授权有效期等。
    //此处可以在用户进入应用的时候直接调用，如授权信息不为空且不过期可帮用户自动实现登录。
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:type];//此处用于得到返回结果
    NSLog(@"uid :%@ , token :%@ , secret:%@ , expirend:%@ , exInfo:%@",[credential uid],[credential token],[credential secret],[credential expired],[credential extInfo]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
  */

@end
