//
//  LoginTool.h
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWHttpTool.h"

@interface LoginTool : NSObject

/**
 *  请求登录
 */
+ (void)loginWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  同步请求登录
 */
+ (void)syncLoginWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  获取商户和商户分销人信息
 */
+ (void)getDistributionListWithSuccess:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  获取验证码
 */
+ (void)getCodeWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  绑定手机
 */
+ (void)bindPhoneWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

@end
