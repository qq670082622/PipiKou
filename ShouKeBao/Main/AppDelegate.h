//
//  AppDelegate.h
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import "IChatManagerDelegate.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, IChatManagerDelegate>
{
    EMConnectionState _connectionState;
}


@property (strong, nonatomic) UIWindow *window;

// 切换到主界面
- (void)setTabbarRoot;

// 常规登录
- (void)setLoginRoot;

// 登录旅行社账号
- (void)setTravelLoginRoot;

//圈口令
- (void)checkProductOrder;
@end

