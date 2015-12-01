//
//  CircleModel.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CircleModel.h"

@implementation CircleModel

-(instancetype)initWithDict:(NSDictionary *)dic{
    
    if (self = [super init]) {
      self.CreateDate = dic[@"CreateDate"];
      self.ProductThemeName = dic[@"ProductThemeName"];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
@end
