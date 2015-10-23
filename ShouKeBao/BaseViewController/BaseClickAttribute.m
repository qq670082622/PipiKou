//
//  BaseClickAttribute.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/7/1.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BaseClickAttribute.h"
#import "UserInfo.h"
#import <UIKit/UIKit.h>
@implementation BaseClickAttribute
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = (BaseClickAttribute *)[NSMutableDictionary dictionaryWithCapacity:1];
     NSDictionary * dic = @{@"SubstationName" : [[NSUserDefaults standardUserDefaults]valueForKey:@"SubstationName"], @"DistributionID" : [[UserInfo shareUser]valueForKey:@"DistributionID"], @"BusinessID" : [[UserInfo shareUser]valueForKey:@"BusinessID"], @"DeviceID":[[UIDevice currentDevice].identifierForVendor UUIDString], @"AppUserID":[[NSUserDefaults standardUserDefaults]valueForKey:@"AppUserID"]};
        NSLog(@"%@", [[UserInfo shareUser]valueForKey:@"BusinessID"]);
        NSLog(@"%@", [[UIDevice currentDevice].identifierForVendor UUIDString]);
    [self addEntriesFromDictionary:dic];
    }

    return self;
}

+ (BaseClickAttribute *)attributeWithDic:(NSDictionary *)dic{
    NSLog(@"自定义事件00000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    BaseClickAttribute * diccc = [[BaseClickAttribute alloc]init];
    if (dic) {
        [diccc addEntriesFromDictionary:dic];
    }
    return diccc;
}




@end
