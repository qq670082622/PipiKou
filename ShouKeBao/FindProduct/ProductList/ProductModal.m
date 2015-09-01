//
//  ProductModal.m
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ProductModal.h"
#import "NSMutableDictionary+QD.h"

@implementation ProductModal
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
