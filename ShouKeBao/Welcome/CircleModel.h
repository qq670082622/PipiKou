//
//  CircleModel.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BaseModel.h"

@interface CircleModel : BaseModel
//圈头条数据
@property (nonatomic, copy)NSString *CreateDate;
@property (nonatomic, copy)NSString *ProductThemeName;

-(instancetype)initWithDict:(NSDictionary *)dic;


@end
