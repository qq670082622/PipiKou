//
//  TerraceMessCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import "TerraceMessCell.h"
#import "TerraceMessageModel.h"
#import "UIImageView+WebCache.h"
@implementation TerraceMessCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(TerraceMessageModel *)model{
    _model = model;
    self.TitleLabel.text = model.Title;
    self.DataLabel.text = model.CreatedDateText;
    self.BodyLabel.text = model.Description;
    [self.Imageview sd_setImageWithURL:[NSURL URLWithString:model.BannerUrl] placeholderImage:[UIImage imageNamed:@"huanxinheader"]];
}
@end
