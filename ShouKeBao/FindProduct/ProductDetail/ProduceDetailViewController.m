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
#import "Lotuseed.h"
#import "SubstationParttern.h"
#import "YYAnimationIndicator.h"
#define urlSuffix @"?isfromapp=1&apptype=1"
@interface ProduceDetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (nonatomic,strong) NSMutableDictionary *shareInfo;

@property (nonatomic,strong) UIView *guideView;
@property (nonatomic,strong) UIImageView *guideImageView;
@property (nonatomic,assign) int guideIndex;
@property (nonatomic,strong) YYAnimationIndicator *indicator;

@property(nonatomic,weak) UILabel *warningLab;
@end

@implementation ProduceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
    
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [_indicator setLoadText:@"拼命加载中..."];
    [self.view addSubview:_indicator];

    self.title = @"产品详情";
       NSLog(@"--------link is %@ ",_produceUrl);
    
   // NSString *newUrl = [self.produceUrl stringByAppendingString:urlSuffix];
   
    

    
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:_produceUrl]]];
  

    [self customRightBarItem];
  
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
     [self.webView scalesPageToFit];
     [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    
    NSUserDefaults *guideDefault = [NSUserDefaults standardUserDefaults];
    NSString *productDetailGuide = [guideDefault objectForKey:@"productDetailGuide"];
    if ([productDetailGuide integerValue] != 1) {// 是否第一次打开app
        [self Guide];
    }
   // [self Guide];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Lotuseed onPageViewBegin:@"productDetail"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Lotuseed onPageViewEnd:@"productDetail"];
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
    an1.duration = 2;
    [self.guideImageView.layer addAnimation:an1 forKey:nil];
    [self.guideView removeFromSuperview];
       NSLog(@"被店家－－－－－－－－－－－－－indexi is %d－－",_guideIndex);
    
}


-(void)back
{
    
    if ([_webView canGoBack]) {
        
        [self.webView goBack];
   }
    else  {
        SubstationParttern *par = [SubstationParttern sharedStationName];
        [Lotuseed onEvent:@"productDetailBack" attributes:@{@"stationName":par.stationName}];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(NSMutableDictionary *)shareInfo
{
    if ( _shareInfo == nil ) {
        self.shareInfo = [NSMutableDictionary dictionary];
    }
    return _shareInfo;
}

-(void)customRightBarItem
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [button setImage:[UIImage imageNamed:@"APPfenxiang"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(shareIt:)forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem= barItem;
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   
    NSString *rightUrl = request.URL.absoluteString;
    NSRange range = [rightUrl rangeOfString:urlSuffix];
    if (range.location == NSNotFound) {
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:urlSuffix]]]];
    }else{
        
        self.coverView.hidden = NO;
        [_indicator startAnimation];

        return YES;
    }
   
    NSLog(@"----------right url is %@ ----------",rightUrl);
    return YES;

       }



-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.coverView.hidden = YES;
     [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];

 NSString *rightUrl = webView.request.URL.absoluteString;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:rightUrl forKey:@"PageUrl"];
    // [self.shareInfo removeAllObjects];
    
    [IWHttpTool WMpostWithURL:@"/Common/GetPageType" params:dic success:^(id json) {
        
        NSLog(@"-----分享返回数据json is %@------",json);
      NSString *str =  self.shareInfo[@"Desc"];
        if(str.length<2){
            self.shareInfo = json[@"ShareInfo"];}
    } failure:^(NSError *error) {
        
        NSLog(@"分享请求数据失败，原因：%@",error);
        
    }];

}

-(void)addAlert
{
    
    
    // 获取到现在应用中存在几个window，ios是可以多窗口的
    
    NSArray *windowArray = [UIApplication sharedApplication].windows;
    
    // 取出最后一个，因为你点击分享时这个actionsheet（其实是一个window）才会添加
    
    UIWindow *actionWindow = (UIWindow *)[windowArray lastObject];
    
    // 以下就是不停的寻找子视图，修改要修改的
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat labY;
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
    [UIView animateWithDuration:0.4 animations:^{
        lab.transform = CGAffineTransformMakeTranslation(0, labY-screenH);
    }];
    self.warningLab = lab;

}


#pragma 筛选navitem
-(void)shareIt:(id)sender
{
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:self.shareInfo[@"Desc"]
                                       defaultContent:self.shareInfo[@"Desc"]
                                                image:[ShareSDK imageWithUrl:self.shareInfo[@"Pic"]]
                                                title:self.shareInfo[@"Title"]
                                                  url:self.shareInfo[@"Url"]                                          description:self.shareInfo[@"Desc"]
                                            mediaType:SSPublishContentMediaTypeNews];


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
                                    [self.warningLab removeFromSuperview];
                                    SubstationParttern *par = [SubstationParttern sharedStationName];
                                    [Lotuseed onEvent:@"productDetailShareSuccess" attributes:@{@"stationName":par.stationName}];
                                    
                                    [IWHttpTool postWithURL:@"Common/SaveShareRecord" params:@{@"ShareType":@"1"} success:^(id json) {
                                    } failure:^(NSError *error) {
                                        
                                    }];

                                    [MBProgressHUD showSuccess:@"分享成功"];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                                        [MBProgressHUD hideHUD];
                                    });
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    [self.warningLab removeFromSuperview];
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }else if (state == SSResponseStateCancel){
                                [self.warningLab removeFromSuperview];
                                }
                            }];

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



@end
