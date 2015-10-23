//
//  QRPhotoCollectionViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/14.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "personIdModel.h"

typedef enum{
    UnChoosedState,
    ChoosedState
}cellState;


@interface QRPhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)personIdModel *model;
@property (weak, nonatomic) UIImageView *cancle;

@property (nonatomic, assign)BOOL chooseFlag;
@property (nonatomic, assign)BOOL unchooseFlag;
@property (nonatomic, assign)cellState cellState;


- (void)switchChoosePhoto;


@end
