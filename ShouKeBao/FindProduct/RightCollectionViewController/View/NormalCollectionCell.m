//
//  NormalCollectionCell.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NormalCollectionCell.h"

@implementation NormalCollectionCell
-(void)setSelected:(BOOL)selected{
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
    
}
@end
