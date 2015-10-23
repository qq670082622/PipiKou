//
//  Server.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface Server : BaseModel   

@property (nonatomic,copy) NSString *Email;

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy) NSString *Mobile;

@property (nonatomic,copy) NSString *Name;

@property (nonatomic,copy) NSString *QQCode;

@property (nonatomic,copy) NSString *Avatar;

+ (instancetype)serverWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
