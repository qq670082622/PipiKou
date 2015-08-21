//
//  LeftTableCell.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "LeftTableCell.h"
#import "UIImageView+WebCache.h"
@implementation LeftTableCell

- (void)awakeFromNib {
    
    if ([UIScreen mainScreen].bounds.size.width == 414) {
//        self.iconImage.frame = CGRectMake(21, 8, 32, 18);
    }

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.selected) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.leftName.textColor = [UIColor orangeColor];
    }else{
        self.contentView.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
        self.leftName.textColor = [UIColor blackColor];
    }
    // Configure the view for the selected state
}
-(void)layoutSubviews
{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
}

-(void)setModel:(leftModal *)model{
    _model = model;
    self.leftName.text = model.Name;
    if (self.isSelected) {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.MaxIconFocus] placeholderImage:nil];
    }else{
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.MaxIcon] placeholderImage:nil];
    }
    
}
@end
