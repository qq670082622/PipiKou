//
//  remondTableViewCell.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "remondTableViewCell.h"
#import "NSDate+Category.h"

@implementation remondTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)table
{
    static NSString *cellID = @"remondCell";
    remondTableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"remondTableViewCell" owner:nil options:nil] lastObject];
        cell = [[remondTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:34/255.0 green:92/255.0 blue:199/255.0 alpha:1];
    }
 // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect1 = self.textLabel.frame;
    rect1.origin.y -= 3;
    self.textLabel.frame = rect1;
    
    CGRect rect = self.detailTextLabel.frame;
    rect.origin.y = CGRectGetMaxY(self.textLabel.frame) + 5;
    self.detailTextLabel.frame = rect;
}

- (void)setModel:(remondModel *)model
{
    _model = model;
//    self.desLabel.text = model.Content;
//    
//    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[model.RemindTime doubleValue]];
//    self.time.text = [createDate formattedTime];
    self.textLabel.text = model.Content;
    
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[model.RemindTime doubleValue]];
    self.detailTextLabel.text = [createDate formattedTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  
}

@end
