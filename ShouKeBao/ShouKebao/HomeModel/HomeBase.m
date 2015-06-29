//
//  HomeBase.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "HomeBase.h"

@implementation HomeBase

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.idStr forKey:@"idStr"];
    [aCoder encodeObject:self.model forKey:@"model"];
    

}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.time =  [aDecoder decodeObjectForKey:@"time"];
        self.idStr =  [aDecoder decodeObjectForKey:@"idStr"];
        self.model =  [aDecoder decodeObjectForKey:@"model"];
    }
    
    return self;
}

@end
