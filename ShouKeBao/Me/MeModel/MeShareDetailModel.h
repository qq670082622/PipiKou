//
//  MeShareDetailModel.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BaseModel.h"

@interface MeShareDetailModel : BaseModel
@property (nonatomic, copy) NSString *PicUrl;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *StartCityName;
@property (strong, nonatomic) NSNumber *VisitCount;
@property (strong, nonatomic) NSNumber *OrderCount;

@property (nonatomic, copy) NSString *LinkUrl;
@property (nonatomic, strong) NSMutableDictionary *ShareInfo;


//专属App数据界面数据
@property (nonatomic, copy)NSString *Installed;//今日已安装
@property (nonatomic, copy)NSString *ActiveUser;//今日活跃用户
@property (nonatomic, copy)NSString *ProductBrowse;//今日浏览
@property (nonatomic, copy)NSString *OrderQuantity;//今日下单量

@property (nonatomic, copy)NSString *InstalledTotal;//总安装量
@property (nonatomic, copy)NSString *ActiveUserTotal;//总活跃用户量
@property (nonatomic, copy)NSString *ProductBrowseTotal;//总产品浏览量
@property (nonatomic, copy)NSString *OrderQuantityTotal;//总下单量
@property (nonatomic, copy)NSString *IsBinding;//是否绑定专属APP（0：未绑定；1：绑定。）

@property (nonatomic, copy)NSString *AdvisorRank; //SKBVipLevel(枚举)


+ (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)shareDetailWithDict:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
