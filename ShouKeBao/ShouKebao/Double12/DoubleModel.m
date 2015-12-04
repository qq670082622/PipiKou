//
//  DoubleModel.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "DoubleModel.h"
#import "NSMutableDictionary+QD.h"
@implementation DoubleModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.FirstTitle forKey:@"FirstTitle"];
    [aCoder encodeObject:self.SecondTitle forKey:@"SecondTitle"];
    [aCoder encodeObject:self.ThirdTitle forKey:@"ThirdTitle"];
    [aCoder encodeObject:self.CreatedDate forKey:@"CreatedDate"];
    [aCoder encodeObject:self.BannerUrl forKey:@"BannerUrl"];
    [aCoder encodeObject:self.LinkUrl forKey:@"LinkUrl"];
    [aCoder encodeObject:self.IconUrl forKey:@"IconUrl"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.FirstTitle = [aDecoder decodeObjectForKey:@"FirstTitle"];
        self.SecondTitle = [aDecoder decodeObjectForKey:@"SecondTitle"];
        self.ThirdTitle = [aDecoder decodeObjectForKey:@"ThirdTitle"];
        self.CreatedDate = [aDecoder decodeObjectForKey:@"CreatedDate"];
        self.BannerUrl = [aDecoder decodeObjectForKey:@"BannerUrl"];
        self.LinkUrl = [aDecoder decodeObjectForKey:@"LinkUrl"];
        self.IconUrl = [aDecoder decodeObjectForKey:@"IconUrl"];
    }
    return self;
}

+ (instancetype)modalWithDict:(NSDictionary *)dic{
    return [[self alloc]initWithDict:dic];
}

-(instancetype)initWithDict:(NSDictionary *)dictionary{
    
    if (self = [super init]) {
         NSMutableDictionary *dic = [NSMutableDictionary cleanNullResult:dictionary];
        self.IconUrl = dic[@"IconUrl"];
        self.BannerUrl = dic[@"BannerUrl"];
        self.CreatedDate = dic[@"CreatedDate"];
        self.FirstTitle = dic[@"FirstTitle"];
        self.LinkUrl = dic[@"LinkUrl"];
        self.SecondTitle = dic[@"SecondTitle"];
        self.ThirdTitle = dic[@"ThirdTitle"];
        
//     [self setValuesForKeysWithDictionary:[NSMutableDictionary cleanNullResult:dic]];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

@end
