//
//  rightModal.m
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "rightModal.h"

@implementation rightModal
+(instancetype)modalWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict
{
//    @property (copy, nonatomic) NSString  *rightIcon;
//    @property (copy, nonatomic) NSString  *rightDescrip;
//    @property (copy, nonatomic) NSString  *rightPrice;
//    for (NSDictionary *dic in dict) {
        self.rightIcon = dict[@"PicUrl"];
        self.rightDescrip = dict[@"Name"];
           self.rightPrice = dict[@"PersonPeerPrice"];
    self.productUrl = dict[@"LinkUrl"];
    NSLog(@"%@", dict[@"ShareInfo"]);
    self.ShareInfo = dict[@"ShareInfo"];
//    }
    return self;
}

@end
