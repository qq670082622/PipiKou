//
//  CityPlistTool.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/6/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CityPlistTool.h"

@implementation CityPlistTool
+ (NSDictionary *)getAreaDic{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    NSDictionary *areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    return areaDic;
}
+ (NSArray *)getSortArrayWithArray:(NSArray *)array{
    return [array sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}
//根据plist文件获得省份
+ (NSArray *)getProvince{
    NSDictionary *areaDic = [self getAreaDic];
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [self getSortArrayWithArray:components];
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey:index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    return [NSArray arrayWithArray:provinceTmp];
}
//根据省份获得城市
+ (NSArray *)getCityWithProvince:(NSString *)provinceName{
    NSDictionary * areaDic = [self getAreaDic];
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [self getSortArrayWithArray:components];
    NSMutableArray * cityArray = [NSMutableArray array];
    NSDictionary * cityDic = @{};
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey:index] allKeys];
        if ([[tmp objectAtIndex:0]isEqualToString:provinceName]) {
            cityDic = [[areaDic objectForKey:index]objectForKey:provinceName];
        }
    }
    for (int i = 0; i < [cityDic allKeys].count; i ++) {
        NSString * index = [[self getSortArrayWithArray:[cityDic allKeys]]objectAtIndex:i];
        NSArray * tmp = [[areaDic objectForKey:index]allKeys];
        [cityArray addObject:[tmp objectAtIndex:0]];
    }
    return cityArray;
}
//根据城市获得片区；
//+ (NSArray *)getDistrictWithCity:(NSString *)cityName{
//
//}



@end
