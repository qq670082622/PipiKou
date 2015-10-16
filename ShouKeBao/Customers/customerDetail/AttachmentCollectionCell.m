//
//  AttachmentCollectionCell.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/16.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "AttachmentCollectionCell.h"

@implementation AttachmentCollectionCell

-(void)setCellState:(CellState)cellState{
    _cellState = cellState;
    if (cellState == NormalState) {
        self.cellStateImage.image = nil;
    }else if (cellState == CheckedState){
        self.cellStateImage.image = [UIImage imageNamed:@"check"];
    }else if(cellState == UnCheckedState){
        self.cellStateImage.image = [UIImage imageNamed:@"uncheck"];
    }
}

@end
