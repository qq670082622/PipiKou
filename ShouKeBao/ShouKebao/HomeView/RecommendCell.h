//
//  RecommendCell.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShouKeBaoCell.h"

@class Recommend;

@interface RecommendCell : ShouKeBaoCell

@property (nonatomic,strong) Recommend *recommend;

@property (nonatomic,weak) UIImageView *redTip;// 红点

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
