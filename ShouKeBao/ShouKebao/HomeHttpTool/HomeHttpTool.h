//
//  HomeHttpTool.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeHttpTool : NSObject

/**
 *  获取首页登录用户的相关汇总信息
 */
+ (void)getIndexHeadWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  获取首页订单等信息
 */
+ (void)getIndexContentWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  获取活动公告信息列表
 */
+ (void)getActivitiesNoticeListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  获取活动公告信息详情
 */
+ (void)getActivitiesNoticeDetailWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  获取今日推荐产品信息列表
 */
+ (void)getRecommendProductListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

@end
