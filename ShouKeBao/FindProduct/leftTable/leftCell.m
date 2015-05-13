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
{
    static NSString *cellID = @"cellaaaa";
    leftCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"leftCell" owner:nil options:nil] lastObject];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, 100, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line ];
       
    }
    return cell;
}
-(void)layoutSubviews
{
    if ([self.name.text  isEqual: @"东南亚、南亚"]) {
        self.name.frame = CGRectMake(40, 0, 50, 50);
    }
}

-(void)setModal:(leftModal *)modal
{
    _modal = modal;
    self.name.text = modal.Name;
    
}
@end
