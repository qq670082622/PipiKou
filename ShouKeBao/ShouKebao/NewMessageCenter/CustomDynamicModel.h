//
//  CustomDynamicModel.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BaseModel.h"
@class ProductModal;
@interface CustomDynamicModel : BaseModel

@property (nonatomic, strong)NSString *  AppSkbUserId;
@property (nonatomic, strong)NSString *  DynamicType;
@property (nonatomic, strong)NSString *  DynamicTitle;
@property (nonatomic, strong)NSString *  DynamicContent;
@property (nonatomic, strong)NSString *  IsRead;
@property (nonatomic, strong)NSString *  NickName;
@property (nonatomic, strong)NSString *  HeadUrl;
@property (nonatomic, strong)NSString *  CustomerMobile;
@property (nonatomic, strong)NSString *  CreateTime;
@property (nonatomic, strong)NSString *  CreateTimeText;
@property (nonatomic, strong)ProductModal *  ProductdetailModel;//
+(CustomDynamicModel*)modelWithDic:(NSDictionary *)dic;
@end
