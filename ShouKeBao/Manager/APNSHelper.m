//
//  APNSHelper.m
//  TravelConsultant
//
//  Created by 冯坤 on 15/11/23.
//  Copyright (c) 2015年 冯坤. All rights reserved.
//

#import "APNSHelper.h"

@implementation APNSHelper


+(APNSHelper *)defaultAPNSHelper{
    static APNSHelper * apnsHelpers = nil;
    static dispatch_once_t oncetonke;
    dispatch_once(&oncetonke, ^{
        apnsHelpers = [[APNSHelper alloc]init];
        apnsHelpers.isNeedOpenChat = NO;
        apnsHelpers.dataStr = @"";
    });
    return apnsHelpers;
}
@end
