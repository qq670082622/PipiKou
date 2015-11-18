//
//  NewCustomerCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import "NewCustomerCell.h"
#import "CustomDynamicModel.h"
#import "UIImageView+WebCache.h"
@implementation NewCustomerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(CustomDynamicModel *)model{
    _model = model;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.HeadUrl] placeholderImage:[UIImage imageNamed:@"customtouxiang"]];
    if ([model.DynamicType intValue]==1) {
        self.TitleImage.image = [UIImage imageNamed:@"dongtaixin"];
    }else if([model.DynamicType intValue]==2){
        self.TitleImage.image = [UIImage imageNamed:@"dongtaizhanghu"];
    }
    self.TimeLabel.text = model.CreateTimeText;
    self.titleLabel.text = model.DynamicContent;
    self.custNameLabel.text = model.NickName;
    self.custNumLabel.text = model.CustomerMobile;
}
@end
