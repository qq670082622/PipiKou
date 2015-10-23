//
//  OrderTool.h
//  ShouKeBao
//
//  Created by Chard on 15/3/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderTool : NSObject

/**
 *  根据条件获取订单列表
 */
+ (void)getOrderListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  根据OrderId获取订单详情
 */
+ (void)getOrderDetailWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  获取订单搜索条件
 */
+ (void)getOrderConditionWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  获取线路区域(二级区域)
 */
+ (void)getSecondLevelAreaWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  获取国家/省份(三级区域)
 */
+ (void)getThirdLevelAreaWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;



+ (void)CustomgetOrderListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

@end
