//
//  messageCell.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "messageCell.h"

@implementation messageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{ static NSString *cellID = @"messageCell";
    messageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"messageCell" owner:nil options:nil] lastObject];
        
    }
    return cell;
}

-(void)setModel:(messageModel *)model
{
    _model = model;
    self.title.text = model.title;
    self.time.text = model.CreatedDate;
    
}
@end
