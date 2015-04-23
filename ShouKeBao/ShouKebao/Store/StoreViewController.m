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
@interface StoreViewController ()<UIWebViewDelegate>
@property (nonatomic,copy) NSMutableString *shareUrl;
@property (weak, nonatomic) IBOutlet UIButton *checkCheapBtnOutlet;
- (IBAction)checkCheapPrice:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *cheapPrice;
@property (weak, nonatomic) IBOutlet UILabel *profit;
@property (weak, nonatomic) IBOutlet UILabel *jiafan;
@property (weak, nonatomic) IBOutlet UILabel *quan;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (nonatomic,strong) NSMutableDictionary *shareDic;

@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIView *btnLine;
@property (weak,nonatomic)  IBOutlet UILabel *offLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;


@property (nonatomic,assign) int webLoadCount;
@property (nonatomic,strong) NSMutableArray *webUrlArr;
@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺详情";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:_PushUrl]];
    [self.webUrlArr addObject:_PushUrl];
    self.webLoadCount = 1;

    [self.webView loadRequest:request];
    [self customRightBarItem];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
}

-(void)back
{
    if (self.webUrlArr.count >1) {
        
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[self.webUrlArr objectAtIndex:self.webUrlArr.count - 2]]]];
        [self.webUrlArr removeLastObject];
    }
    
    else if (self.webUrlArr.count == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    NSLog(@"返回后arr.count is %lu",(unsigned long)self.webUrlArr.count);
}

-(NSMutableArray *)webUrlArr
{
    if (_webUrlArr == nil) {
        self.webUrlArr = [NSMutableArray array];
    }
    return _webUrlArr;
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
    if ((![rightStr isEqualToString:[_webUrlArr lastObject]]) && (rightStr.length>8) && (![rightStr isEqualToString:_PushUrl])) {
        [self.webUrlArr addObject:rightStr];
    }
    NSLog(@"即将加载的页面是%@  arr.count is %lu",rightStr,(unsigned long)[self.webUrlArr count]);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:rightStr forKey:@"PageUrl"];
    [IWHttpTool WMpostWithURL:@"/Common/GetPageType" params:dic success:^(id json) {
        NSLog(@"-----分享返回数据json is %@------",json);
        if ([json[@"PageType"] isEqualToString:@"0"]) {
            self.checkCheapBtnOutlet.hidden = YES;
           self.blackView.alpha = 0;
            self.btnLine.hidden = YES;
            self.shareDic = json[@"ShareInfo"];
            self.title = @"店铺详情";
        }
        else if ([json[@"PageType"] isEqualToString:@"2"]){
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
                if (personPrice.length>2) {
                  
                    self.cheapPrice.text = [NSString stringWithFormat:@"￥%@",json[@"Product"][@"PersonPeerPrice"]];
                    self.profit.text = [NSString stringWithFormat:@"￥%@",json[@"Product"][@"PersonProfit"]];
                   
                    self.jiafan.text = [NSString stringWithFormat:@"￥%@",json[@"Product"][@"PersonBackPrice"]];
                   
                    self.quan.text = [NSString stringWithFormat:@"￥%@",json[@"Product"][@"PersonCashCoupon"]];
                
                }else if (personPrice.length<3){
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
    
    return YES;
}
//
-(void)showAlert
{
    UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"分享产品" message:@"您分享出去的产品对外只显示门市价" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        [self shareIt ];
//    }
//}

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
        self.blackView.alpha = 0.5;
    }else if (self.checkCheapBtnOutlet.selected == YES){
        [self.checkCheapBtnOutlet setSelected:NO];
        self.subView.hidden = YES;
        self.blackView.alpha = 0;
    }
    
}

@end
