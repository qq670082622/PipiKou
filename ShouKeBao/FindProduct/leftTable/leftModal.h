//
//  leftModal.h
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface leftModal : BaseModel

@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Type;
@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *MaxIcon;
@property (nonatomic , copy) NSString *MaxIconFocus;
@property (nonatomic , copy) NSString *MinIcon;
@property (nonatomic , copy) NSString *MinIconFocus;
+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
