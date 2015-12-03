//
//  CircleHotNewsViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CircleHotNewsViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "NSString+FKTools.h"
#import "YYAnimationIndicator.h"
#import "WMAnimations.h"
#import "StrToDic.h"
#import "IWHttpTool.h"

#define View_Width self.view.frame.size.width
#define View_Height self.view.frame.size.height

@interface CircleHotNewsViewController ()<UIWebViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, copy)NSString *urlSuffix;
@property (nonatomic, copy)NSString *urlSuffix2;
@property (nonatomic, strong)YYAnimationIndicator *indicator;
@property (nonatomic, assign)BOOL isBack;
@property (nonatomic, assign)BOOL isSave;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, copy)NSString *telStr;
@property (nonatomic, strong)NSMutableArray *shareArr;
//@property ()
@end

@implementation CircleHotNewsViewController


- (void)deadWork{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    NSString  *urlSuffix = [NSString stringWithFormat:@"?isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix = urlSuffix;
    
    NSString  *urlSuffix2 = [NSString stringWithFormat:@"&isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix2 = urlSuffix2;
    
     [WMAnimations WMNewWebWithScrollView:self.webView.scrollView];
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [_indicator setLoadText:@"拼命加载中..."];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self setshareBarItem];
    [self deadWork];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(isCallTel) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:self.CircleUrl]]];
    [self webView];
}

- (void)isCallTel{
    NSString * string = [self.webView stringByEvaluatingJavaScriptFromString:@"getTelForApp()"];
    if (string.length != 0) {
        self.telStr = string;
        NSLog(@"%@", self.telStr);
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要拨打电话:%@吗?", self.telStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",self.telStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    }
}



#pragma mark - uiwebView-delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *rightUrl = request.URL.absoluteString;
    NSLog(@"rightStr is %@--------",rightUrl);
    NSRange range = [rightUrl rangeOfString:_urlSuffix];//带？
    NSRange range2 = [rightUrl rangeOfString:_urlSuffix2];//不带?
    NSRange range3 = [rightUrl rangeOfString:@"?"];
    
   
    
//    NSRange shareRange = [rightUrl rangeOfString:@"objectc:LYQSKBAPP_OpenShareProduct"];
    [_indicator startAnimation];

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
//    if (shareRange.location != NSNotFound) {
//        [self shareAction:nil];
//        [_indicator stopAnimationWithLoadText:@"" withType:YES];
//    }
    return YES;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //判断是否应该显示关闭按钮
    if (self.m == 0) {
        
    }else if(self.m == 1){
        if ([self.webView canGoBack]) {
            [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:NO];
        }else{
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = leftItem;
    }
  }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"；；；；；；%@",webView.request.URL.absoluteString);
    NSString *rightUrl = webView.request.URL.absoluteString;
    if ([rightUrl containsString:@"/mc/kaifaceshi/theme/"]) {
        self.title = @"主题详情";
    }else if ([rightUrl containsString:@"/mc/kaifaceshi/Product/"]){
        self.title = @"产品详情";
    }else if ([rightUrl containsString:@"/mc/kaifaceshi/zt/"]){
        self.title = @"专辑详情";
    }else if([rightUrl containsString:@"/mc/kaifaceshi/WonderfulActivity/"]){
        self.title = @"圈热点";
    }
    
    
    //判断是否显示关闭按钮
    if (self.m == 0) {
    }else if(self.m == 1){
        if ([self.webView canGoBack]) {
            [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:NO];
        }else{
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = leftItem;
        }
    }
    [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:webView.request.URL.absoluteString forKey:@"PageUrl"];
        [IWHttpTool WMpostWithURL:@"/Common/GetPageType" params:dic success:^(id json) {
            NSLog(@"-----分享返回数据json is %@------",json);
            NSString *str =  json[@"ShareInfo"][@"Desc"];
            if(str.length>1){
                [self.shareArr addObject:json[@"ShareInfo"]];
            }
        } failure:^(NSError *error){
            
            NSLog(@"分享请求数据失败，原因：%@",error);
        }];
   
}







#pragma mark - 初始化
- (NSMutableArray *)shareArr{
    if (!_shareArr) {
        self.shareArr = [NSMutableArray array];
    }
    return _shareArr;
}

- (UIWebView *)webView{
    if (!_webView) {
        self.webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.webView.delegate = self;
        [self.webView scalesPageToFit];
        [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
        [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.view addSubview:self.webView];
    }
    return _webView;
}


-(void)back{
        self.isBack = YES;
        if ([_webView canGoBack]) {
    
            [self.webView goBack];
       }else  {
            [self.navigationController popViewControllerAnimated:YES];
        }
}


#pragma mark = 分享
-(void)shareAction:(UIButton *)btn{
    
    NSDictionary *shareDic = [NSDictionary dictionary];
    shareDic = [StrToDic dicCleanSpaceWithDict:[self.shareArr lastObject]];
    if (!shareDic.count) {
        return;
    }
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareDic[@"Desc"]
                                       defaultContent:shareDic[@"Desc"]
                                                image:[ShareSDK imageWithUrl:shareDic[@"Pic"]]
                                                title:shareDic[@"Title"]
                                                  url:shareDic[@"Url"]                                  description:shareDic[@"Desc"]
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@",shareDic[@"Url"]] image:nil];
    NSLog(@"%@444", shareDic);
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", shareDic[@"Url"]]];

    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:btn  arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                [self.warningLab removeFromSuperview];
                                if (state == SSResponseStateSuccess)
                                {
                               
                                    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
                                    [postDic setObject:@"0" forKey:@"ShareType"];
                                    if (shareDic[@"Url"]) {
                                        [postDic setObject:shareDic[@"Url"]  forKey:@"ShareUrl"];
                                    }
                                    [postDic setObject:self.webView.request.URL.absoluteString forKey:@"PageUrl"];
                                    if (type ==ShareTypeWeixiSession) {
                                      
                                    }else if(type == ShareTypeQQ){
                                  
                                    }else if(type == ShareTypeQQSpace){
                                       
                                    }else if(type == ShareTypeWeixiTimeline){
                                                                           }                                    //产品详情
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
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }else if (state == SSResponseStateCancel){

                                }
                            }];
    
    NSLog(@"%@",shareDic[@"Url"]);
    [self addAlert];
  
}

-(void)addAlert{
    NSArray *windowArray = [UIApplication sharedApplication].windows;
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
//    self.warningLab = lab;
    
}

- (void)setshareBarItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    [button setImage:[UIImage imageNamed:@"APPfenxiang"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = shareBarItem;
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
