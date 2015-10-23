//
//  QRSaveToCustomerTableViewCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/20.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "QRSaveToCustomerTableViewCell.h"

@implementation QRSaveToCustomerTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuse = @"saveCumster";
    QRSaveToCustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[QRSaveToCustomerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    return cell;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *nameL = [[UILabel alloc]init];
        nameL.font = [UIFont boldSystemFontOfSize:18.0f];
        self.nameL = nameL;
        [self.contentView addSubview:_nameL];
        
        UILabel *telL = [[UILabel alloc]init];
        telL.font = [UIFont systemFontOfSize:13.0f];
        telL.textColor = [UIColor grayColor];
        self.telNumberL = telL;
        [self.contentView addSubview:_telNumberL];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = 60;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
   
    self.nameL.frame = CGRectMake(5, 0, screenW-5, height/2);
    self.telNumberL.frame = CGRectMake(5, height/2, screenW-5, height/2);
}

- (void)setModel:(CustomModel *)model{
    _model = model;
    self.nameL.text = self.model.Name;
    self.telNumberL.text = self.model.Mobile;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
