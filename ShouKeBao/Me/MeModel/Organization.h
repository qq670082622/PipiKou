//
//  Organization.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface Organization : BaseModel 

/**
 *  地址
 */
@property (nonatomic,copy) NSString *Address;
/**
 *  联系电话
 */
@property (nonatomic,copy) NSString *ContactMobile;
/**
 *  联系人
 */
@property (nonatomic,copy) NSString *ContactName;
/**
 *  头像
 */
@property (nonatomic,copy) NSString *Avatar;
/**
 *  描述
 */
@property (nonatomic,copy) NSString *Desc;
/**
 *  邮箱
 */
@property (nonatomic,copy) NSString *Email;

@property (nonatomic,copy) NSString *ID;
/**
 *  姓名
 */
@property (nonatomic,copy) NSString *Name;

@property (nonatomic,copy) NSString *QQCode;

@property (nonatomic,copy) NSString *WeiXinCode;

+ (instancetype)organizationWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
