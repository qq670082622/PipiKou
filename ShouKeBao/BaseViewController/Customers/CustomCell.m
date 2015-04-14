//
//  CustomCell.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CustomCell.h"
#import "UIImageView+WebCache.h"
#import "IWHttpTool.h"
@implementation CustomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{ static NSString *cellID = @"customCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil] lastObject];
       
              }
    return cell;
}

-(void)setModel:(CustomModel *)model
{
    _model = model;
    self.userIcon.image =  [UIImage imageNamed:@"quanquange"];
    self.userName.text = model.Name;
    self.userTele.text = [NSString stringWithFormat:@"电话：%@",model.Mobile];
    self.userOders.text = [NSString stringWithFormat:@"订单数：%@",model.OrderCount];
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:model.ID forKey:@"CustomerID"];
//    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomerRemindList" params:dic success:^(id json) {
//        NSMutableArray *remindList = json[@"CustomerRemindList"];
//        if (remindList.count>0) {
//            self.detailBtn.hidden = NO;
//        }
//        } failure:^(NSError *error) {
//        NSLog(@"客户提醒列表请求错误 %@",error);
//    }];
    }

@end
