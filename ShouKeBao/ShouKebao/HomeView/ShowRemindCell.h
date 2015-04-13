//
//  ShowRemindCell.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShouKeBaoCell.h"

@class remondModel;

@interface ShowRemindCell : ShouKeBaoCell

@property (nonatomic,strong) remondModel *remind;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
