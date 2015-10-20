//
//  LvYouGuWenViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/9/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "LvYouGuWenViewController.h"
#import "MeHttpTool.h"
#import "BeseWebView.h"
#import <ShareSDK/ShareSDK.h>
#import "MobClick.h"
#import "BaseClickAttribute.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+FKTools.h"

@interface LvYouGuWenViewController ()<UIWebViewDelegate>
@property(nonatomic,weak) UILabel *warningLab;
@property (nonatomic, assign)BOOL isShow;
@end

@implementation LvYouGuWenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataSource];
    //self.navigationItem.leftBarButtonItem = leftItem;
    self.title = @"专属APP";
    self.isShow = YES;
    self.webView.delegate  = self;

}
#pragma mark - loadDataSource
- (void)loadDataSource
{
    [MeHttpTool getMeIndexWithParam:@{} success:^(id json) {
        if (json) {
            NSLog(@"-----**%@",json);
            [self loadWithUrl:json[@"ConsultantUrl"]];
            self.linkUrl = json[@"ConsultantUrl"];
            self.shareInfo = json[@"ConsultanShareInfo"];
            NSLog(@"%@", self.linkUrl);
        }
    }failure:^(NSError *error){
        
    }];
}


-(void)setShateButtonHidden:(BOOL)hidden{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [button setImage:[UIImage imageNamed:@"APPfenxiang"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(shareIt:)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareBarItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (hidden) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = shareBarItem;
    }
}
-(void)shareIt:(id)sender
{
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ClickShareAll" attributes:dict];
    
    NSLog(@"%@", self.shareInfo);
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:@"0" forKey:@"ShareType"];
    if (self.shareInfo[@"Url"]) {
        [postDic setObject:self.shareInfo[@"Url"]  forKey:@"ShareUrl"];
    }
    [postDic setObject:self.webView.request.URL.absoluteString forKey:@"PageUrl"];
    NSLog(@"%@", postDic);
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
                                [self.warningLab removeFromSuperview];
                                self.isShow = YES;
                                if (state == SSResponseStateSuccess)
                                {
                                    
                                    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                                    [MobClick event:@"ShareSuccessAll" attributes:dict];
                                    [MobClick event:@"ShareSuccessAllJS" attributes:dict counter:3];
                                    
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
    
//    [self addAlert];
    
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

#pragma mark - loadWebView
- (void)loadWithUrl:(NSString *)url
{
    //    url = @"http://www.myie9.com/useragent/";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@", webView.request.URL.absoluteString);

    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    
    NSLog(@"aaa%@", request.URL.absoluteString);

    if (self.isShow&&[request.URL.absoluteString myContainsString:@"objectc:LYQSKBAPP_OpenShareDialog"]) {
        [self shareIt:nil];
        self.isShow = NO;
        [self.indicator stopAnimationWithLoadText:@"加载成功" withType:YES];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:NO];
        //        NSLog(@"xxxxxx");
    }else{
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = leftItem;
        
    }
    BOOL isNeedShareButton = [[self.webView stringByEvaluatingJavaScriptFromString:@"isShowShareButtonForApp()"]intValue];
    if (isNeedShareButton) {
        [self setShateButtonHidden:NO];
    }else{
        [self setShateButtonHidden:YES];
    }
    [super webViewDidFinishLoad:webView];
}

@end
