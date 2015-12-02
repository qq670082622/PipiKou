//
//  LocationSeting.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LocationSeting : NSObject

@property (nonatomic, copy)NSString *customMessageDateStr;//管客户界面消息推送时间本地化
@property (nonatomic, copy)NSString *carouselPageNumber;//首页轮播条次本地化



+(LocationSeting *)defaultLocationSeting;


//本地化客户头像和昵称存储和取出
- (NSDictionary *)getCustomInfoWithID:(NSString *)ID;
- (void)setCustomInfo:(NSDictionary*)info
                 toID:(NSString *)ID;

@end
