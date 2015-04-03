//
//  Distribution.m
//  ShouKeBao
//
//  Created by Chard on 15/3/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Distribution.h"

@implementation Distribution

+ (instancetype)distributionWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.name = dict[@"Text"];
        self.distributionId = dict[@"Value"];
    }
    return self;
}

@end
