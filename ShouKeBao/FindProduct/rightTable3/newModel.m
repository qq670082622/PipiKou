//
//  newModel.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/6/4.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "newModel.h"

@implementation newModel
+(instancetype)modalWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.Text = dict[@"Name"];
        self.Value = dict[@"searchKey"];
    }
    return self;
}

@end
