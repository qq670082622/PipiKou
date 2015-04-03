//
//  Distribution.h
//  ShouKeBao
//
//  Created by Chard on 15/3/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Distribution : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *distributionId;

+ (instancetype)distributionWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
