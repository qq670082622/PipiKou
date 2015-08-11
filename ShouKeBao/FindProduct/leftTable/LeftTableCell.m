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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.MaxIcon] placeholderImage:nil];
    
    
}
@end
