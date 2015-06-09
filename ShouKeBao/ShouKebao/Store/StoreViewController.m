//
//  StoreViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "StoreViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "AppDelegate.h"
#import "Lotuseed.h"
#import "MBProgressHUD+MJ.h"
#import "YYAnimationIndicator.h"
#define urlSuffix @"?isfromapp=1&apptype=1"
@interface StoreViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,copy) NSMutableString *shareUrl;
@property (weak, nonatomic) IBOutlet UIButton *checkCheapBtnOutlet;
- (IBAction)checkCheapPrice;
@property (weak, nonatomic) IBOutlet UILabel *cheapPrice;
@property (weak, nonatomic) IBOutlet UILabel *profit;
@property (weak, nonatomic) IBOutlet UILabel *jiafan;
@property (weak, nonatomic) IBOutlet UILabel *quan;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (nonatomic,strong) NSMutableArray *shareArr;

@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIView *btnLine;
@property (weak,nonatomic)  IBOutlet UILabel *offLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@property (weak, nonatomic) IBOutlet UIButton *fanBtn;
@property (weak, nonatomic) IBOutlet UIButton *quanBtn;
@property (weak, nonatomic) IBOutlet UIView *coverView;


@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic,copy) NSMutableString *needTimer;

@property (nonatomic,strong) YYAnimationIndicator *indicator;
@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺详情";
       NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:_PushUrl]];
  
    [self.webView loadRequest:request];
    [self customRightBarItem];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlackViewToHideIt)];
    tap.delegate = self;
    [self.blackView addGestureRecognizer:tap];
    
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
    
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [_indicator setLoadText:@"拼命加载中..."];
    [self.view addSubview:_indicator];

    
     [self.webView scalesPageToFit];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    
}

#pragma  -mark VC Life
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Lotuseed onPageViewBegin:@"Store"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Lotuseed onPageViewEnd:@"Store"];
}

#pragma -mark getter


-(NSMutableArray *)shareArr
{
    if (_shareArr == nil) {
        self.shareArr = [NSMutableArray array];
    }
    return _shareArr;
}

-(NSTimer *)timer
{
    if (_timer == nil) {
        self.timer = [[NSTimer alloc] init];
    }
    return _timer;
}

-(NSMutableString *)needTimer
{
    if (_needTimer == nil) {
        self.needTimer = [NSMutableString string];
    }
    return _needTimer;
}

#pragma  -mark private
-(void)customRightBarItem
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [button setImage:[UIImage imageNamed:@"APPfenxiang"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(shareIt:)forControlEvents:UIControlEventTouchUpInside];
    
   
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem= barItem;
    

    
}


-(void)tapBlackViewToHideIt
{
    [self.checkCheapBtnOutlet setSelected:NO];
    self.subView.hidden = YES;
    self.blackView.alpha = 0;
}

-(void)back
{

    if ([_webView canGoBack]) {
        [self.webView goBack];
    }else{
    [self.navigationController popViewControllerAnimated:YES];
    }
    
}





- (IBAction)checkCheapPrice{
    if (self.checkCheapBtnOutlet.selected == NO) {
      
        [Lotuseed onEvent:@"productDetailCheckCheapPrice"];
        
        [self.checkCheapBtnOutlet setSelected:YES];
        self.subView.hidden = NO;
        self.blackView.alpha = 0.5;
    }else if (self.checkCheapBtnOutlet.selected == YES){
        [self.checkCheapBtnOutlet setSelected:NO];
        self.subView.hidden = YES;
        self.blackView.alpha = 0;
    }
    
}

