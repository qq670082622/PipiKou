//
//  UserInfo.h
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>


#define UserInfoKeyBusinessID @"BusinessID"


//环信账号密码
#define UserInfoKeyAppUserID @"AppUserID"
#define UserInfoKeyEasemobPassWord @"EasemobPassWord"



#define UserInfoKeyPoneNum @"PhoneNum"
#define UserInfoKeyPassword @"Password"
#define UserInfoKeyLoginType @"LoginType"
#define UserInfoKeyDistributionID @"DistributionID"
#define UserInfoKeySubstation @"Substation"
#define UserInfoKeyLoginAvatar @"LoginAvatar"
#define UserInfoKeyAccount @"Account"
#define UserInfoKeyAccountPassword @"AccountPassword"

//旅游顾问
#define UserInfoKeyLYGWLevel @"LYGWGrade" //等级
#define UserInfoKeyLYGWLinkUrl @"LYGWLinkUrl" //链接
#define UserInfoKeyLYGWPosition @"LYGWPosition" //职位
#define UserInfoKeyLYGWPhoneNum @"LYGWPhone" //电话
#define UserInfoKeyLYGWIsOpenVIP @"LVGWIsOpenVIP"//是否开通银牌以上顾问
#define UserInfoKeyIsShowQuanTouTiao @"IsShowQuanTouTiao"
#define IsShowInvoiceManage @"IsShowInvoiceManage"
#import "BaseModel.h"
@interface UserInfo : BaseModel

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

+ (BOOL)isOnlineUserWithBusinessID:(NSString *)bussinessID;


@end
