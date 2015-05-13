//
//  SetPhonePwdViewController.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/5/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BackTableViewControllerController.h"

@interface SetPhonePwdViewController : BackTableViewControllerController

@property (nonatomic,assign) BOOL isForget;// 判断是否走忘记密码流程

@property (nonatomic,assign) BOOL isModefyPwd;// 判断是否是修改密码的流程

@property (nonatomic,copy) NSString *phoneNum;

@end
