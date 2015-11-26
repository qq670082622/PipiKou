//
//  Distribution.h
//  ShouKeBao
//
//  Created by Chard on 15/3/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface Distribution : BaseModel

@property (nonatomic,copy) NSString *SkbType;// 1是旅行社 2是分销人

@property (nonatomic,copy) NSString *icon;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *distributionId;

@property (nonatomic, copy)NSString *IsOpenConsultantApp;

+ (instancetype)distributionWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
