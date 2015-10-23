//
//  ChildCell.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/5/6.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ChildCell.h"

@implementation ChildCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"childcell";
    ChildCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChildCell" owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    
    self.iconView.layer.cornerRadius = self.iconView.frame.size.height * 0.5;
    self.iconView.layer.masksToBounds = YES;
}

@end
