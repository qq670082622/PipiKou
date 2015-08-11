//
//  rightModal2.m
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "rightModal2.h"

@implementation rightModal2
+(instancetype)modalWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.title = dict[@"Name"];
        NSMutableString *str = [NSMutableString string];
        for (NSDictionary *dic in dict[@"NavigationChildList"]) {
            NSLog(@"%@", dic);
            [str appendString:[NSString stringWithFormat:@"%@  ",dic[@"Name"]]];
            [self.subNameArray addObject:dic[@"Name"]];
            [self.searchKeyArray addObject:dic[@"SearchKey"]];
            //NSLog(@"modal2 内的子name is %@~~~",dic[@"Name"]);
        }
        self.Name = str;
        NSLog(@"%@", self.subNameArray);
    }
    return self;
}
-(NSMutableArray *)subNameArray{
    if (!_subNameArray) {
        _subNameArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _subNameArray;
}
-(NSMutableArray *)searchKeyArray{
    if (!_searchKeyArray) {
        _searchKeyArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _searchKeyArray;
}
@end
