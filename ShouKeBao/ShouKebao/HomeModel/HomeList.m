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

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.ChildCount forKey:@"ChildCount"];
    [aCoder encodeObject:self.CreatedDate forKey:@"CreatedDate"];
    [aCoder encodeObject:self.GoDate forKey:@"GoDate"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.IsSKBOrder forKey:@"IsSKBOrder"];
    [aCoder encodeObject:self.OrderCode forKey:@"OrderCode"];
    [aCoder encodeObject:self.PersonCount forKey:@"PersonCount"];
    [aCoder encodeObject:self.Price forKey:@"Price"];
    [aCoder encodeObject:self.ProductName forKey:@"ProductName"];
    [aCoder encodeObject:self.ShowType forKey:@"ShowType"];
    [aCoder encodeObject:self.LinkUrl forKey:@"LinkUrl"];
    [aCoder encodeObject:self.OrderStateDetail forKey:@"OrderStateDetail"];
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (self) {
        self.ChildCount =  [aDecoder decodeObjectForKey:@"ChildCount"];
        self.CreatedDate =  [aDecoder decodeObjectForKey:@"CreatedDate"];
        self.GoDate = [aDecoder decodeObjectForKey:@"GoDate"];
        self.ID =  [aDecoder decodeObjectForKey:@"ID"];
        self.IsSKBOrder =  [aDecoder decodeObjectForKey:@"IsSKBOrder"];
        self.OrderCode =  [aDecoder decodeObjectForKey:@"OrderCode"];
        self.PersonCount =  [aDecoder decodeObjectForKey:@"PersonCount"];
        self.Price =  [aDecoder decodeObjectForKey:@"Price"];
        self.ProductName =  [aDecoder decodeObjectForKey:@"ProductName"];
        self.ShowType =  [aDecoder decodeObjectForKey:@"ShowType"];
        self.LinkUrl = [aDecoder decodeObjectForKey:@"LinkUrl"];
        self.OrderStateDetail = [aDecoder decodeObjectForKey:@"OrderStateDetail"];
    }
    return self;
}

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
        self.GoDate = muta[@"GoDate"];
        self.ID = muta[@"ID"];
        self.IsSKBOrder = muta[@"IsSKBOrder"];
        self.OrderCode = muta[@"OrderCode"];
        self.PersonCount = muta[@"PersonCount"];
        self.Price = muta[@"Price"];
        self.ProductName = muta[@"ProductName"];
        self.ShowType = muta[@"ShowType"];
        self.LinkUrl = muta[@"LinkUrl"];
        self.OrderStateDetail = muta[@"OrderStateDetail"];
        
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
