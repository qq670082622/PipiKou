//
//  CustomerIdsModel.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CustomerIdsModel.h"
#import "NSMutableDictionary+QD.h"
@implementation CustomerIdsModel

+(instancetype)modalWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:[NSMutableDictionary cleanNullResult:dict]];
    }
    return self;
}
@end
