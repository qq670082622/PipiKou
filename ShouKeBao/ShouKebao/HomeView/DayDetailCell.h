//
//  DayDetailCell.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@class DayDetail;

@interface DayDetailCell : MGSwipeTableCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,copy) DayDetail *detail;

@end
