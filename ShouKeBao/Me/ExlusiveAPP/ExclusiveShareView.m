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

//5 只要注册一个观察者 一定要在类的dealloc方法中 移除掉自己的观察者身份在ARC下一样
- (void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

/*只需要在分享按钮事件中 构建好分享内容publishContent传过来就好了*/

+(void)shareWithContent:(id)publishContent backgroundShareView:(id)backgroundShareView andUrl:(NSString *)url{
    
    _publishContent = publishContent;
    _Url = url;

    //  自定义弹出的分享view
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth-20, (300-10-15-10)*KHeight /*kScreenHeight/2.0f-60+20*KHeight_Scale*/)];
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
    
    NSArray *btnImages = @[@"iconfont-kongjian", @"iconfont-qq", @"iconfont-weixin", @"iconfont-pengyouquan", @"iconfont-fuzhi", @"iconfont-duanxin"];
    NSArray *btnTitles = @[@"QQ空间", @"QQ", @"微信好友", @"微信朋友圈", @"复制链接", @"短信"];
    for (NSInteger i=0; i<6; i++) {
        CGFloat top = 0.0f;
        if (i<3) {
            top = 20*KHeight;
            
        }else{
            top = 135*KHeight;
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(35*KWidth_Scale+(i%3)*100*KWidth_Scale, CGRectGetMidY(contentLabel.frame)+top, 100*KWidth_Scale, 100*KHeight)];
        [button setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
        [button setTitle:btnTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        if (i == 1) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 23*KWidth_Scale, 15*KWidth_Scale, 10*KWidth_Scale)];
        }else{
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 20*KWidth_Scale, 15*KWidth_Scale, 10*KWidth_Scale)];
        }
        [button setTitleEdgeInsets:UIEdgeInsetsMake(65*KHeight, -50*KWidth_Scale, 5*KWidth_Scale, 0)];
        button.tag = 331+i;
        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:button];
    }
}

+(void)shareBtnClick:(UIButton *)btn{
    _flag = 0;
//    
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center postNotificationName:@"zzm" object:@"key" userInfo:nil];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:440];
    UIView *shareView = [window viewWithTag:441];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    shareView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.35f animations:^{
        shareView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
        blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
    
    int shareType = 0;
    id publishContent = _publishContent;
    switch (btn.tag) {
        case 331:
        {
            shareType = ShareTypeQQSpace;
        }
            break;
            
        case 332:
        {
            shareType = ShareTypeQQ ;
        }
            break;
            
        case 333:
        {
            shareType =  ShareTypeWeixiSession;
        }
            break;
            
        case 334:
        {
            shareType = ShareTypeWeixiTimeline;
        }
            break;
            
        case 335:
        {
            shareType = ShareTypeCopy;
        }
            break;
            
        case 336:
        {
            shareType = ShareTypeSMS;
        }
            break;
            
        default:
            break;
            
    }
    /*
     调用shareSDK的无UI分享类型 */
    
    [ShareSDK showShareViewWithType:shareType container:[ShareSDK container] content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        if (state == SSResponseStateSuccess){
            
            NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
            [postDic setObject:@"0" forKey:@"ShareType"];
            [postDic setObject:_Url  forKey:@"ShareUrl"];
            [postDic setObject:@"" forKey:@"PageUrl"];
            if (type ==ShareTypeWeixiSession) {
                [postDic setObject:@"1" forKey:@"ShareWay"];
            }else if(type == ShareTypeQQ){
                [postDic setObject:@"2" forKey:@"ShareWay"];
            }else if(type == ShareTypeQQSpace){
                [postDic setObject:@"3" forKey:@"ShareWay"];
            }else if(type == ShareTypeWeixiTimeline){
                [postDic setObject:@"4" forKey:@"ShareWay"];
            }
            NSLog(@"%@", postDic);
            [IWHttpTool postWithURL:@"Common/SaveShareRecord" params:postDic success:^(id json) {
            } failure:^(NSError *error) {
                
            }];
            
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
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
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error errorDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
           
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];
}

//+ (void)cancleBtnClickAction{
//
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center postNotificationName:@"zzm" object:@"key" userInfo:nil];
//    [self cancleBtnClick];
//    
//}
//
//+ (void)cancleBtnClick{
//    
//    [_blackView removeFromSuperview];
//    [_shareView removeFromSuperview];
//    
//}






@end