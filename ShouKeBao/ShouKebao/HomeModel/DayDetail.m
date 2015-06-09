//
//  DayDetail.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "DayDetail.h"
#import "NSMutableDictionary+QD.h"

@implementation DayDetail

+ (instancetype)dayDetailWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
     
         [self setValuesForKeysWithDictionary:[NSMutableDictionary cleanNullResult:dict]];
        
        //   NSMutableDictionary *muta = [NSMutableDictionary cleanNullResult:dict];
        
//        self.icon = muta[@"PicUrl"];
//        self.title = muta[@"Name"];
//        self.aPrice = muta[@"PersonPrice"];
//        self.bPrice = muta[@"PersonPeerPrice"];
//        self.shareInfo = muta[@"ShareInfo"];
//        self.linkUrl = muta[@"LinkUrl"];
        
    }
    return self;
    
}

@end
