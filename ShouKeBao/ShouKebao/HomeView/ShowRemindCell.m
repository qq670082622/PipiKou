//
//  ShowRemindCell.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ShowRemindCell.h"
#import "remondModel.h"
#import "NSDate+Category.h"

@implementation ShowRemindCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"showremindcell";
    ShowRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ShowRemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLab.textColor = [UIColor colorWithRed:245/255.0 green:144/255.0 blue:0 alpha:1];
    }
    return self;
}

- (void)setRemind:(remondModel *)remind
{
    _remind = remind;
    
    self.iconView.image = [UIImage imageNamed:@"tixing"];
    
    self.titleLab.text = @"提醒通知";
    self.timeLab.textColor = [UIColor blueColor];
    
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[remind.RemindTime doubleValue]];
    self.timeLab.text = [createDate formattedTime];
    
    self.leftLab.text = [NSString stringWithFormat:@"姓名:%@",remind.name];
    
    self.rightLab.text = [NSString stringWithFormat:@"电话:%@",remind.phone];
    
    self.detailLab.text = remind.Content;
}

@end
