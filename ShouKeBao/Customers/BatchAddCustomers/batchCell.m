//
//  batchCell.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "batchCell.h"

@implementation batchCell

- (void)awakeFromNib {
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)table
{
    static NSString *cellID = @"batchCell";
    batchCell *cell = [table dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"batchCell" owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return cell;
}
-(void)setModel:(batchModel *)model
{
    _model = model;
    self.name.text = model.name;
   //self.email.text = model.email;
    //self.recordId.text = model.recordID;
    self.tele.text = model.tel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
