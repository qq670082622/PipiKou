//
//  Trader.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface Trader : BaseModel   
/**
 *  城市
 */
@property (nonatomic,copy) NSString *City;

/**
 *  地址
 */
@property (nonatomic,copy) NSString *Address;
/**
 *  头像
 */
@property (nonatomic,copy) NSString *Avatar;
/**
 *  简介
 */
@property (nonatomic,copy) NSString *Desc;

@property (nonatomic,copy) NSString *ID;
/**
 *  手机
 */
@property (nonatomic,copy) NSString *Mobile;
/**
 *  名字
 */
@property (nonatomic,copy) NSString *Name;
/**
 *  性别
 */
@property (nonatomic,copy) NSString *Sex;
/**
 *  签名
 */
@property (nonatomic,copy) NSString *Signature;

@property (nonatomic,copy) NSString *WeiXinCode;

+ (instancetype)traderWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
