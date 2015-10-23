//
//  BindPhoneViewController.h
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BackTableViewControllerController.h"

@interface BindPhoneViewController : BackTableViewControllerController

@property (nonatomic,copy) NSString *distributionId;

@property (nonatomic,assign) BOOL isForget;// 判断是否走忘记密码流程

@property (nonatomic,assign) BOOL isModefyPwd;// 判断是否是修改密码的流程

@end
