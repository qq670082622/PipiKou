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
@interface ProduceDetailViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) NSMutableDictionary *shareInfo;

@property (nonatomic,assign) int webLoadCount;
@property (nonatomic,strong) NSMutableArray *webUrlArr;
@end

@implementation ProduceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品详情";
       NSLog(@"--------link is %@ ",_produceUrl);
    
    [self.webUrlArr addObject:_produceUrl];
self.webLoadCount = 1;
    
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:_produceUrl]]];
  

    [self customRightBarItem];
  
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
    
    
    
}
-(NSMutableArray *)webUrlArr
{
    if (_webUrlArr == nil) {
        self.webUrlArr = [NSMutableArray array];
    }
    return _webUrlArr;
}

-(void)back
{
    
    if (self.webUrlArr.count >2) {
        
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[self.webUrlArr objectAtIndex:self.webUrlArr.count - 2]]]];
        [self.webUrlArr removeLastObject];
    }
    
    else if (self.webUrlArr.count == 2) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    NSLog(@"返回后arr.count is %lu",(unsigned long)self.webUrlArr.count);

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
    [button addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem= barItem;
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rightStr = request.URL.absoluteString;

    
    if ((![rightStr isEqualToString:[_webUrlArr lastObject]]) && (rightStr.length>8) && (![rightStr isEqualToString:_produceUrl])) {
        [self.webUrlArr addObject:rightStr];
    }
    NSLog(@"即将加载的页面是%@  arr.count is %lu",rightStr,(unsigned long)[self.webUrlArr count]);
    
    return YES;
}

-(void)showAlert
{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [accountDefaults stringForKey:@"shareCount"];
    
    if ([account intValue]<3){
        
        NSString *newCount =  [NSString stringWithFormat:@"%d",[account intValue]+1];
        [accountDefaults setObject:newCount forKey:@"shareCount"];
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"分享产品" message:@"您分享出去的产品对外只显示门市价" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
    }

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
 NSString *rightUrl = webView.request.URL.absoluteString;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:rightUrl forKey:@"PageUrl"];
    // [self.shareInfo removeAllObjects];
    
    [IWHttpTool WMpostWithURL:@"/Common/GetPageType" params:dic success:^(id json) {
        
        NSLog(@"-----分享返回数据json is %@------",json);
        
        self.shareInfo = json[@"ShareInfo"];
    } failure:^(NSError *error) {
        
        NSLog(@"分享请求数据失败，原因：%@",error);
        
    }];

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

    
//  //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:self.shareInfo[@"Desc"]
//                                       defaultContent:@"旅游圈，匹匹扣"
//                                                image:[ShareSDK imageWithUrl:self.shareInfo[@"Pic"]]
//                                                title:self.shareInfo[@"Title"]
//                                                  url:self.shareInfo[@"Url"]
//                                          description:self.shareInfo[@"Desc"]
//                                            mediaType:SSPublishContentMediaTypeNews];
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:sender  arrowDirect:UIPopoverArrowDirectionUp];
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    
//                                   [MBProgressHUD showSuccess:@"分享成功"];
//                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
//                                        [MBProgressHUD hideHUD];
//                                    });
//
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                }
//                            }];
//    
    
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
