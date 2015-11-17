//
//  CustomerSection.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/16.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CustomerSection.h"

@implementation CustomerSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.newsBindingCustomArr = [NSMutableArray array];
        self.hadBindingCustomArr = [NSMutableArray array];
        self.otherCustomArr = [NSMutableArray array];

    }
    return self;
}


@end
