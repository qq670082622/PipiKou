//
//  ExclusiveShareView.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ExclusiveShareView.h"
#import <QuartzCore/QuartzCore.h>
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MobClick.h"
#import "ExclusiveViewController.h"

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]

//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f
#define KHeight_Scale    [UIScreen mainScreen].bounds.size.height/480.0f
#define KHeight    [UIScreen mainScreen].bounds.size.height/667.0f

@implementation ExclusiveShareView

static id _publishContent;
static id _Url;
static id _blackView;
static id _shareView;
static bool _flag;
static id _naVC;

//5 只要注册一个观察者 一定要在类的dealloc方法中 移除掉自己的观察者身份在ARC下一样
- (void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

/*只需要在分享按钮事件中 构建好分享内容publishContent传过来就好了*/

+(void)shareWithContent:(id)publishContent backgroundShareView:(id)backgroundShareView naVC:(id)naVC andUrl:(NSString *)url{
    
    _publishContent = publishContent;
    _Url = url;
    _naVC = naVC;

    //  自定义分享view
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth-20, 260/*(300-10-15-10)*KHeight */ /*kScreenHeight/2.0f-60+20*KHeight_Scale*/)];
    shareView.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1];
    shareView.tag = 441;
    [backgroundShareView addSubview:shareView];
    _shareView = shareView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, -10, shareView.frame.size.width-180, 25*KHeight)];
    titleLabel.backgroundColor = [UIColor colorWithRed:251/255.0f green:78/255.0f blue:10/255.0f alpha:1];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"怎么享受这些好处？";
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.cornerRadius = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15*KWidth_Scale];
    [shareView addSubview:titleLabel];
    
    
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame), shareView.frame.size.width-40, 50*KHeight)];
    contentLabel.text = @"非常简单，让尽可能多的客人，安装您的专属App，立即行动，转发安装链接";
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:12];
    [shareView addSubview:contentLabel];
    
    NSArray *btnImages = @[@"iconfont-qq", @"iconfont-pengyouquan", @"iconfont-weixin",  @"iconfont-duanxin", @"iconfont-fuzhi", @"iconfont-kongjian"];
    NSArray *btnTitles = @[@"QQ", @"朋友圈",  @"微信好友", @"短信", @"复制链接", @"QQ空间"];
    for (NSInteger i=0; i<6; i++) {
        CGFloat top = 0.0f;
        if (i<3) {
            if (KHeight > 1 || KHeight == 1) {
                top = 20*KHeight;
            }else{
                top = 30*KHeight;
            }
        }else{
            if (KHeight > 1 || KHeight == 1) {
                top = 120*KHeight;
            }else{
                 top = 150*KHeight;
            }
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30*KWidth_Scale+(i%3)*100*KWidth_Scale, CGRectGetMidY(contentLabel.frame)+top, 100*KWidth_Scale, 100*KWidth_Scale)];
        [button setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
        [button setTitle:btnTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        if (i == 1) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 23*KWidth_Scale, 15*KWidth_Scale, 10*KWidth_Scale)];
        }else{
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 23*KWidth_Scale, 15*KWidth_Scale, 10*KWidth_Scale)];
        }
        
        if (KHeight > 1) {
             [button setTitleEdgeInsets:UIEdgeInsetsMake(53*KWidth_Scale, -42*KWidth_Scale, 10*KWidth_Scale, 0)];
        }else{
             [button setTitleEdgeInsets:UIEdgeInsetsMake(68*KWidth_Scale, -47*KWidth_Scale, 10*KWidth_Scale, 0)];
        }
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)]
        button.tag = 331+i;
        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:button];
    }
}

+(void)shareBtnClick:(UIButton *)btn{
    int shareType = 0;
    id publishContent = _publishContent;
    switch (btn.tag) {
        case 331:
        {
            shareType = ShareTypeQQ;
        }
            break;
            
        case 332:
        {
            shareType =  ShareTypeWeixiTimeline;
        }
            break;
            
        case 333:
        {
            shareType =  ShareTypeWeixiSession;
        }
            break;
            
        case 334:
        {
            shareType = ShareTypeSMS;
        }
            break;
            
        case 335:
        {
            shareType = ShareTypeCopy;
        }
            break;
            
        case 336:
        {
            shareType = ShareTypeQQSpace;
        }
            break;
            
        default:
            break;
            
    }
    /*
     调用shareSDK的无UI分享类型 */
    
    [ShareSDK showShareViewWithType:shareType container:[ShareSDK container] content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        if (state == SSResponseStateSuccess){
            
            if (type ==ShareTypeWeixiSession) {

            }else if(type == ShareTypeQQ){

            }else if(type == ShareTypeQQSpace){

            }else if(type == ShareTypeWeixiTimeline){

            }
            
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
            if (type == ShareTypeCopy) {
                [MBProgressHUD showSuccess:@"复制成功"];
            }else{
                [MBProgressHUD showSuccess:@"分享成功"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                [MBProgressHUD hideHUD];
            });
            
            
            ExclusiveViewController *exclusiveVC = [[ExclusiveViewController alloc]init];
            [_naVC pushViewController:exclusiveVC animated:YES];
            
            
        }
        else if (state == SSResponseStateFail)
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error errorDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
           
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];
}






@end
