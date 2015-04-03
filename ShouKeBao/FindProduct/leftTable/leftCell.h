//
//  leftCell.h
//  ShouKeBao
//
//  Created by David on 15/3/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "leftModal.h"
@class leftModal;
@interface leftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) leftModal *modal;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
