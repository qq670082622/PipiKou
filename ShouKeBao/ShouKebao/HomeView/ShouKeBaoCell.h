//
//  tableviewCell.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeList;

@interface ShouKeBaoCell : UITableViewCell

@property (nonatomic,strong) HomeList *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
