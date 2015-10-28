//
//  ProductModal.h
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface ProductModal : BaseModel 

@property (nonatomic, copy) NSString *AdvertText;//广告文本

@property (nonatomic, copy) NSString *ID;//产品ID(用于收藏)
@property (nonatomic, copy) NSString *PicUrl;//
@property (nonatomic, copy) NSString *Name;//产品介绍
@property (nonatomic, copy) NSString *Code;//产品编号
@property (nonatomic, copy) NSString *PersonPrice;//门市价
@property (nonatomic, copy) NSString *PersonPeerPrice;//同行价
@property (nonatomic, copy) NSString *PersonProfit;//利润
@property (nonatomic, copy) NSString *PersonBackPrice;//加返
@property (nonatomic, copy) NSString *PersonCashCoupon;//券
@property (nonatomic, copy) NSString *StartCityName;//出发城市名称
@property (copy , nonatomic) NSString *IsComfirmStockNow;//是否闪电发班
@property (strong , nonatomic) NSNumber *StartCity;//出发城市编号
@property (copy,nonatomic) NSString *LastScheduleDate;//最近班期
@property (copy,nonatomic) NSString *SupplierName;//供应商
@property (copy , nonatomic) NSString *IsFavorites;//是否收藏
@property (copy,nonatomic) NSString *ContactName;//联系人名称
@property (copy,nonatomic) NSString *ContactMobile;//联系人电话
@property (copy,nonatomic) NSString *LinkUrl;//产品详情页

@property (nonatomic,copy) NSString *IsOffLine;// 是否离线
@property (nonatomic,copy) NSString *HistoryViewTime;// 历史流浪时间
@property (nonatomic,strong) NSMutableDictionary *ShareInfo;
@property (nonatomic , copy)NSString * PushDate;


//新加字段
@property (nonatomic, copy)NSString *PersonAlternateCash;//成人抵用券
@property (nonatomic, copy)NSString *SendCashCoupon;//下单送券金额

+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
