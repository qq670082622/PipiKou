//
//  Distribution.m
//  ShouKeBao
//
//  Created by Chard on 15/3/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Distribution.h"
#import "NSMutableDictionary+QD.h"

@implementation Distribution

+ (instancetype)distributionWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSMutableDictionary *muta = [NSMutableDictionary cleanNullResult:dict];
        
        self.SkbType = muta[@"SkbType"];
        self.icon = muta[@"SkbLogo"];
        self.name = muta[@"SkbName"];
        self.distributionId = muta[@"DistributionID"];
        self.IsOpenConsultantApp = muta[@"IsOpenConsultantApp"];
    }
    return self;
}

@end
