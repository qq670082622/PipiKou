//
//  TerraceMessageModel.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BaseModel.h"

@interface TerraceMessageModel : BaseModel


@property (nonatomic, strong)NSString * BannerUrl;
@property (nonatomic, strong)NSString * Content;
@property (nonatomic, strong)NSString * CreatedDate;
@property (nonatomic, strong)NSString * CreatedDateText;
@property (nonatomic, strong)NSString * Description;
@property (nonatomic, strong)NSString * ID;
@property (nonatomic, strong)NSString * IsRead;
@property (nonatomic, strong)NSString * LinkUrl;
@property (nonatomic, strong)NSString * Title;
@property (nonatomic, strong)NSString * Type;


+(TerraceMessageModel *)modelWithDic:(NSDictionary *)dic;

@end
