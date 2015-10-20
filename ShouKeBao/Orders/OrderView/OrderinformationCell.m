//
//  OrderinformationCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/20.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "OrderinformationCell.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@implementation OrderinformationCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    //预定产品
    ScheduleProductLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, kScreenSize.width-10, 35)];
    ScheduleProductLabel.numberOfLines = 2;
    ScheduleProductLabel.font = [UIFont systemFontOfSize:14];
    ScheduleProductLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:ScheduleProductLabel];
    
    //下单时间
    CustomerTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 35, kScreenSize.width-10, 20)];
    CustomerTimeLabel.font = [UIFont systemFontOfSize:14];
    CustomerTimeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:CustomerTimeLabel];
    
    //供应商
    SupplybusinessLabel = [[UILabel alloc] initWithFrame:CGRectMake(21.5, 55, kScreenSize.width-21.5, 20)];
    SupplybusinessLabel.font = [UIFont systemFontOfSize:14];
    SupplybusinessLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:SupplybusinessLabel];
    
    //出游时间
    GoSightseeingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 75, kScreenSize.width-10, 20)];;
    GoSightseeingTimeLabel.font = [UIFont systemFontOfSize:14];
    GoSightseeingTimeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:GoSightseeingTimeLabel];
    
    //出团人数
    TermOfNumbersLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 95, kScreenSize.width-10, 20)];
    TermOfNumbersLabel.font = [UIFont systemFontOfSize:14];
    TermOfNumbersLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:TermOfNumbersLabel];
    
    //订单状态
    CustomerstateLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 115, kScreenSize.width-10, 20)];
    CustomerstateLabel.font = [UIFont systemFontOfSize:14];
    CustomerstateLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:CustomerstateLabel];
    
    //发票信息
    //UIView *Invoicebg
}
-(void)showDatawWithMe{
        ScheduleProductLabel.text = @"预定产品 :";
        CustomerTimeLabel.text = @"下单时间 :";
        SupplybusinessLabel.text = @"供应商 :";
        GoSightseeingTimeLabel.text = @"出游日期 :";
        TermOfNumbersLabel.text = @"出团人数 :";
        CustomerstateLabel.text = @"订单状态 :";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
