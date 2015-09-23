//
//  MeHttpTool.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeHttpTool.h"
#import "IWHttpTool.h"

@implementation MeHttpTool

/**
 *  获取登录的旅行社信息
 */
+ (void)getBusinessWithsuccess:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *param = @{};
    [IWHttpTool postWithURL:@"Business/GetBusiness" params:param success:^(id json) {
        
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
 *  ￼￼修改登录的旅行社信息
 */
+ (void)setBusinessWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Business/SetBusiness" params:param success:^(id json) {
        
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
 *  获取登录的分销人信息
 */
+ (void)getDistributionWithsuccess:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *param = @{};
    [IWHttpTool postWithURL:@"Business/GetDistribution" params:param success:^(id json) {
        
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
 *  ￼￼修改登录的分销人信息
 */
+ (void)setDistributionWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    
    [IWHttpTool postWithURL:@"Business/SetDistribution" params:param success:^(id json) {
        
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
 *  获取客户最近浏览记录信息
 */
+ (void)getHistoryProductListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"Product/GetHistoryProductList" params:param success:^(id json) {
        
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
 *  获取我的收藏产品信息列表
 */
+ (void)getFavoritesProductListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"Product/GetFavoritesProductList" params:param success:^(id json) {
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
 *  获取相关产品
 */
+ (void)getRelatedProductListWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"Product/GetMoreSimilarProductList" params:param success:^(id json) {
        
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
 *  获取搬救兵,即我的专属客服信息
 */
+ (void)getReinforcementsWithsuccess:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *param = @{};
    [IWHttpTool postWithURL:@"Business/GetReinforcements" params:param success:^(id json) {
        
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
 *  修改密码
 */
+ (void)setPasswordWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"Business/SetPassword" params:param success:^(id json) {
        
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
 *  取消收藏
 */
+ (void)cancelFavouriteWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"Product/SetProductFavorites" params:param success:^(id json) {
        
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
 *  加载圈付宝
 */
+ (void)getMeIndexWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"Business/GetMeIndex" params:param success:^(id json) {
        
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
 *设置勿扰模式开关
**/
+ (void)setDisturbSwitchWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [IWHttpTool postWithURL:@"Business/SetDisturbSwitch" params:param success:^(id json) {
        
        if (success) {
            success(json);
            NSLog(@"%@",json);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}
/**
 *  反馈
 */

+ (void)feedBackWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    [IWHttpTool postWithURL:@"Business/CommentFeedback" params:param success:^(id json) {
        
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
 *  检查更新
 */
+ (void)inspectionWithParam:(NSDictionary *)param success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    [IWHttpTool postWithURL:@"/Common/NewVersion" params:param success:^(id json) {
        
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
