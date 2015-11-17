    //
//  IWHttpTool.m
//  ItcastWeibo
//
//  Created by apple on 14-5-19.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWHttpTool.h"
#import "AFNetworking.h"
#import "StrToDic.h"
#import "UserInfo.h"

@implementation IWHttpTool

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *normalURL = formalRUL;
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
    [tmp setObject:@"0" forKey:@"ClientSource"];
    [tmp setObject:currentVersion forKey:@"MobileVersion"];
    [tmp setObject:mobileID forKey:@"MobileID"];
    
    NSLog(@"%@", tmp);
    // 分区设置
    if (subStation) {
        [tmp setObject:subStation forKey:@"Substation"];
    }else if (!subStation){
        [tmp setObject:@"10" forKey:@"Substation"];
      //  [APService setTags:[NSSet setWithObject:@"substation_10"] callbackSelector:nil object:nil];
    }
    
    // 取出两个id
    NSString *businessId = [accoutDefault objectForKey:UserInfoKeyBusinessID];
    NSString *distributionId = [accoutDefault objectForKey:UserInfoKeyDistributionID];
    NSString *appUserId = [accoutDefault objectForKey:UserInfoKeyAppUserID];
    NSLog(@"%@", appUserId);
    // 判断这三个个是否空
    [tmp setObject:businessId ? businessId : @"" forKey:@"BusinessID"];
    [tmp setObject:distributionId ? distributionId : @"" forKey:@"DistributionID"];
    [tmp setObject:appUserId ? appUserId : @"" forKey:@"AppUserID"];
    
    // 取出logintype
    NSString *loginType = [accoutDefault objectForKey:UserInfoKeyLoginType];
    [tmp setObject:loginType ? loginType : @"0" forKey:@"LoginType"];
    
    // 拼接所有参数
    [tmp addEntriesFromDictionary:params];
   
    NSLog(@"-------url:%@",overStr);
    NSLog(@"%@", tmp);
    NSLog(@"~~~~~~~~~~~~~~~~~~param:%@~~~~~~~~~~~~~~~~~~",[StrToDic jsonStringWithDicL:tmp]);
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [mgr POST:overStr parameters:tmp
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}


+ (void)postForRecommendWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *normalURL = formalRUL;
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
    NSString *businessId = [accoutDefault objectForKey:UserInfoKeyBusinessID];
    NSString *distributionId = [accoutDefault objectForKey:UserInfoKeyDistributionID];
    NSString *appUserId = [accoutDefault objectForKey:UserInfoKeyAppUserID];
    
    // 判断这三个个是否空
    [tmp setObject:businessId ? businessId : @"" forKey:@"BusinessID"];
    [tmp setObject:distributionId ? distributionId : @"" forKey:@"DistributionID"];
    [tmp setObject:appUserId ? appUserId : @"" forKey:@"AppUserID"];
    
    // 取出logintype
    NSString *loginType = [accoutDefault objectForKey:UserInfoKeyLoginType];
    [tmp setObject:loginType ? loginType : @"0" forKey:@"LoginType"];
    
    // 拼接所有参数
    [tmp addEntriesFromDictionary:params];
    
    NSLog(@"-------url:%@",overStr);
    NSLog(@"~~~~~~~~~~~~~~~~~~param:%@~~~~~~~~~~~~~~~~~~",[StrToDic jsonStringWithDicL:tmp]);
    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [mgr POST:overStr parameters:tmp
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];

}




