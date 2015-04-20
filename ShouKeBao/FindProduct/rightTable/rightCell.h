//
//  rightCell.h
//  ShouKeBao
//
//  Created by David on 15/3/16.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "rightModal.h"
@class rightModal;
@interface rightCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;
//@property (weak, nonatomic) IBOutlet UILabel *rightDescrip;
@property (weak, nonatomic) IBOutlet UILabel *rightDescrip;

@property (weak, nonatomic) IBOutlet UILabel *rightPrice;
@property (strong , nonatomic) rightModal *modal;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
