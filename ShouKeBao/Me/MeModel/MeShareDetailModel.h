//
//  MeShareDetailModel.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BaseModel.h"

@interface MeShareDetailModel : BaseModel
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *goAddress;
@property (nonatomic,copy) NSString *skimCount;
@property (nonatomic,copy) NSString *orderCount;

+ (instancetype)shareDetailWithDict:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
