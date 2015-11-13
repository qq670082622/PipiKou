//
//  MessageModel2.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/11/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel2 : BaseModel
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *CreatedDate;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString  *Content;
@property (nonatomic,copy) NSString *IsRead;
@property (nonatomic,copy) NSString *LinkUrl;
@property (nonatomic,copy) NSString *Type;
+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
