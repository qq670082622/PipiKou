//
//  HotProductCollectionCell.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class rightModal;
@interface HotProductCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;
//@property (weak, nonatomic) IBOutlet UILabel *rightDescrip;
@property (weak, nonatomic) IBOutlet UILabel *rightDescrip;

@property (weak, nonatomic) IBOutlet UILabel *rightPrice;
@property (strong , nonatomic) rightModal *modal;

@end
