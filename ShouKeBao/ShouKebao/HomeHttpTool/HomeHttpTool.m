//
//  HomeHttpTool.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "HomeHttpTool.h"
#import "IWHttpTool.h"

@implementation HomeHttpTool

/**
 *  根据粘贴板的口令信息获取产品详情的model（运营需求）
 */
+ (void)getAProductDetailWithCommandParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    [IWHttpTool postWithURL:@"Product/GetLvqProductCommand" params:param success:^(id json) {
//#warning 此处的接口是假的，需要后台配好之后再重新修改
        if (success) {
            success(json);
            NSLog(@"_______%@",json);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}




/**
 *  获取首页登录用户的相关汇总信息
 */
+ (void)getIndexHeadWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Home/GetIndexHead" params:param success:^(id json) {
        
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
 *  获取首页订单等信息
 */
+ (void)getIndexContentWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Home/GetIndexContent" params:param success:^(id json) {
        
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
 *  获取活动公告信息列表
 */
+ (void)getActivitiesNoticeListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Home/GetActivitiesNoticeList" params:param success:^(id json) {
        
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
 *  获取活动公告信息详情
 */
+ (void)getActivitiesNoticeDetailWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Home/GetActivitiesNoticeDetail" params:param success:^(id json) {
        
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
 *  获取今日推荐产品信息列表
 */
+ (void)getRecommendProductListWithParam:(NSDictionary *)param success:(void (^)(id recommendJson))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postForRecommendWithURL:@"Home/GetRecommendProductList" params:param success:^(id recommendJson) {
        
        if (success) {
            success(recommendJson);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

@end
