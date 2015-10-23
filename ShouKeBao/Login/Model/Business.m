//
//  Business.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/8.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Business.h"
#import "NSMutableDictionary+QD.h"

@implementation Business

+ (instancetype)businessWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSMutableDictionary *muta = [NSMutableDictionary cleanNullResult:dict];
        
        self.name = muta[@"Name"];
        self.bussinessId = muta[@"ID"];
        self.icon = muta[@"Avatar"];
    }
    return self;
}

@end
