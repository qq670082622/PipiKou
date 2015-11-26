//
//  Recommend.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Recommend.h"
#import "NSMutableDictionary+QD.h"

@implementation Recommend

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.TitleText forKey:@"TitleText"];
    [aCoder encodeObject:self.PriceText forKey:@"PriceText"];
    [aCoder encodeObject:self.Count forKey:@"Count"];
    [aCoder encodeObject:self.CreatedDate forKey:@"CreatedDate"];
    [aCoder encodeObject:self.Price forKey:@"Price"];
    [aCoder encodeObject:self.RecommendIndexProductList forKey:@"RecommendIndexProductList"];
    [aCoder encodeObject:self.StaticPrice forKey:@"StaticPrice"];

//    [aCoder encodeObject:self.CreateDate forKey:@"CreateDate"];
//    [aCoder encodeObject:self.ProductThemeName forKey:@"ProductThemeName"];
}



-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.TitleText = [aDecoder decodeObjectForKey:@"TitleText"];
        self.PriceText = [aDecoder decodeObjectForKey:@"PriceText"];
        self.Count =  [aDecoder decodeObjectForKey:@"Count"];
        self.CreatedDate =  [aDecoder decodeObjectForKey:@"CreatedDate"];
        self.Price = [aDecoder decodeObjectForKey:@"Price"];
        self.StaticPrice = [aDecoder decodeObjectForKey:@"StaticPrice"];
        self.RecommendIndexProductList = [aDecoder decodeObjectForKey:@"RecommendIndexProductList"];
        
//        self.CreateDate = [aDecoder decodeObjectForKey:@"CreateDate"];
//        self.ProductThemeName = [aDecoder decodeObjectForKey:@"ProductThemeName"];
    }
    
    return self;
}

+ (instancetype)recommendWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSMutableDictionary *muta = [NSMutableDictionary cleanNullResult:dict];
       
        self.TitleText = muta[@"TitleText"];
        self.PriceText = muta[@"PriceText"];
        self.Count = muta[@"Count"];
        self.CreatedDate = muta[@"CreatedDate"];
        self.Price = muta[@"Price"];
        self.RecommendIndexProductList = muta[@"RecommendIndexProductList"];
        self.StaticPrice = muta[@"StaticPrice"];
//        self.CreateDate = muta[@"CreateDate"];
//        self.ProductThemeName = muta[@"ProductThemeName"];
    }
    return self;
}

- (NSString *)Price
{
    return [NSString stringWithFormat:@"%@",_Price];
    
}




@end
