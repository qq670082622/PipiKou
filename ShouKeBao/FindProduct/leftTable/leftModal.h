//
//  leftModal.h
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface leftModal : NSObject

@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *Type;
@property (nonatomic , copy) NSString *title;
+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
