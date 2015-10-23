//
//  TimeTool.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/6/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTool : NSObject
//获取当前时间
+ (NSTimeInterval)getNowTime;
//比较时间间隔是否超过了给定的时间间隔
+ (BOOL)isBeyondTimeInterVal:(NSTimeInterval)beyondTime
                   sinceTime:(NSTimeInterval)sinceTime;

@end
