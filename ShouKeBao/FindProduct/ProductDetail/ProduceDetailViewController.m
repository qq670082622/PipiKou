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
@interface ProduceDetailViewController ()
@property(copy,nonatomic)NSMutableString *shareStr;


@end

@implementation ProduceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:_produceUrl]];
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
#pragma 筛选navitem
-(void)shareIt:(id)sender
{
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.produceUrl forKey:@"PageUrl"];
    [IWHttpTool WMpostWithURL:@"/Common/GetPageType" params:dic success:^(id json) {
       // NSLog(@"-----分享返回数据json is %@------",json);
       self.shareStr =  [NSMutableString stringWithFormat:@"%@",json[@"ShareUrl"]];
    } failure:^(NSError *error) {
        NSLog(@"分享请求数据失败，原因：%@",error);
    }];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"lvyouquanIcon" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:self.productName
                                       defaultContent:@"旅游圈，匹匹扣"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"旅游圈，匹匹扣"
                                                  url:self.shareStr
                                          description:@"旅游圈，匹匹扣"
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



@end
