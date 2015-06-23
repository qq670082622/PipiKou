//
//  Trader.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Trader.h"

@implementation Trader

+ (instancetype)traderWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSMutableDictionary *muta = dict.mutableCopy;
        NSArray *array = [dict allKeys];
        for (NSString *key in array) {
            if ([[muta objectForKey:key] isKindOfClass:[NSNull class]]) {
                [muta setValue:@"" forKey:key];
            }
        }
        [self setValuesForKeysWithDictionary:muta];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
@end
