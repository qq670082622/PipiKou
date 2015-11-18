//
//  OpportunitykeywordCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import "OpportunitykeywordCell.h"
#import "CustomDynamicModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+FKTools.h"
@implementation OpportunitykeywordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(CustomDynamicModel *)model{
    _model = model;
    [self.HeadImage sd_setImageWithURL:[NSURL URLWithString:model.HeadUrl] placeholderImage:[UIImage imageNamed:@"customtouxiang"]];
    self.TitleImage.image = [UIImage imageNamed:@"dongtaichanpin"];
    self.TimerLabel.text = model.CreateTimeText;
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:[model.DynamicContent stringByReplacingOccurrencesOfString:@"@" withString:@""]];
        //创建正则表达式；pattern规则；
        NSString * pattern = @"@.+@";
        NSRegularExpression * regex = [[NSRegularExpression alloc]initWithPattern:pattern options:0 error:nil];
        //测试字符串；
        NSArray * result = [regex matchesInString:model.DynamicContent options:0 range:NSMakeRange(0,model.DynamicContent.length)];
    if (result.count) {
        //获取筛选出来的字符串
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(((NSTextCheckingResult *)result[0]).range.location, ((NSTextCheckingResult *)result[0]).range.length-2)];
    }
    self.TitleLabel.attributedText = str;
    self.topTitleLab.text = model.DynamicTitle;
    self.CustNameLabel.text = model.NickName;
    self.ContactNumLabel.text = model.CustomerMobile;

}

@end
