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
#import "APService.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setTabbarRoot;

- (void)setLoginRoot;

@end

