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
    [[NSUserDefaults standardUserDefaults]setObject:customMessageDateStr forKey:@"customMessageDateStr"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(NSString *)customMessageDateStr{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"customMessageDateStr"];
}

- (void)setCarouselPageNumber:(NSString *)carouselPageNumber{
    [[NSUserDefaults standardUserDefaults]setObject:carouselPageNumber forKey:@"carouselPageNumber"];
}
- (NSString *)carouselPageNumber{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"carouselPageNumber"];
}
@end
