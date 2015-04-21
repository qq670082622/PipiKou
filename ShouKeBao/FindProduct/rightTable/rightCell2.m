//
//  rightCell2.m
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "rightCell2.h"
#import "WMAnimations.h"
@implementation rightCell2//

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{ static NSString *cellID = @"cell3";
    rightCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"rightCell2" owner:nil options:nil] lastObject];
        }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [WMAnimations WMAnimationMakeBoarderWithLayer:cell.subView.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.5 andNeedShadow:YES];
    
    return cell;
}

-(void)setModal:(rightModal2 *)modal
{
    self.title.text = modal.title;
    self.descript.text = modal.Name;
}

@end
