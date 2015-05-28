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
    
    [aCoder encodeObject:self.Count forKey:@"Count"];
    [aCoder encodeObject:self.CreatedDate forKey:@"CreatedDate"];
    [aCoder encodeObject:self.Price forKey:@"Price"];
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super init]) {
        self.Count =  [aDecoder decodeObjectForKey:@"Count"];
        self.CreatedDate =  [aDecoder decodeObjectForKey:@"CreatedDate"];
        self.Price = [aDecoder decodeObjectForKey:@"Price"];
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
       
      
        self.Count = muta[@"Count"];
        self.CreatedDate = muta[@"CreatedDate"];
        self.Price = muta[@"Price"];
        self.photosArr = [NSArray arrayWithObjects:@"1mg",@"2mg",@"3mg",@"2mg", nil];
    }
    return self;
}

- (NSString *)Price
{
    return [NSString stringWithFormat:@"￥%@",_Price];
}




@end
