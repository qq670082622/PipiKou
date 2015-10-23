//
//  CustomerIdsModel.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface CustomerIdsModel : BaseModel
@property (nonatomic, copy)NSString * Name;
@property (nonatomic, copy)NSString * ID;
@property (nonatomic, strong)NSArray * PictureList;
+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
