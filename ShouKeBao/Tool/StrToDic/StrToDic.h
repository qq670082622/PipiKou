//
//  StrToDic.h
//  piaodaren
//
//  Created by David on 15/2/11.
//  Copyright (c) 2015年 novaloncn.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StrToDic : NSObject
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;//将string转化成字典
+(NSString *)uidWithJsonString:(NSString *)jsonString;

+(NSString *)jsonStringWithDicL:(NSDictionary *)dic;//将字典转化成string
+(NSDictionary *)dictWithArry:(NSArray *)array;
+ (NSString *)stringFromDate:(NSDate *)date;
@end
