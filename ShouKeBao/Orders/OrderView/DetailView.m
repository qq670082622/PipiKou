//
//  DetailView.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "DetailView.h"
#import "OrderTool.h"
@interface DetailView()

@property (weak, nonatomic) IBOutlet UILabel *original;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *tradePrice;

@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *remark;

@end

@implementation DetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DetailView" owner:nil options:nil] lastObject];
    }
    return self;
}

//- (void)setData:(NSDictionary *)data
//{
//    _data = data;
//    
//    self.original.text = [NSString stringWithFormat:@"订单来源: %@",data[@"FromType"]];
//    self.price.text = [NSString stringWithFormat:@"订单金额: %@",data[@"OrderPrice"]];
//    self.tradePrice.text = [NSString stringWithFormat:@"总同行价: %@",data[@"OrderPeerPrice"]];
//    self.createTime.text = [NSString stringWithFormat:@"下单时间: %@",data[@"CreatedDate"]];
//    self.name.text = [NSString stringWithFormat:@"姓名: %@",data[@"CustomerName"]];
//    self.phoneNum.text = [NSString stringWithFormat:@"联系方式: %@",data[@"CustomerMobile"]];
//    self.remark.text = [NSString stringWithFormat:@"备注信息: %@",data[@"Remark"]];
//}
- (void)setOrderId:(NSString *)orderId{
    _orderId = orderId;
    NSDictionary *param = @{@"OrderId":self.orderId};
    [OrderTool getOrderDetailWithParam:param success:^(id json) {
        self.original.text = [NSString stringWithFormat:@"订单来源: %@",json[@"OrderSource"]];
        self.price.text = [NSString stringWithFormat:@"订单金额: %@",json[@"OrderPrice"]];
        self.tradePrice.text = [NSString stringWithFormat:@"总同行价: %@",json[@"PeerPrice"]];
        self.createTime.text = [NSString stringWithFormat:@"下单时间: %@",json[@"CreatedDate"]];
        self.name.text = [NSString stringWithFormat:@"姓名: %@",json[@"Name"]];
        self.phoneNum.text = [NSString stringWithFormat:@"联系方式: %@",json[@"Mobile"]];
        self.remark.text = [NSString stringWithFormat:@"备注信息: %@",json[@"Remark"]];

    } failure:^(NSError *error) {
        
    }];

}
- (IBAction)close:(id)sender
{
    [self.superview removeFromSuperview];
}

@end
