//
//  messageModel.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface messageModel : BaseModel 
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
