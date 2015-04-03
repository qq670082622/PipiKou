//
//  UserInfo.h
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

+ (UserInfo *)shareUser;

@property (nonatomic,copy) NSString *BusinessID;// 商家id

@property (nonatomic,copy) NSString *DistributionID;// 分销人id

@property (nonatomic,copy) NSString *loginType;// 1 旅行社 2 分销人

@property (nonatomic,copy) NSString *userName; // 账号昵称

@property (nonatomic,copy) NSString *account;// 账号

+ (instancetype)userInfoWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
