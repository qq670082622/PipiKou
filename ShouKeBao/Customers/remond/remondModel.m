//
//  remondModel.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "remondModel.h"

@implementation remondModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.RemindTime forKey:@"time"];
    [aCoder encodeObject:self.Content forKey:@"content"];
    [aCoder encodeObject:self.ID forKey:@"id"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.name =  [aDecoder decodeObjectForKey:@"name"];
        self.RemindTime =  [aDecoder decodeObjectForKey:@"time"];
        self.Content =  [aDecoder decodeObjectForKey:@"content"];
        self.ID =  [aDecoder decodeObjectForKey:@"id"];
        self.phone =  [aDecoder decodeObjectForKey:@"phone"];
    }
    
    return self;
}

+(instancetype)modalWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        self.Content = dict[@"Content"];
        self.RemindTime = dict[@"RemindTime"];
        self.ID = dict[@"ID"];
    }
    return self;
}
@end