+ (void)WMpostWithURL:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
//    NSString *normalURL = formalRUL;
//    NSString *overStr = [normalURL stringByAppendingString:url];
//    
//    //组dic
//    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//    
//    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
//    
//    NSString *mobileID = [[UIDevice currentDevice].identifierForVendor UUIDString];
//  
//    NSUserDefaults *accoutDefault=[NSUserDefaults standardUserDefaults];
//    NSString *subStation =  [accoutDefault stringForKey:@"Substation"];
//    NSLog(@"---------subStation is %@-------",subStation);
//    //ClientSource 0其他，无需
//    
//    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
//    [tmp setObject:@"1" forKey:@"MobileType"];
//    [tmp setObject:currentVersion forKey:@"MobileVersion"];
//    [tmp setObject:mobileID forKey:@"MobileID"];
//    if (subStation) {
//        [tmp setObject:subStation forKey:@"Substation"];
//    }else if (!subStation){
//        [tmp setObject:@"10" forKey:@"Substation"];
//       // [APService setTags:[NSSet setWithObject:@"substation_10"] callbackSelector:nil object:nil];
//
//    }
//    
//    NSString *businessId = [accoutDefault objectForKey:@"BusinessID"];
//    NSString *distributionId = [accoutDefault objectForKey:@"DistributionID"];
//    if (businessId || distributionId) {
//        [tmp setObject:businessId forKey:@"BusinessID"];
//        [tmp setObject:distributionId forKey:@"DistributionID"];
//    }
//    
//    NSString *loginType = [accoutDefault objectForKey:@"LoginType"];
//    if (loginType) {
//        [tmp setObject:loginType forKey:@"LoginType"];
//    }
//
//    [tmp addEntriesFromDictionary:params];
//    
//    NSLog(@"-------url:%@",overStr);
//    NSLog(@"~~~~~~~param:%@",tmp);
//
//    
//    NSString *jsonStr = [StrToDic jsonStringWithDicL:tmp];
//    NSLog(@"--------------------jsonStr is %@------------",jsonStr);
//    // 1.创建请求管理对象
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
//    [mgr POST:overStr parameters:tmp
//      success:^(AFHTTPRequestOperation *operation, id responseObject) {
//          
//          if (success) {
//              success(responseObject);
//          }
//      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//          if (failure) {
//              failure(error);
//          }
//      }];
    
    NSString *normalURL = formalRUL;
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
    NSString *businessId = [accoutDefault objectForKey:UserInfoKeyBusinessID];
    NSString *distributionId = [accoutDefault objectForKey:UserInfoKeyDistributionID];
    NSString *appUserId = [accoutDefault objectForKey:UserInfoKeyAppUserID];
    
    // 判断这三个个是否空
    [tmp setObject:businessId ? businessId : @"" forKey:@"BusinessID"];
    [tmp setObject:distributionId ? distributionId : @"" forKey:@"DistributionID"];
    [tmp setObject:appUserId ? appUserId : @"" forKey:@"AppUserID"];
    
    // 取出logintype
    NSString *loginType = [accoutDefault objectForKey:UserInfoKeyLoginType];
    [tmp setObject:loginType ? loginType : @"0" forKey:@"LoginType"];
    
    // 拼接所有参数
    [tmp addEntriesFromDictionary:params];
    NSLog(@"parms = %@", params);
    NSLog(@"-------url:%@",overStr);
    NSLog(@"~~~~~~~~~~~~~~~~~~param:%@~~~~~~~~~~~~~~~~~~",[StrToDic jsonStringWithDicL:tmp]);

    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [mgr POST:overStr parameters:tmp
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    NSString *normalURL = formalRUL;
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
    NSString *businessId = [accoutDefault objectForKey:UserInfoKeyBusinessID];
    NSString *distributionId = [accoutDefault objectForKey:UserInfoKeyDistributionID];
    NSString *appUserId = [accoutDefault objectForKey:UserInfoKeyAppUserID];
    
    // 判断这三个个是否空
    [tmp setObject:businessId ? businessId : @"" forKey:@"BusinessID"];
    [tmp setObject:distributionId ? distributionId : @"" forKey:@"DistributionID"];
    [tmp setObject:appUserId ? appUserId : @"" forKey:@"AppUserID"];
    
    // 取出logintype
    NSString *loginType = [accoutDefault objectForKey:UserInfoKeyLoginType];
    [tmp setObject:loginType ? loginType : @"0" forKey:@"LoginType"];
    
    // 拼接所有参数
    [tmp addEntriesFromDictionary:params];
    
    NSLog(@"-------url:%@",overStr);
    NSLog(@"~~~~~~~param:%@",tmp);
    

    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

    mgr.requestSerializer = [AFJSONRequestSerializer serializer];

    // 2.发送请求
    [mgr POST:url parameters:tmp constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
        for (IWFormData *formData in formDataArray) {
            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

////发送图片
//+(void)postDataWithURL:(NSString *)url params:(NSDictionary *)params UIImage:(image *)image success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
//    // 1.请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//     mgr.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSString *normalURL = kWebTestHost;
//    NSString *overStr = [normalURL stringByAppendingString:url];
//    
//    //组dic
//    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
//    NSString *mobileID = [[UIDevice currentDevice].identifierForVendor UUIDString];
//    //ClientSource 0其他，无需
//    
//    NSUserDefaults *accoutDefault=[NSUserDefaults standardUserDefaults];
//    NSString *subStation =  [accoutDefault stringForKey:@"Substation"];
//    NSLog(@"---------subStation is %@-------",subStation);
//    
//    // 基本参数
//    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
//    [tmp setObject:@"1" forKey:@"MobileType"];
//    [tmp setObject:currentVersion forKey:@"MobileVersion"];
//    [tmp setObject:mobileID forKey:@"MobileID"];
//    
//    // 分区设置
//    if (subStation) {
//        [tmp setObject:subStation forKey:@"Substation"];
//    }else if (!subStation){
//        [tmp setObject:@"10" forKey:@"Substation"];
//        //  [APService setTags:[NSSet setWithObject:@"substation_10"] callbackSelector:nil object:nil];
//    }
//    
//    // 取出两个id
//    NSString *businessId = [accoutDefault objectForKey:UserInfoKeyBusinessID];
//    NSString *distributionId = [accoutDefault objectForKey:UserInfoKeyDistributionID];
//    NSString *appUserId = [accoutDefault objectForKey:UserInfoKeyAppUserID];
//    
//    // 判断这三个个是否空
//    [tmp setObject:businessId ? businessId : @"" forKey:@"BusinessID"];
//    [tmp setObject:distributionId ? distributionId : @"" forKey:@"DistributionID"];
//    [tmp setObject:appUserId ? appUserId : @"" forKey:@"AppUserID"];
//    
//    // 取出logintype
//    NSString *loginType = [accoutDefault objectForKey:UserInfoKeyLoginType];
//    [tmp setObject:loginType ? loginType : @"0" forKey:@"LoginType"];
//    
//    // 拼接所有参数
//    [tmp addEntriesFromDictionary:params];
//
//    
//    // 3.发送请求
//    [mgr POST:overStr parameters:tmp constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        // 拼接文件数据
//                NSData *data = UIImageJPEGRepresentation(image, 1.0);
//        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
//    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//        
//        success(responseObject);
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//       
//    }];
//
//}



+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr GET:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}


@end

/**
 *  用来封装文件数据的模型
 */
@implementation IWFormData

@end
