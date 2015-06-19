//
//  CityPlistTool.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/6/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityPlistTool : NSObject

+ (NSArray *)getProvince;
+ (NSArray *)getCityWithProvince:(NSString *)provinceName;
+ (NSArray *)getDistrictWithCity:(NSString *)cityName;



@end
