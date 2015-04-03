//
//  leftCell.m
//  ShouKeBao
//
//  Created by David on 15/3/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "leftCell.h"

@implementation leftCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{ static NSString *cellID = @"cell1";
    leftCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"leftCell" owner:nil options:nil] lastObject];
        
    }
    return cell;
}

-(void)setModal:(leftModal *)modal
{
    _modal = modal;
    self.name.text = modal.Name;
}
@end