#pragma -mark webviewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   
    NSString *rightUrl = request.URL.absoluteString;
    NSRange range = [rightUrl rangeOfString:urlSuffix];
    if (range.location == NSNotFound) {
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:urlSuffix]]]];
    }else{
        self.coverView.hidden = NO;
        [_indicator startAnimation];
//        MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//        
//        hudView.labelText = @"拼命加载中...";
//        
//        [hudView show:YES];

        return YES;
    }
       NSLog(@"----------right url is %@ ----------",rightUrl);
    return YES;
}
//

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//     [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
    [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];
    self.coverView.hidden = YES;
       NSString *rightStr = webView.request.URL.absoluteString;
        
    
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"hideCheapPriceButton()"];
    NSLog(@"---------------------result is %@-------------------------",result);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:rightStr forKey:@"PageUrl"];
    
    [IWHttpTool WMpostWithURL:@"/Common/GetPageType" params:dic success:^(id json) {
        NSLog(@"-----分享返回数据json is %@------",json);
        
        [self.shareArr removeAllObjects];
        [self.shareArr addObject:json[@"ShareInfo"]];
        
        if (![json[@"PageType"] isEqualToString:@"2"]) {
         
            [self.timer invalidate];
            
            self.checkCheapBtnOutlet.hidden = YES;
            self.blackView.alpha = 0;
            self.btnLine.hidden = YES;
            self.title = @"店铺详情";
        }
        else if ([json[@"PageType"] isEqualToString:@"2"]){
            
         //定时器来调js方法
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideButn:) userInfo:nil repeats:YES];
            self.timer = timer;
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
           
            self.checkCheapBtnOutlet.hidden = NO;
            self.btnLine.hidden = NO;
            self.title = @"产品详情";
            NSMutableString *productID = [NSMutableString string];
            productID = json[@"ProductID"];
            NSMutableDictionary *dic =[NSMutableDictionary dictionary];
            [dic setObject:productID forKey:@"ProductID"];
            [IWHttpTool WMpostWithURL:@"/Product/GetProductByID" params:dic success:^(id json) {
                NSLog(@"产品详情json is %@",json);
                NSString *personPrice = json[@"Product"][@"PersonPrice"];
                if ([personPrice intValue] >0) {
                    
                    self.cheapPrice.text = [NSString stringWithFormat:@"￥%@",json[@"Product"][@"PersonPeerPrice"]];
                    self.profit.text = [NSString stringWithFormat:@"￥%@",json[@"Product"][@"PersonProfit"]];
                    
                    if ([json[@"Product"][@"PersonBackPrice"]  isEqual: @"0"]) {
                        //self.jiafan.hidden = YES;
                        self.fanBtn.hidden = YES;
                    }else if (![json[@"Product"]  isEqual: @"0"]){
                        self.fanBtn.hidden = NO;
                        [self.fanBtn setTitle:[NSString stringWithFormat:@"        ￥%@",json[@"Product"][@"PersonBackPrice"]] forState:UIControlStateNormal];
                        
                    }
                    
                    if ([json[@"Product"][@"PersonCashCoupon"] isEqualToString:@"0"]) {
                        
                        self.quanBtn.hidden = YES;
                    }else if (![json[@"Product"][@"PersonCashCoupon"] isEqualToString:@"0"]){
                        self.quanBtn.hidden = NO;
                        [self.quanBtn setTitle:[NSString stringWithFormat:@"        ￥%@",json[@"Product"][@"PersonCashCoupon"]] forState:UIControlStateNormal];
                        
                    }
                    
                }else if ([personPrice intValue]<1){
                    self.btnLine.hidden = NO;
                    self.checkCheapBtnOutlet.hidden = YES;
                    self.blackView.hidden = YES;
                    self.offLineLabel.hidden = NO;
                }
                
                
                
            } failure:^(NSError *error) {
                NSLog(@"同行价网络请求失败,%@",error);
            }];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"分享请求数据失败，原因：%@",error);
    }];


   

   

}
-(void)hideButn:(NSTimer*)timer
{
    NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:@"hideCheapPriceButton()"];
    NSLog(@"-------222222222222--------------result is %@-------------------------",result);
    if ([result  isEqual: @"1"]) {
        self.checkCheapBtnOutlet.hidden = YES;
        self.blackView.alpha = 0;
        self.btnLine.hidden = YES;
        self.offLineLabel.hidden = YES;

    }
    //[timer invalidate];
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
    
    CGFloat labW = self.view.bounds.size.width;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, labY, labW, 30)];
    lab.text = @"您分享出去的内容对外只显示门市价";
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    [actionWindow addSubview:lab];
}

#pragma 筛选navitem
-(void)shareIt:(id)sender
{
   
   
    NSDictionary *shareDic = [NSDictionary dictionary];
        shareDic = [self.shareArr lastObject];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareDic[@"Desc"]
                                       defaultContent:shareDic[@"Desc"]
                                                image:[ShareSDK imageWithUrl:shareDic[@"Pic"]]
                                                title:shareDic[@"Title"]
                                                  url:shareDic[@"Url"]                                          description:shareDic[@"Desc"]
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
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    NSLog(@"--------------分享出去的url is %@--------------",shareDic[@"Url"]);
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
