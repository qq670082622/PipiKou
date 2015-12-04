//
//  DoubleModel.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface DoubleModel : BaseModel
@property (nonatomic, copy)NSString *IconUrl;//小图标
@property (nonatomic, copy)NSString *FirstTitle;//一级标题
@property (nonatomic, copy)NSString *CreatedDate;//发布时间
@property (nonatomic, copy)NSString *SecondTitle;//二级标题
@property (nonatomic, copy)NSString *ThirdTitle;//三级标题
@property (nonatomic, copy)NSString *BannerUrl;//Banner图片
@property (nonatomic, copy)NSString *LinkUrl;//链接地址

-(instancetype)initWithDict:(NSDictionary *)dic;
+ (instancetype)modalWithDict:(NSDictionary *)dictionary;
@end
