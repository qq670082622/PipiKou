//
//  LeftTableCell.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "leftModal.h"
@interface LeftTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *leftName;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconImageW;

@property (nonatomic, strong)  leftModal * model;
@end
