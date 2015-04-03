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
            [str appendString:[NSString stringWithFormat:@"%@  ",dic[@"Name"]]];
            
            //NSLog(@"modal2 内的子name is %@~~~",dic[@"Name"]);
           
        }
        self.Name = str;
     
       // NSLog(@"modal2处理后的str－－Name is %@ -------`",_Name);
        
        //self.SearchKey = dict[@"NavigationChildList"][@"SearchKey"];
    }
    return self;
}
@end
