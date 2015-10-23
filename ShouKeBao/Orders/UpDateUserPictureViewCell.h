//
//  UpDateUserPictureViewCell.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/21.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    UnCheckedState,
    CheckedState
}CellState;

@interface UpDateUserPictureViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *theUserImage;
@property (strong, nonatomic) IBOutlet UIImageView *cellStateImage;
@property (nonatomic, copy)NSString *cellPicUrl;
@property (nonatomic, copy)NSString *cellCutomerID;
@property (nonatomic, assign)CellState cellState;

@end
