//
//  NSMutableDictionary+QD.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NSMutableDictionary+QD.h"

@implementation NSMutableDictionary (QD)

+ (NSMutableDictionary *)cleanNullResult:(NSDictionary *)dict
{
    NSMutableDictionary *muta = dict.mutableCopy;
    NSArray *array = [dict allKeys];
    for (NSString *key in array) {
        if ([[muta objectForKey:key] isKindOfClass:[NSNull class]]) {
            [muta setValue:@"" forKey:key];
        }
    }
    return muta;
}

@end
