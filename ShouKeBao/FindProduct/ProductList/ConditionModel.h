//
//  ConditionModel.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface ConditionModel : BaseModel
//“ ProductCondition”:{
//    “ ProductBrowseTag “:[{}````{}],
//    “GoDate”:[{“Text”:””,”Value”:””}],
//    “ ScheduleDays “:[{“Text”:”1天”,”Value”:”1"},{},{},{}````];
//        “StartCity”:[{},{}````],
//        “ProductThemeTag”:[{“Text”:,”Value”:”"},{}```],
//            “Supplier”:[{},{},{}````];
//            “ HotelStandard :"[{},{}```]”,
//            “ CruiseShipCompany “:”[{},{},{}````]"
//        }
@property (nonatomic,strong) NSArray *ProductBrowseTag;//游览线路ID
@property (nonatomic,strong) NSArray *GoDate;//出发日期
@property (nonatomic,strong) NSArray *ScheduleDays;//行程时间
@property (nonatomic,strong) NSArray *StartCity;//出发城市
@property (nonatomic,strong) NSArray *ProductThemeTag;//主题推荐iD
@property (nonatomic,strong) NSArray *Supplier;//供应商ID
@property (nonatomic,strong) NSArray *HotelStandard;//酒店类型
@property (nonatomic,strong) NSArray *TrafficType;//出行方式
@property (nonatomic,strong) NSArray *CruiseShipCompany;//油轮公司
@property (nonatomic,strong) NSArray *ProductLevel;//线路等级
//IsPersonBackPrice ture 是否加返
//IsComfirmStockNow bool 及时确认
//MinPrice MaxPrice 价格区间 nsnumber

+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
