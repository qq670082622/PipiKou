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
    NSString *normalURL = kWebServiceHost;
    NSString *overStr = [normalURL stringByAppendingString:url];
   
   //组dic
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *mobileID = [[UIDevice currentDevice].identifierForVendor UUIDString];
    //ClientSource 0其他，无需
    
    NSUserDefaults *accoutDefault=[NSUserDefaults standardUserDefaults];
    NSString *subStation =  [accoutDefault stringForKey:@"Substation"];
    NSLog(@"---------subStation is %@-------",subStation);

    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    [tmp setObject:@"1" forKey:@"MobileType"];
    [tmp setObject:currentVersion forKey:@"MobileVersion"];
    [tmp setObject:mobileID forKey:@"MobileID"];
    
    if (subStation) {
        [tmp setObject:subStation forKey:@"Substation"];
    }else if (!subStation){
        [tmp setObject:@"10" forKey:@"Substation"];
    }

 
    if ([UserInfo shareUser].BusinessID) {
        [tmp setObject:[UserInfo shareUser].BusinessID forKey:@"BusinessID"];
        [tmp setObject:[UserInfo shareUser].DistributionID forKey:@"DistributionID"];
    }
    [tmp addEntriesFromDictionary:params];
   
    NSLog(@"-------url:%@",overStr);
    NSLog(@"~~~~~~~param:%@",tmp);
    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
//    mgr.operationQueue = [NSOperationQueue mainQueue];
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


+ (void)WMpostWithURL:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    NSString *normalURL = kWebServiceHost;
    NSString *overStr = [normalURL stringByAppendingString:url];
    
    //组dic
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSString *mobileID = [[UIDevice currentDevice].identifierForVendor UUIDString];
  
    NSUserDefaults *accoutDefault=[NSUserDefaults standardUserDefaults];
    NSString *subStation =  [accoutDefault stringForKey:@"Substation"];
    NSLog(@"---------subStation is %@-------",subStation);
    //ClientSource 0其他，无需
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    [tmp setObject:@"1" forKey:@"MobileType"];
    [tmp setObject:currentVersion forKey:@"MobileVersion"];
    [tmp setObject:mobileID forKey:@"MobileID"];
    if (subStation) {
        [tmp setObject:subStation forKey:@"Substation"];
    }else if (!subStation){
        [tmp setObject:@"10" forKey:@"Substation"];
    }
    
    if ([UserInfo shareUser].BusinessID) {
        [tmp setObject:[UserInfo shareUser].BusinessID forKey:@"BusinessID"];
        [tmp setObject:[UserInfo shareUser].DistributionID forKey:@"DistributionID"];
    }
    [tmp addEntriesFromDictionary:params];
    
    NSLog(@"-------url:%@",overStr);
    NSLog(@"~~~~~~~param:%@",tmp);

    
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
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
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
