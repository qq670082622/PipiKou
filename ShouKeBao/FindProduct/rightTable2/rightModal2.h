//
//  rightModal2.h
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rightModal2 : NSObject
@property(nonatomic,copy) NSString  *title;
@property (nonatomic,copy) NSString *Name;
//@property (nonatomic,copy) NSString *SearchKey;

+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
