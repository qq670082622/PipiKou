//
//  Business.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/8.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface Business :BaseModel


@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *bussinessId;

@property (nonatomic,copy) NSString *icon;

+ (instancetype)businessWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
