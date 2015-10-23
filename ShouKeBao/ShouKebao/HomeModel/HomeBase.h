//
//  HomeBase.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeBase : NSObject

@property (nonatomic,copy) NSString *time;

@property (nonatomic,copy) NSString *idStr;// 识别各种信息

@property (nonatomic,strong) id model;// 可以是订单模型 或者推荐 或者提醒 或者新消息

@end
