//
//  ShareView.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/9/28.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ShareView.h"
#import <QuartzCore/QuartzCore.h>
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]

//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f
#define KHeight_Scale    [UIScreen mainScreen].bounds.size.height/667.0f
@implementation ShareView
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
+(void)shareWithContent:(id)publishContent andUrl:(NSString *)url
{
    _publishContent = publishContent;
    _Url = url;
//    _flag = flag;


    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//   暗背景
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-60)];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    blackView.tag = 440;
    [window addSubview:blackView];
    _blackView = blackView;
    
//    多余
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector( cancleBtnClickAction)]; /*cancleBtnClick*/
    [blackView addGestureRecognizer:tap];
    
    
//  自定义弹出的分享view
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2.0f-20*KHeight_Scale, kScreenWidth, kScreenHeight/2.0f-60+20*KHeight_Scale)];
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.tag = 441;
    [window addSubview:shareView];
    _shareView = shareView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, shareView.frame.size.width, 45*KHeight_Scale)];
    titleLabel.text = @"分享";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:25*KWidth_Scale];
    [shareView addSubview:titleLabel];
    
    UIButton *cancleBtn = [[UIButton alloc]init];
    cancleBtn.frame = CGRectMake(kScreenWidth*4/5-10, 10*KHeight_Scale, kScreenWidth/5, 30*KHeight_Scale);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.layer.borderWidth = 1.0;
    cancleBtn.layer.cornerRadius = 4;
    cancleBtn.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
    [cancleBtn setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancleBtn];
    
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cancleBtn.frame), shareView.frame.size.width, 30*KWidth_Scale)];
    contentLabel.text = @"您分享出去的内容对外只显示门市价";
    contentLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:12];
    [shareView addSubview:contentLabel];
    
    NSArray *btnImages = @[@"iconfont-kongjian", @"iconfont-qq", @"iconfont-weixin", @"iconfont-pengyouquan", @"iconfont-fuzhi", @"iconfont-duanxin"];
    NSArray *btnTitles = @[@"QQ空间", @"QQ", @"微信好友", @"微信朋友圈", @"复制链接", @"短信"];
    for (NSInteger i=0; i<6; i++) {
        CGFloat top = 0.0f;
        if (i<3) {
            top = 20*KHeight_Scale;
            
        }else{
            top = 135*KHeight_Scale;
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(35*KWidth_Scale+(i%3)*100*KWidth_Scale, CGRectGetMidY(contentLabel.frame)+top, 100*KWidth_Scale, 100*KHeight_Scale)];
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
//        if (SYSTEM_VERSION >= 8.0f) {
            [button setTitleEdgeInsets:UIEdgeInsetsMake(65*KHeight_Scale, -50*KWidth_Scale, 5*KWidth_Scale, 0)];
//        }else{
//            [button setTitleEdgeInsets:UIEdgeInsetsMake(75*KWidth_Scale, -150*KWidth_Scale, 5*KWidth_Scale, 0)];
//        }
        
        button.tag = 331+i;
        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:button];
    }
//    shareView.transform = CGAffineTransformMakeScale(1/300.0f, 1/270.0f);
//    blackView.alpha = 0;
//    [UIView animateWithDuration:0.35f animations:^{
//        shareView.transform = CGAffineTransformMakeScale(1, 1);
//        blackView.alpha = 1;
//    } completion:^(BOOL finished) {
//        
//    }];
}

+(void)shareBtnClick:(UIButton *)btn
{
    _flag = 0;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"zzm" object:@"key" userInfo:nil];
    
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
     调用shareSDK的无UI分享类型，
     链接地址：http://bbs.mob.com/forum.php?mod=viewthread&tid=110&extra=page%3D1%26filter%3Dtypeid%26typeid%3D34 */
    [ShareSDK showShareViewWithType:shareType container:[ShareSDK container] content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
     
        if (state == SSResponseStateSuccess)
        {
            
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"RecommendShareSuccess" attributes:dict];
            [MobClick event:@"ShareSuccessAll" attributes:dict];
            [MobClick event:@"ShareSuccessAllJS" attributes:dict counter:3];
            [MobClick event:@"RecommendShareSuccessAll" attributes:dict];

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
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"ShareFailAll" attributes:dict];
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];
}

+ (void)cancleBtnClickAction{
//    使用传进来的参数并不好使
//    _flag = 0;
   
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"zzm" object:@"key" userInfo:nil];
    [self cancleBtnClick];
    
}

+ (void)cancleBtnClick{

    [_blackView removeFromSuperview];
    [_shareView removeFromSuperview];
    
}
//+ (void)closeShareView{
//    
//    [_blackView removeFromSuperview];
//    [_shareView removeFromSuperview];
//    
//}




@end
