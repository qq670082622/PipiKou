//
//  LocationSeting.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "LocationSeting.h"

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


@end
