//
//  MeShareDetailModel.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeShareDetailModel.h"
#import "NSMutableDictionary+QD.h"
@implementation MeShareDetailModel

//+ (instancetype)initWithDict:(NSDictionary *)dict{
//    return [[self alloc] initWithDict:dict];
//}

+ (instancetype)shareDetailWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:[NSMutableDictionary cleanNullResult:dict]];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
