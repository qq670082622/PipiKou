//
//  AppDelegate+Extend.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Extend)

-(void)setStartAnamation;


//每次从后台进到前台的生命周期里，调用一下登录接口；
- (void)loginApp;
@end
