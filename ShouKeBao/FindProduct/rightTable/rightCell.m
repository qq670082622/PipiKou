//
//  rightCell.m
//  ShouKeBao
//
//  Created by David on 15/3/16.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "rightCell.h"

#import "UIImageView+WebCache.h"
#import "ResizeImage.h"
@interface rightCell()//

@end

@implementation rightCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{ static NSString *cellID = @"cell2";
    rightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"rightCell" owner:nil options:nil] lastObject];
     }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)layoutSubviews
{
    [super layoutSubviews];

self.rightIcon.frame = CGRectMake(8, 12, 50, 50);
    
self.rightIcon.contentMode = UIViewContentModeScaleToFill;
        
    
}


-(void)setModal:(rightModal *)modal
{
    _modal = modal;
    
    [self.rightIcon sd_setImageWithURL:[NSURL URLWithString:modal.rightIcon] placeholderImage:[UIImage imageNamed:@"lvyouquanIcon"]];
       self.rightDescrip.text = modal.rightDescrip;
    
   
   self.rightPrice.text = [NSString stringWithFormat:@"￥%@",modal.rightPrice];
    
    
}






@end
