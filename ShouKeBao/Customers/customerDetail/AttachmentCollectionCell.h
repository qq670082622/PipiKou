//
//  AttachmentCollectionCell.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/16.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    NormalState,
    UnCheckedState,
    CheckedState
}CellState;


@interface AttachmentCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *theUserImage;
@property (strong, nonatomic) IBOutlet UIImageView *cellStateImage;
@property (nonatomic, copy)NSString *cellPicUrl;
@property (nonatomic, copy)NSString *cellBigPicUrl;
@property (nonatomic, assign)CellState cellState;
@end
