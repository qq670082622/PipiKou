//
//  LoginTool.m
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "LoginTool.h"
#import "IWHttpTool.h"
#import "UserInfo.h"
#import "StrToDic.h"
#import <UIKit/UIKit.h>

@implementation LoginTool

/**
 *  请求登录
 */
+ (void)loginWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Business/Login" params:param success:^(id json) {
        
        if (success) {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

/**
 *  同步请求登录
 */
+ (void)syncLoginWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    NSString *normalURL = kWebServiceHost;
    NSString *url = @"Business/Login";
    NSString *overStr = [normalURL stringByAppendingString:url];
    
    //组dic
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *mobileID = [[UIDevice currentDevice].identifierForVendor UUIDString];
    //ClientSource 0其他，无需
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    [tmp setObject:@"1" forKey:@"MobileType"];
    [tmp setObject:currentVersion forKey:@"MobileVersion"];
    [tmp setObject:mobileID forKey:@"MobileID"];
    if ([UserInfo shareUser].BusinessID) {
        [tmp setObject:[UserInfo shareUser].BusinessID forKey:@"BusinessID"];
        [tmp setObject:[UserInfo shareUser].DistributionID forKey:@"DistributionID"];
    }
    [tmp addEntriesFromDictionary:param];
    
    NSLog(@"-------url:%@",overStr);
    NSLog(@"~~~~~~~param:%@",tmp);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:overStr]];
    NSString *json = [StrToDic jsonStringWithDicL:tmp];
    request.HTTPBody = [json dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        success(json);
    }else{
        NSError *error = [[NSError alloc] init];
        failure(error);
    }
}

/**
 *  获取商户和商户分销人信息
 */
+ (void)getDistributionListWithSuccess:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *param = @{};
    [IWHttpTool postWithURL:@"Business/GetDistributionList" params:param success:^(id json) {
        
        if (success) {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

/**
 *  获取验证码
 */
+ (void)getCodeWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Business/GetMobileVerificationCode" params:param success:^(id json) {
        
        if (success) {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

/**
 *  绑定手机
 */
+ (void)bindPhoneWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Business/DistributionBind" params:param success:^(id json) {
        
        if (success) {
            success(json);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

@end
