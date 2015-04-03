//
//  NSMutableDictionary+QD.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NSMutableDictionary+QD.h"

@implementation NSMutableDictionary (QD)

- (NSMutableDictionary *)cleanNullResult
{
    NSArray *array = [self allKeys];
    for (NSString *key in array) {
        if ([[self objectForKey:key] isKindOfClass:[NSNull class]]) {
            [self setValue:@"" forKey:key];
        }
    }
    return self;
}

@end
