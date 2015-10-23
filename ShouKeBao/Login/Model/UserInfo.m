//
//  UserInfo.m
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "UserInfo.h"
#import "NSMutableDictionary+QD.h"

static UserInfo *user;

@implementation UserInfo

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        user = [super allocWithZone:zone];
    });
    return user;
}

+ (UserInfo *)shareUser
{
    if (user == nil) {
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            user = [[self alloc] init];
        });
    }
    return user;
}

+ (instancetype)userInfoWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSMutableDictionary *muta = [NSMutableDictionary cleanNullResult:dict];
        
        self.BusinessID = muta[@"BusinessID"];
        self.DistributionID = muta[@"DistributionID"];
        self.loginType = muta[@"LoginType"];
        self.userName = muta[@"ShowName"];
        self.LoginAvatar = muta[@"LoginAvatar"];
        self.pushMode = muta[@"DisturbSwitch"];
        self.sosMobile = muta[@"Reinforcements"][@"Mobile"];
    }
    return self;
}
+ (BOOL)isOnlineUserWithBusinessID:(NSString *)bussinessID{
    NSArray * testBussinessID = @[@"1", @"2", @"3"];
    for (NSString * str in testBussinessID) {
        if ([str isEqualToString:bussinessID]) {
            return NO;
        }
    }
    return YES;
}

@end
