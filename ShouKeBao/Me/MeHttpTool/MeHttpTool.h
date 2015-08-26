//
//  MeHttpTool.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeHttpTool : NSObject

/**
 *  获取登录的旅行社信息
 */
+ (void)getBusinessWithsuccess:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  ￼￼修改登录的旅行社信息
 */
+ (void)setBusinessWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  获取登录的分销人信息
 */
+ (void)getDistributionWithsuccess:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  ￼￼修改登录的分销人信息
 */
+ (void)setDistributionWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  获取客户最近浏览记录信息
 */
+ (void)getHistoryProductListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  获取下架产品相关产品列表
 */
+ (void)getRelatedProductListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  获取我的收藏产品信息列表
 */
+ (void)getFavoritesProductListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  获取搬救兵,即我的专属客服信息
 */
+ (void)getReinforcementsWithsuccess:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  修改密码
 */
+ (void)setPasswordWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  取消收藏
 */
+ (void)cancelFavouriteWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  加载圈付宝
 */
+ (void)getMeIndexWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  设置勿扰模式开关
 */
+ (void)setDisturbSwitchWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  反馈
 */
+ (void)feedBackWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  检查更新
 */
+ (void)inspectionWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

@end
