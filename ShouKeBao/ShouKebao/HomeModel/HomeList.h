//
//  ShouKeBao.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/7.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeList : NSObject

/**
 *  儿童人数
 */
@property (nonatomic,copy) NSString *ChildCount;
/**
 *  创建时间
 */
@property (nonatomic,copy) NSString *CreatedDate;
/**
 *  id
 */
@property (nonatomic,copy) NSString *ID;
/**
 *  是否是订单信息
 */
@property (nonatomic,copy) NSString *IsSKBOrder;
/**
 *  订单编号
 */
@property (nonatomic,copy) NSString *OrderCode;
/**
 *  成人数
 */
@property (nonatomic,copy) NSString *PersonCount;
/**
 *  价格
 */
@property (nonatomic,copy) NSString *Price;
/**
 *  产品名称
 */
@property (nonatomic,copy) NSString *ProductName;
/**
 *  标题
 */
@property (nonatomic,copy) NSString *ShowType;

+ (instancetype)homeListWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
