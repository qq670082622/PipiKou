//
//  ImageCollectionCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/7/21.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recommend.h"
@interface ImageCollectionCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *countryLable;
@property (nonatomic, strong)UILabel *moneyLable;
@property (nonatomic, strong)UIView *shineView;

@property (nonatomic,strong) Recommend *recommend;

@property (nonatomic, strong)NSMutableArray *photoArr;
@end
