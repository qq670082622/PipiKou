//
//  Recommend.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface Recommend : BaseModel    

@property (nonatomic,copy) NSString *Count;

@property (nonatomic,copy) NSString *CreatedDate;
@property (nonatomic, copy)NSString *StaticPrice;
@property (nonatomic,copy) NSString *Price;

@property (nonatomic,strong) NSArray *RecommendIndexProductList;
//新增
@property (nonatomic, copy)NSString *TitleText;
@property (nonatomic, copy)NSString *PriceText;




+ (instancetype)recommendWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
