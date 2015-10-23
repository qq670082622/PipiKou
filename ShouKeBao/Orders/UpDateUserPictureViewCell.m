//
//  UpDateUserPictureViewCell.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/21.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "UpDateUserPictureViewCell.h"

@implementation UpDateUserPictureViewCell
-(void)setCellState:(CellState)cellState{
    _cellState = cellState;
    if (cellState == CheckedState){
        self.cellStateImage.image = [UIImage imageNamed:@"check"];
    }else if(cellState == UnCheckedState){
        self.cellStateImage.image = [UIImage imageNamed:@"uncheck"];
    }
}

@end
