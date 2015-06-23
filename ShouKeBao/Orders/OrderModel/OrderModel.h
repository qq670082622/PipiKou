//
//  OrderModel.h
//  ShouKeBao
//
//  Created by Chard on 15/3/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
    1 灰色 2蓝色 3橙色 4绿色 5红色 6紫色
 */
#import "BaseModel.h"
@interface OrderModel : BaseModel

@property (nonatomic,copy) NSString *ProgressState;// 进度

@property (nonatomic,copy) NSString *StateText;// 状态文字

@property (nonatomic,strong) UIColor *StateTextColor;// 状态文字颜色

@property (nonatomic,strong) UIColor *TopBarColor;// 上线条颜色

@property (nonatomic,copy) NSString *ProductName;// 旅游标题

@property (nonatomic,copy) NSString *OrderPrice;// 价格

@property (nonatomic,copy) NSString *IsCruiseShip;// 是否游轮 是就显示 成人 + 小孩 (人数)

@property (nonatomic,copy) NSString *PersonCount;// 成人数

@property (nonatomic,copy) NSString *ChildCount;// 小孩数

@property (nonatomic,copy) NSString *CreatedDate;// 创建时间

@property (nonatomic,copy) NSString *GoDate;// 出发时间

@property (nonatomic,copy) NSString *Code;// 订单编号

@property (nonatomic,copy) NSString *State;//暂时用不到

@property (nonatomic,copy) NSString *ProductPicUrl;// 旅游图标

@property (nonatomic,copy) NSString *DetailLinkUrl;

@property (nonatomic,strong) NSDictionary *SKBOrder;

@property (nonatomic,strong) NSMutableArray *buttonList;// 返回底部按钮组

@property (nonatomic,strong) NSDictionary *FollowPerson;

@property (nonatomic, strong) NSString * OrderId;

+ (instancetype)orderModelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
