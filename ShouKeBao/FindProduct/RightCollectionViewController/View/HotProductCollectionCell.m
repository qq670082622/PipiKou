//
//  HotProductCollectionCell.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "HotProductCollectionCell.h"
#import "rightModal.h"
#import "UIImageView+WebCache.h"
@implementation HotProductCollectionCell
-(void)awakeFromNib{

}
-(void)setModal:(rightModal *)modal{
    _modal = modal;
    [self.rightIcon sd_setImageWithURL:[NSURL URLWithString:modal.rightIcon] placeholderImage:[UIImage imageNamed:@"lvyouquanIcon"]];
    self.rightDescrip.text = modal.rightDescrip;
    self.rightPrice.text = [NSString stringWithFormat:@"￥%@",modal.rightPrice];
}
-(void)setSelected:(BOOL)selected{
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }

}
@end
