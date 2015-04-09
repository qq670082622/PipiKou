//
//  ShouKeBao.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/7.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "HomeList.h"
#import "NSMutableDictionary+QD.h"

@implementation HomeList

+ (instancetype)homeListWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSMutableDictionary *muta = [NSMutableDictionary cleanNullResult:dict];

        self.ChildCount = muta[@"ChildCount"];
        self.CreatedDate = muta[@"CreatedDate"];
        self.ID = muta[@"ID"];
        self.IsSKBOrder = muta[@"IsSKBOrder"];
        self.OrderCode = muta[@"OrderCode"];
        self.PersonCount = muta[@"PersonCount"];
        self.Price = muta[@"Price"];
        self.ProductName = muta[@"ProductName"];
        self.ShowType = muta[@"ShowType"];
    }
    return self;
}

- (NSString *)PersonCount
{
    return [NSString stringWithFormat:@"成人%@人",_PersonCount];
}

- (NSString *)ChildCount
{
    return [NSString stringWithFormat:@"儿童%@人",_ChildCount];
}

- (NSString *)OrderCode
{
    return [NSString stringWithFormat:@"订单编号:%@",_OrderCode];
}

- (NSString *)Price
{
    return [NSString stringWithFormat:@"￥%@",_Price];
}

@end
