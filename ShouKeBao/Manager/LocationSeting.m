//
//  LocationSeting.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "LocationSeting.h"
#import "CustomHeaderAndNickName.h"

@interface LocationSeting ()
@property (nonatomic, strong)NSMutableArray * customLocationInfoArray;

@end


@implementation LocationSeting

+(LocationSeting *)defaultLocationSeting{
    static LocationSeting * location = nil;
    static dispatch_once_t oncetonke;
    dispatch_once(&oncetonke, ^{
        location = [[LocationSeting alloc]init];
    });
    return location;
}
-(void)setCustomMessageDateStr:(NSString *)customMessageDateStr{
    [self mySetObject:customMessageDateStr forKey:@"customMessageDateStr"];
}
-(NSString *)customMessageDateStr{
    return [self myObjectForKey:@"customMessageDateStr"];
}



- (void)setCarouselPageNumber:(NSString *)carouselPageNumber{
    [self mySetObject:carouselPageNumber forKey:@"carouselPageNumber"];
}
- (NSString *)carouselPageNumber{
    return [self myObjectForKey:@"carouselPageNumber"];
}


//本地保存直客ID和头像 并实时更新；
-(void)setCustomLocationInfoArray:(NSMutableArray *)customLocationInfoArray{
    [self mySetObject:customLocationInfoArray forKey:@"customLocationInfoArray"];
}
-(NSMutableArray *)customLocationInfoArray{
    if ([self myObjectForKey:@"customLocationInfoArray"]) {
        return [self myObjectForKey:@"customLocationInfoArray"];
    }else{
        [LocationSeting defaultLocationSeting].customLocationInfoArray = [NSMutableArray array];
        return [self myObjectForKey:@"customLocationInfoArray"];
    }
}
- (void)mySetObject:(id)obj
             forKey:(NSString *)aKey{
    if (obj != [NSNull null]) {
        [[NSUserDefaults standardUserDefaults]setObject:obj forKey:aKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
- (id)myObjectForKey:(NSString *)aKey{
    return [[NSUserDefaults standardUserDefaults]objectForKey:aKey];
}




//本地化客户头像和昵称存储和取出

- (NSDictionary *)getCustomInfoWithID:(NSString *)ID{
    NSLog(@"-------%@",[LocationSeting defaultLocationSeting].customLocationInfoArray );
    for (NSMutableDictionary * dic in [LocationSeting defaultLocationSeting].customLocationInfoArray) {
        if ([dic.allKeys[0] isEqualToString:ID]) {
            return [dic objectForKey:ID];
        }
    }
    return nil;
}
- (void)setCustomInfo:(NSDictionary*)info
                 toID:(NSString *)ID{
    NSMutableDictionary * infoDic = [NSMutableDictionary dictionaryWithObject:info forKey:ID];
    BOOL isExit = NO;
    NSLog(@"customLocationInfoArray = %@",[LocationSeting defaultLocationSeting].customLocationInfoArray);
    for (NSMutableDictionary * dic in [LocationSeting defaultLocationSeting].customLocationInfoArray) {
        if ([dic.allKeys[0] isEqualToString:ID]) {
          NSMutableArray * tempArray =  [[LocationSeting defaultLocationSeting].customLocationInfoArray mutableCopy];
            NSMutableDictionary * tempDic = [dic mutableCopy];
            [tempArray removeObject:dic];
            [tempDic setObject:info forKey:ID];
            isExit = YES;
            [tempArray addObject:tempDic];
            [LocationSeting defaultLocationSeting].customLocationInfoArray = tempArray;
            NSLog(@"customLocationInfoArray33 = %@",[LocationSeting defaultLocationSeting].customLocationInfoArray);

        }
    }
    if (!isExit) {
        NSMutableArray * tempArray = [[LocationSeting defaultLocationSeting].customLocationInfoArray mutableCopy];
        [tempArray addObject:infoDic];
        [LocationSeting defaultLocationSeting].customLocationInfoArray = tempArray;
    }
}


@end
