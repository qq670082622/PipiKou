//
//  StrToDic.h
//  piaodaren
//
//  Created by David on 15/2/11.
//  Copyright (c) 2015年 novaloncn.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface StrToDic : NSObject
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;//将string转化成字典
+(NSString *)uidWithJsonString:(NSString *)jsonString;

+(NSString *)jsonStringWithDicL:(NSDictionary *)dic;//将字典转化成string
+(NSDictionary *)dictWithArry:(NSArray *)array;
+ (NSString *)stringFromDate:(NSDate *)date;

+(void)setValueWhenIsNull:(NSMutableDictionary *)dic andValue:(NSString *)value forKey:(NSString *)key;

+(NSMutableArray *)arr:(NSMutableArray *)arr addObject:(NSString *)str;
+(NSMutableDictionary *)dicCleanSpaceWithDict:(NSDictionary *)dict;//去空格
+(NSMutableString *)cleanSpaceWithString:(NSString *)str;//字符串去空格

+(CGFloat)heightForString:(NSString *)string
                withWidth:(CGFloat)width
             withFontsize:(CGFloat)fontSize;
@end
