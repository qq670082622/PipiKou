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
        cell = [[[NSBundle mainBundle] loadNibNamed:@"remondTableViewCell" owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setModel:(remondModel *)model
{
    _model = model;
    self.desLabel.text = model.Content;
    
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[model.RemindTime doubleValue]];
    self.time.text = [createDate formattedTime];
   }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  
}

@end
