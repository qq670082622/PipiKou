//
//  ConditionModel.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ConditionModel.h"

@implementation ConditionModel
+(instancetype)modalWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
     
//        self.ProductBrowseTag = dict[@"ProductBrowseTag"];
//        self.GoDate = dict[@"GoDate"];
//        self.ScheduleDays = dict[@"ScheduleDays"];
//        self.StartCity = dict[@"StartCity"];
//        self.ProductThemeTag = dict[@"ProductThemeTag"];
//        self.Supplier = dict[@"Supplier"];
//        self.HotelStandard = dict[@"HotelStandard"];
//        self.TrafficType = dict[@"TrafficType"];
//        self.CruiseShipCompany = dict[@"CruiseShipCompany"];
//        self.ProductLevel = dict[@"ProductLevel"];
        
            }
    return self;
}

@end
