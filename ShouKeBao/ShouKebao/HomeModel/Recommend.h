//
//  Recommend.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recommend : NSObject

@property (nonatomic,copy) NSString *Count;

@property (nonatomic,copy) NSString *CreatedDate;

@property (nonatomic,copy) NSString *Price;

+ (instancetype)recommendWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
