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
#import "StrToDic.h"
#import "MBProgressHUD+MJ.h"
#import "YYAnimationIndicator.h"
#import "WMAnimations.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"
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

@property(nonatomic,weak) UILabel *warningLab;
@property(nonatomic,copy) NSString *urlSuffix;
@property(nonatomic,copy) NSString *urlSuffix2;
@property (nonatomic, copy)NSString * telString;
@property (nonatomic, strong)NSTimer * timerr;
@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.coverView.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopIndictor) name:@"stopIndictor" object:nil];

    self.title = @"店铺详情";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString  *urlSuffix = [NSString stringWithFormat:@"?isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];
    self.urlSuffix = urlSuffix;
    
    NSString  *urlSuffix2 = [NSString stringWithFormat:@"&isfromapp=1&apptype=1&version=%@&appuid=%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"],[[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserID"]];

    self.urlSuffix2 = urlSuffix2;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:_PushUrl]];
    NSLog(@"push uRL IS %@ version is %@",_PushUrl,urlSuffix);
    [WMAnimations WMNewWebWithScrollView:self.webView.scrollView];
    
 
    [self.webView loadRequest:request];
    [self customRightBarItem];
    
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
    
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(findIsCall) userInfo:nil repeats:YES];
    self.timerr = timer;
    
    //[self setUpleftBarButtonItems];
   // [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // [self Guide];
    
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
//}
#pragma mark - telCall_js
- (void)findIsCall{
    NSString * string = [self.webView stringByEvaluatingJavaScriptFromString:@"getTelForApp()"];
    if (string.length != 0) {
        self.telString = string;
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要拨打电话:%@吗?", string] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
//    if (<#condition#>) {
//        <#statements#>
//    }
    
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
#pragma  -mark VC Life
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBaoStoreNum" attributes:dict];

    [MobClick beginLogPageView:@"ShouKeBaoStoreView"];
    }
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timerr invalidate];
    [self.timer invalidate];
    
    [MobClick endLogPageView:@"ShouKeBaoStoreView"];

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

-(void)turnOff
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)checkCheapPrice{
    if (self.checkCheapBtnOutlet.selected == NO) {
      
      
        
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
    NSLog(@"rightStr is %@--------",rightUrl);
    NSRange range = [rightUrl rangeOfString:_urlSuffix];//带？
     NSRange range2 = [rightUrl rangeOfString:_urlSuffix2];//不带?
    NSRange range3 = [rightUrl rangeOfString:@"?"];

  
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isQQReloadView"];
    
     if (range3.location == NSNotFound && range.location == NSNotFound) {//没有问号，没有问号后缀
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix]]]];
       // return YES;
    }else if (range3.location != NSNotFound && range2.location == NSNotFound ){//有问号没有后缀
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[rightUrl stringByAppendingString:_urlSuffix2]]]];
       // return YES;
    }else{
       
        [_indicator startAnimation];
        return YES;
        
    }
  
      return YES;
}
//

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:NO];
    }else{
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = leftItem;
        
    }

    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isQQReloadView"];

    [_indicator stopAnimationWithLoadText:@"加载成功" withType:YES];
   
    NSString *rightStr = webView.request.URL.absoluteString;
        
    NSLog(@"---------------------rightStr is %@-------------------------",rightStr);

    NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"hideCheapPriceButton()"];
    NSLog(@"---------------------result is %@-------------------------",result);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:rightStr forKey:@"PageUrl"];
 //   [dic setObject:[rightStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"paheUrl"];
    //NSLog(@"uft8转码url是%@",[rightStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
  
    [IWHttpTool WMpostWithURL:@"/Common/GetPageType" params:dic success:^(id json) {
        NSLog(@"-----分享返回数据json is %@------",json);
      //检测当前页面是否有分享内容，有则刷新分享内容，没有则保留上级页面分享内容
        NSDictionary *dicTest = json[@"ShareInfo"];
        NSString *testStr = dicTest[@"Title"];
        if (testStr.length>0) {
            [self.shareArr removeAllObjects];
            NSLog(@"%@", self.shareArr);
            [self.shareArr addObject:json[@"ShareInfo"]];
        }
        if (_needOpenShare) {
            [self shareIt:nil];
        }

        //判断当前页面是否为产品详情页，是则弹出查看同行价，不是则隐藏同行价按钮
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
            [self.timer invalidate];
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
    NSLog(@"-------222222222222--------------result is %@-------------------------",result);//0不隐藏，1隐藏
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

    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ClickShareAll" attributes:dict];

    self.needOpenShare = NO;
   NSDictionary *shareDic = [NSDictionary dictionary];
        shareDic = [StrToDic dicCleanSpaceWithDict:[self.shareArr lastObject]];

 //@"http://r.lvyouquan.cn/KEPicFolder/default/attached/image/20150329/20150329162426_7341.jpg"
    //http://r.lvyouquan.cn/KEPicFolder/default/attached/skbhead/2015-07-10/5a1c7a31-0dca-47a7-9188-a9f12a89243f.jpg
    NSLog(@"shareDic is %@",shareDic);
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareDic[@"Desc"]
                                       defaultContent:shareDic[@"Desc"]
                                                image:[ShareSDK imageWithUrl:shareDic[@"Pic"] ]
                                                title: shareDic[@"Title"]
                                                  url:shareDic[@"Url"]                                          description:shareDic[@"Desc"]
                                            mediaType:SSPublishContentMediaTypeNews];
   
    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@   ,  %@,%@",shareDic[@"Tile"],shareDic[@"Desc"],shareDic[@"Url"]] image:nil];
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", shareDic[@"Url"]]];

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
                                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                                [MobClick event:@"ShouKeBaoStoreShareSuccess" attributes:dict];
                                [MobClick event:@"ShouKeBaoStoreShareSuccessJS" attributes:dict counter:3];
                                [MobClick event:@"ShareSuccessAll" attributes:dict];
                                [MobClick event:@"ShareSuccessAllJS" attributes:dict counter:3];

                                if (state == SSResponseStateSuccess)
                                {
                                    [self.warningLab removeFromSuperview];
                                    
                                    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
                                    [postDic setObject:@"0" forKey:@"ShareType"];
                                    if (shareDic[@"Url"]) {
                                        [postDic setObject:shareDic[@"Url"]  forKey:@"ShareUrl"];
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
                                    } failure:^(NSError *error) {
                                        
                                    }];

                                    //店铺详情
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
                                    [self.warningLab removeFromSuperview];
                                    NSLog( @"shareDic is %@分享失败,错误码:%ld,错误描述:%@",shareDic,(long)[error errorCode], [error errorDescription]);
                                        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                                        [MobClick event:@"ShareFailAll" attributes:dict];
                                }else if (state == SSResponseStateCancel){
                                    [self.warningLab removeFromSuperview];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
