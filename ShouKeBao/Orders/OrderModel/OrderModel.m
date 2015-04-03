//
//  OrderModel.m
//  ShouKeBao
//
//  Created by Chard on 15/3/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "OrderModel.h"
#import "ButtonList.h"
#import "UIColor+SK.h"

@implementation OrderModel

+ (instancetype)orderModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.ProgressState = dict[@"ProgressState"];// 进度
        
        self.StateText = dict[@"StateText"];// 状态文字
        
        self.ProductPicUrl = dict[@"ProductPicUrl"];// 旅游图标
        
        // 状态文字颜色
        self.StateTextColor = [UIColor configureColorWithNum:[dict[@"StateTextColor"] integerValue]];
        
        // 上线条颜色
        self.TopBarColor = [UIColor configureColorWithNum:[dict[@"TopBarColor"] integerValue]];
        
        self.ProductName = dict[@"ProductName"];// 旅游标题
        
        self.OrderPrice = dict[@"OrderPrice"];// 价格
        
        self.IsCruiseShip = dict[@"IsCruiseShip"];// 是否游轮 是就显示 成人 + 小孩 (人数)
        
        self.PersonCount = dict[@"PersonCount"];// 成人数
        
        self.ChildCount = dict[@"ChildCount"];// 小孩数
        
        self.CreatedDate = dict[@"CreatedDate"];// 创建时间
        
        self.GoDate = dict[@"GoDate"];// 出发时间
        
        self.Code = dict[@"Code"];// 订单编号
        
        self.DetailLinkUrl = dict[@"DetailLinkUrl"];
        
        if (![dict[@"SKBOrder"] isKindOfClass:[NSNull class]]) {
            self.SKBOrder = dict[@"SKBOrder"];
        }
        
        self.FollowPerson = dict[@"FollowPerson"];

        // 返回底部按钮组
        for (NSDictionary *dic in dict[@"ButtonList"]) {
            ButtonList *btn = [ButtonList buttonListWithDict:dic];
            [self.buttonList addObject:btn];
        }
        NSLog(@"-----%@",dict[@"ButtonList"]);
    }
    return self;
}

- (NSString *)Code
{
    return [NSString stringWithFormat:@"订单号:%@",_Code];
}

- (NSString *)GoDate
{
    return [NSString stringWithFormat:@"%@出发",_GoDate];
}

- (NSMutableArray *)buttonList
{
    if (!_buttonList) {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}

@end
