//
//  MeShareDetailModel.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BaseModel.h"

@interface MeShareDetailModel : BaseModel
@property (nonatomic,copy) NSString *PicUrl;
@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) NSString *StartCityName;
@property (strong,nonatomic) NSNumber *VisitCount;
@property (strong,nonatomic) NSNumber *OrderCount;

+ (instancetype)shareDetailWithDict:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
