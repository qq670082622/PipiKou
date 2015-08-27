//
//  OrderTool.m
//  ShouKeBao
//
//  Created by Chard on 15/3/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "OrderTool.h"
#import "IWHttpTool.h"

@implementation OrderTool

/**
 *  根据条件获取订单列表
 */
+ (void)getOrderListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Order/GetOrderList" params:param success:^(id json) {
        
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
 *  根据客户获取客户订单列表
 */
+ (void)CustomgetOrderListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Customer/GetCustomerOrderList" params:param success:^(id json) {
        
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
 *  根据OrderId获取订单详情
 */
+ (void)getOrderDetailWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    [IWHttpTool postWithURL:@"Order/GetOrderDetail" params:param success:^(id json) {
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
 *  获取订单搜索条件
 */
+ (void)getOrderConditionWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"Order/GetOrderCondition" params:param success:^(id json){
        
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
 *  获取线路区域(二级区域)
 */
+ (void)getSecondLevelAreaWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Product/GetSecondLevelArea" params:param success:^(id json) {
        
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
 *  获取国家/省份(三级区域)
 */
+ (void)getThirdLevelAreaWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Product/GetThirdLevelArea" params:param success:^(id json) {
        
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
