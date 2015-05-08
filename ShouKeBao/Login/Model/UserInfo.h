//
//  UserInfo.h
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>


#define UserInfoKeyBusinessID @"BusinessID"
#define UserInfoKeyAppUserID @"AppUserID"
#define UserInfoKeyPoneNum @"PhoneNum"
#define UserInfoKeyPassword @"Password"
#define UserInfoKeyLoginType @"LoginType"
#define UserInfoKeyDistributionID @"DistributionID"
#define UserInfoKeySubstation @"Substation"
#define UserInfoKeyLoginAvatar @"LoginAvatar"
#define UserInfoKeyAccount @"Account"

@interface UserInfo : NSObject

+ (UserInfo *)shareUser;

@property (nonatomic,copy) NSString *BusinessID;// 商家id

@property (nonatomic,copy) NSString *DistributionID;// 分销人id

@property (nonatomic,copy) NSString *loginType;// 1 旅行社 2 分销人

@property (nonatomic,copy) NSString *userName; // 账号昵称

@property (nonatomic,copy) NSString *account;// 账号

@property (nonatomic,copy) NSString *phoneNum;// 手机号码

@property (nonatomic,copy) NSString *LoginAvatar;// 登录界面的头像

@property (nonatomic,copy) NSString *pushMode; // 0关闭免打扰 1开启免打扰

@property (nonatomic,copy) NSString *sosMobile; // 专属客服电话

+ (instancetype)userInfoWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
