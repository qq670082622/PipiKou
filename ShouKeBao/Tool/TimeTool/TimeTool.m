//
//  TimeTool.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/6/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "TimeTool.h"

@implementation TimeTool
+ (NSTimeInterval)getNowTime{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970];
    return now;
}
+ (BOOL)isBeyondTimeInterVal:(NSTimeInterval)beyondTime
                   sinceTime:(NSTimeInterval)sinceTime
{
    NSTimeInterval timeInterVal = [self getNowTime] - sinceTime;
    return (timeInterVal - beyondTime > 0) ? YES : NO;
}
@end
