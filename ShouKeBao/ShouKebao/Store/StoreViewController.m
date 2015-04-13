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

@interface StoreViewController ()<UIWebViewDelegate>
@property (nonatomic,copy) NSMutableString *shareUrl;
@property (weak, nonatomic) IBOutlet UIButton *checkCheapBtnOutlet;
- (IBAction)checkCheapPrice:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *cheapPrice;
@property (weak, nonatomic) IBOutlet UILabel *profit;
@property (weak, nonatomic) IBOutlet UIButton *jiafan;
@property (weak, nonatomic) IBOutlet UIButton *quan;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (nonatomic,strong) NSMutableDictionary *shareDic;
@property (weak, nonatomic) IBOutlet UIView *btnLine;

@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:_PushUrl]];
    [self.webView loadRequest:request];
    [self customRightBarItem];
    
}
-(void)customRightBarItem
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [button setImage:[UIImage imageNamed:@"APPfenxiang"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(shareIt:)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem= barItem;
    

    
}
-(NSMutableDictionary *)shareDic
{
    if (_shareDic == nil) {
        self.shareDic = [NSMutableDictionary dictionary];
    }
    return _shareDic;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rightStr = request.URL.absoluteString;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:rightStr forKey:@"PageUrl"];
    [IWHttpTool WMpostWithURL:@"/Common/GetPageType" params:dic success:^(id json) {
        NSLog(@"-----分享返回数据json is %@------",json);
        if ([json[@"PageType"] isEqualToString:@"0"]) {
           
            self.shareDic = json[@"ShareInfo"];
        }
        else if ([json[@"PageType"] isEqualToString:@"2" ]){
            self.checkCheapBtnOutlet.hidden = NO;
            self.btnLine.hidden = NO;
            NSMutableString *productID = [NSMutableString string];
            productID = json[@"ProductID"];
            NSMutableDictionary *dic =[NSMutableDictionary dictionary];
            [dic setObject:productID forKey:@"ProductID"];
            [IWHttpTool WMpostWithURL:@"/Product/GetProductByID" params:dic success:^(id json) {
                NSLog(@"产品详情json is %@",json);
                NSString *testStr = json[@"Product"][@"PersonPeerPrice"];
                if (testStr!=nil || testStr != NULL ) {
                    self.cheapPrice.text = json[@"Product"][@"PersonPeerPrice"];
                    self.profit.text = json[@"Product"][@"PersonProfit"];
                    [self.jiafan setTitle:json[@"Product"][@"PersonBackPrice"] forState:UIControlStateNormal];
                    [self.quan setTitle:json[@"Product"][@"PersonCashCoupon"] forState:UIControlStateNormal];
                }
                else if (testStr == nil && testStr == NULL)
                {
                    self.checkCheapBtnOutlet.hidden  = YES;
                }
            } failure:^(NSError *error) {
                NSLog(@"同行价网络请求失败,%@",error);
            }];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"分享请求数据失败，原因：%@",error);
    }];
    
    return YES;
}
#pragma 筛选navitem
-(void)shareIt:(id)sender
{
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:self.shareDic[@"Title"]
                                       defaultContent:self.shareDic[@"Desc"]
                                                image:[ShareSDK imageWithUrl:self.shareDic[@"Pic"]]
                                                title:self.shareDic[@"Title"]
                                                  url:self.shareDic[@"Url"]                                          description:self.shareDic[@"Desc"]
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



- (IBAction)checkCheapPrice:(id)sender {
    if (self.checkCheapBtnOutlet.selected == NO) {
        [self.checkCheapBtnOutlet setSelected:YES];
        self.subView.hidden = NO;
    }else if (self.checkCheapBtnOutlet.selected == YES){
        [self.checkCheapBtnOutlet setSelected:NO];
        self.subView.hidden = YES;
    }
    
}
@end
