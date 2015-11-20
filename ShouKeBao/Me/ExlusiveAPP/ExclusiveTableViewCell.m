//
//  ExclusiveTableViewCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ExclusiveTableViewCell.h"

@implementation ExclusiveTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellID = @"ExclusiveTableViewCell";
    ExclusiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExclusiveTableViewCell" owner:nil options:nil] lastObject];
    }
    
    
    return cell;
}



- (void)setModel:(MeShareDetailModel *)model{
    _model = model;
    
    self.builtCount.text = [NSString stringWithFormat:@"%@人",  model.Installed];
    self.productCount.text = [NSString stringWithFormat:@"%@人",model.ProductBrowse];
    self.livingCount.text = [NSString stringWithFormat:@"%@人",model.ActiveUser];
    self.placeCount.text = [NSString stringWithFormat:@"%@单",model.OrderQuantity];
    
    self.H_builtCount.text = [NSString stringWithFormat:@"%@人", model.InstalledTotal];
    self.H_productCount.text = [NSString stringWithFormat:@"%@人",model.ProductBrowseTotal];
    self.H_livingCount.text = [NSString stringWithFormat:@"%@人", model.ActiveUserTotal];
    self.H_placeCount.text = [NSString stringWithFormat:@"%@单",model.OrderQuantityTotal];
    
  
}







- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
