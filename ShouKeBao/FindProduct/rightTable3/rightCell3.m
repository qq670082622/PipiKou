//
//  rightCell3.m
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "rightCell3.h"
#import "WMAnimations.h"
@implementation rightCell3//

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{ static NSString *cellID = @"cell4";
    rightCell3 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"rightCell3" owner:nil options:nil] lastObject];
   }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
} 

-(void)setModal:(rightModal3 *)modal
{
    self.name.text = [NSString stringWithFormat:@"%@",modal.Name];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
