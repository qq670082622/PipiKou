//
//  remondTableViewCell.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "remondModel.h"
@class remondModel;
@interface remondTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (strong,nonatomic) remondModel  *model;
+(instancetype)cellWithTableView:(UITableView *)table;
@end
