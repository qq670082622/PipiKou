//
//  rightModal3.h
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rightModal3 : NSObject
@property (nonatomic,copy)NSString *Name;
@property (nonatomic,copy)NSString *searchKey;

+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
