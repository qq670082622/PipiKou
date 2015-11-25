//
//  APNSHelper.h
//  TravelConsultant
//
//  Created by 冯坤 on 15/11/23.
//  Copyright (c) 2015年 冯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APNSHelper : NSObject

@property (nonatomic, assign)BOOL hasNewMessage;
@property (nonatomic, assign)BOOL isNeedOpenChat;
@property (nonatomic, strong)NSString * dataStr;
+(APNSHelper *)defaultAPNSHelper;

@end
