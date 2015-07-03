//
//  StrToDic.m
//  piaodaren
//
//  Created by David on 15/2/11.
//  Copyright (c) 2015年 novaloncn.com. All rights reserved.
//

#import "StrToDic.h"

@implementation StrToDic

//NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];//如果内带文字防止出现乱码，将result转化成UTF-8格式,并由string转化成dictionnary
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;

}

+(NSString *)uidWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic[@"userid"];

}

+ (NSString *)jsonStringWithDicL:(NSDictionary *)dic
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *newStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newStr;
}

+(NSDictionary *)dictWithArry:(NSArray *)array
{
NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
   NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *dicData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:dicData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    return dic;

}

+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}


+(void)setValueWhenIsNull:(NSMutableDictionary *)dic andValue:(NSString *)value forKey:(NSString *)key
{
    if (value) {
    
        [dic setObject:value forKey:key];
    
    }else{
        
        [dic setObject:@"" forKey:key];
    }
    
    
}


+(NSMutableArray *)arr:(NSMutableArray *)arr addObject:(NSString *)str
{
    NSMutableArray *normal = [NSMutableArray arrayWithArray:arr];
    [arr removeAllObjects];
    [normal addObject:str];
    arr = normal;
    return arr;
}

+(NSMutableDictionary *)dicCleanSpaceWithDict:(NSDictionary *)dict
{
    NSArray *keys = [dict allKeys];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    for (int i = 0; i<keys.count; i++) {
       //
        NSMutableString *newStr = [NSMutableString stringWithFormat:@"%@",[[dict objectForKey:keys[i]] stringByReplacingOccurrencesOfString:@" " withString:@""]];//去空格
     
        if ([keys[i] isEqualToString:@"Url"]){
            [newDic setObject:newStr forKey:keys[i]];

        }else if ([keys[i] isEqualToString:@"Pic"]){
            [newDic setObject:newStr forKey:keys[i]];

        }else{

        NSMutableString *new2 = [NSMutableString stringWithFormat:@"%@",[newStr stringByReplacingOccurrencesOfString:@"." withString:@""]];//去"."
            [newDic setObject:new2 forKey:keys[i]];
        }
        
          }
    NSLog(@"newDic is %@",newDic);
    return newDic;
}

+(NSMutableString *)cleanSpaceWithString:(NSString *)str
{
    NSMutableString *newStr = [NSMutableString stringWithString:str];
    return [NSMutableString stringWithFormat:@"%@",[newStr stringByReplacingOccurrencesOfString:@" " withString:@""]];
}
@end
