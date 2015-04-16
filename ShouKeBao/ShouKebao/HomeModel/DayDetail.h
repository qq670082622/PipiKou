//
//  DayDetail.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayDetail : NSObject

@property (nonatomic,copy) NSString *icon;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *aPrice;

@property (nonatomic,copy) NSString *bPrice;

@property (nonatomic,copy) NSString *linkUrl;

//  Desc Pic Title Url
@property (nonatomic,strong) NSDictionary *shareInfo;

+ (instancetype)dayDetailWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
