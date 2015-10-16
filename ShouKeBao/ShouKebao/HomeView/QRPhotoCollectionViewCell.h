//
//  QRPhotoCollectionViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/14.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRPhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *cancle;
@property (weak, nonatomic) IBOutlet UIButton *save;

+(instancetype)relationXib;



@end
