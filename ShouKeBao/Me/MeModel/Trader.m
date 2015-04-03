//
//  Trader.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Trader.h"

@implementation Trader

+ (instancetype)traderWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
