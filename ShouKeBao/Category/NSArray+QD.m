//
//  NSArray+QD.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/28.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NSArray+QD.h"

@implementation NSArray (QD)

+ (NSArray *)arrayWithMemberIsOnly:(NSArray *)array
{
    NSMutableArray *categoryArray = [NSMutableArray array];
    for (unsigned i = 0; i < [array count]; i++) {
        if (![categoryArray containsObject:[array objectAtIndex:i]]){
            [categoryArray addObject:[array objectAtIndex:i]];
        }
    }
    return categoryArray;
}

@end
