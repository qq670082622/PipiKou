//
//  ButtonList.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ButtonList.h"
#import "UIColor+SK.h"

@implementation ButtonList

+ (instancetype)buttonListWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.color = [UIColor configureColorWithNum:[dict[@"Color"] integerValue]];
        self.linkurl = dict[@"LinkUrl"];
        self.text = dict[@"Text"];
    }
    return self;
}

@end
