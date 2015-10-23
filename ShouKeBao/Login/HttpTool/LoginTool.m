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
 *  旅行社登录
 */
+ (void)travelLoginWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Business/LoginDistributor" params:param success:^(id json) {
        
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
 *  绑定手机密码
 */
+ (void)bindPhonePwdWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Business/CreateLoginPassword" params:param success:^(id json) {
        
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
    NSString *normalURL = formalRUL;
    NSString *url = @"Business/LoginQuick";
    NSString *overStr = [normalURL stringByAppendingString:url];
    
    //组dic
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *mobileID = [[UIDevice currentDevice].identifierForVendor UUIDString];
    //ClientSource 0其他，无需
    
    NSUserDefaults *accoutDefault=[NSUserDefaults standardUserDefaults];
    NSString *subStation =  [accoutDefault stringForKey:@"Substation"];
    NSLog(@"---------subStation is %@-------",subStation);
    
    // 基本参数
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    [tmp setObject:@"1" forKey:@"MobileType"];
    [tmp setObject:currentVersion forKey:@"MobileVersion"];
    [tmp setObject:mobileID forKey:@"MobileID"];
    
    // 分区设置
    if (subStation) {
        [tmp setObject:subStation forKey:@"Substation"];
    }else if (!subStation){
        [tmp setObject:@"10" forKey:@"Substation"];
        //  [APService setTags:[NSSet setWithObject:@"substation_10"] callbackSelector:nil object:nil];
    }
    
    // 取出两个id
    NSString *businessId = [accoutDefault objectForKey:@"BusinessID"];
    NSString *distributionId = [accoutDefault objectForKey:@"DistributionID"];
    
    // 判断这两个是否空
    [tmp setObject:businessId ? businessId : @"" forKey:@"BusinessID"];
    [tmp setObject:distributionId ? distributionId : @"" forKey:@"DistributionID"];
    
    // 取出logintype
    NSString *loginType = [accoutDefault objectForKey:@"LoginType"];
    [tmp setObject:loginType ? loginType : @"0" forKey:@"LoginType"];
    
    [tmp addEntriesFromDictionary:param];
    
    NSLog(@"-------url:%@",overStr);
    NSLog(@"~~~~~~~param:%@",tmp);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:overStr]];
    NSString *json = [StrToDic jsonStringWithDicL:tmp];
    request.HTTPBody = [json dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10;
    
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
 *  获取验证码
 */
+ (void)getCodeWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Common/GetMobileCaptche" params:param success:^(id json) {
        
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
 *  检查验证码
 */
+ (void)checkCodeWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Common/ValidateMobileCaptche" params:param success:^(id json) {
        
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
 *  获取分销人和旅行社列表
 */
+ (void)getUserListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Business/GetSkbList" params:param success:^(id json) {
        
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
 *  选择分销人或者旅行社
 */
+ (void)chooseUserWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Business/BindingSkb" params:param success:^(id json) {
        
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
 *  常规登录
 */
+ (void)regularLoginWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"Business/LoginQuick" params:param success:^(id json) {
        
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
 *  开通个人收客宝
 */
+ (void)createDistributionWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"Business/CreateDistribution" params:param success:^(id json) {
        
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
 *  创建收客宝
 */
+ (void)applyOpenSkbWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"Business/ApplyOpenSkb" params:param success:^(id json) {
        
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
 *  创建收客宝的上传头像
 */
+ (void)uploadHeadWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"File/UploadPicture" params:param success:^(id json) {
        
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
 *  绑定手机第二种逻辑
 */
+ (void)bindMobileAndCreateUserWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"Business/BindMobileAndCreateUser" params:param success:^(id json) {
        
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
 *  设置手机密码第二种逻辑
 */
+ (void)setLoginPasswordWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"Business/SetLoginPassword" params:param success:^(id json) {
        
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
