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

#define View_Width self.view.frame.size.width
#define View_Height self.view.frame.size.height

@interface CircleHotNewsViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)NSMutableDictionary * shareInfo;
@property (nonatomic, copy)NSString *urlSuffix;
@property (nonatomic, copy)NSString *urlSuffix2;
//@property ()
@end

@implementation CircleHotNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"圈热点";
    self.navigationItem.leftBarButtonItems = @[leftItem,turnOffItem];
    [self setshareBarItem];
  
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));

    NSString  *urlSuffix = [NSString stringWithFormat:@"?isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix = urlSuffix;
    
    NSString  *urlSuffix2 = [NSString stringWithFormat:@"&isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix2 = urlSuffix2;
    
    
//     [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:_produceUrl]]];
    
    
    
    
}
#pragma mark - 初始化
- (NSMutableDictionary *)shareInfo{
    if (!_shareInfo) {
        self.shareInfo = [NSMutableDictionary dictionary];
    }
    return _shareInfo;
}
- (UIWebView *)webView{
    if (!_webView) {
        self.webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.webView.delegate = self;
        [self.webView scalesPageToFit];
        [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
        [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _webView;
}

































#pragma mark = 分享
-(void)shareAction:(UIButton *)btn{
//    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
//    [postDic setObject:@"0" forKey:@"ShareType"];
//    if (self.shareInfo[@"Url"]) {
//        [postDic setObject:self.shareInfo[@"Url"]  forKey:@"ShareUrl"];
//    }
//    [postDic setObject:self.webView.request.URL.absoluteString forKey:@"PageUrl"];
//    NSLog(@"%@", postDic);
    //构造分享内容
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
                                    if (self.shareInfo[@"Url"]) {
                                        [postDic setObject:self.shareInfo[@"Url"]  forKey:@"ShareUrl"];
                                    }
                                    [postDic setObject:self.webView.request.URL.absoluteString forKey:@"PageUrl"];
                                    if (type ==ShareTypeWeixiSession) {
                                      
                                    }else if(type == ShareTypeQQ){
                                  
                                    }else if(type == ShareTypeQQSpace){
                                       
                                    }else if(type == ShareTypeWeixiTimeline){
                                                                           }
//                                    [IWHttpTool postWithURL:@"Common/SaveShareRecord" params:postDic success:^(id json) {
//                                        NSDictionary * dci = json;
//                                        NSMutableString * string = [NSMutableString string];
//                                        for (id str in dci.allValues) {
//                                            [string appendString:str];
//                                        }
//                                        
//                                    } failure:^(NSError *error) {
//                                        
//                                    }];
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
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }else if (state == SSResponseStateCancel){

                                }
                            }];
    
    NSLog(@"%@",self.shareInfo[@"Url"]);
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
- (void)back{
//    self.isBack = YES;
    if ([_webView canGoBack]) {
        [self.webView goBack];
    }else{
        if ([[self.webView stringByEvaluatingJavaScriptFromString:@"AppIsShowShareWhenBack()"]isEqualToString:@"1"]) {//判断能否弹框
            [NSString showbackgroundgray];
//            [NSString showLeaveShareNav:self.navigationController InVC:self];
            [self.webView stringByEvaluatingJavaScriptFromString:@"AppHadShowShareWhenBack()"];//提示弹框
        }else {//不能提示
            [self.webView stringByEvaluatingJavaScriptFromString:@"AppRecordBackNumber()"];
            [self.navigationController popViewControllerAnimated:YES];
        }
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
