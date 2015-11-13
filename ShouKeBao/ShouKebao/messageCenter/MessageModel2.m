//
//  MessageModel2.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/11/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MessageModel2.h"

@implementation MessageModel2
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.CreatedDate forKey:@"CreatedDate"];
    //[aCoder encodeObject:self.ID forKey:@"ID"];
    //[aCoder encodeObject:self.Content forKey:@"Content"];
    //[aCoder encodeObject:self.IsRead forKey:@"IsRead"];
    //[aCoder encodeObject:self.LinkUrl forKey:@"LinkUrl"];
    [aCoder encodeObject:self.Type forKey:@"Type"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.title =  [aDecoder decodeObjectForKey:@"title"];
        self.CreatedDate =  [aDecoder decodeObjectForKey:@"CreatedDate"];
        //self.ID = [aDecoder decodeObjectForKey:@"ID"];
        // self.Content = [aDecoder decodeObjectForKey:@"Content"];
        // self.IsRead = [aDecoder decodeObjectForKey:@"IsRead"];
        // self.LinkUrl = [aDecoder decodeObjectForKey:@"LinkUrl"];
        self.Type = [aDecoder decodeObjectForKey:@"Type"];
        
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
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


@end
