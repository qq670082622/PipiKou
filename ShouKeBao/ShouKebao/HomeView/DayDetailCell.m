//
//  DayDetailCell.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "DayDetailCell.h"
#import "DayDetail.h"

@interface DayDetailCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *aPriceLab;

@property (weak, nonatomic) IBOutlet UILabel *bPriceLab;

@end

@implementation DayDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"daydetailcell";
    DayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DayDetailCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setDetail:(DayDetail *)detail
{
    _detail = detail;
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

@end
