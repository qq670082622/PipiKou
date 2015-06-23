//
//  ButtonList.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseModel.h"
@interface ButtonList : BaseModel

@property (nonatomic,strong) UIColor *color;

@property (nonatomic,copy) NSString *linkurl;

@property (nonatomic,copy) NSString *text;

+ (instancetype)buttonListWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
