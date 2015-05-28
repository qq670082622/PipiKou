//
//  tableviewCell.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

#define gap 10

@class HomeList;

@interface ShouKeBaoCell : MGSwipeTableCell

// 图标
@property (nonatomic,weak) UIImageView *iconView;
// 标题
@property (nonatomic,weak) UILabel *titleLab;
// 时间
@property (nonatomic,weak) UILabel *timeLab;
//出发时间
@property (nonatomic,weak) UILabel *goDate;
// 左边待定内容
@property (nonatomic,weak) UILabel *leftLab;
// 右边待定内容 人数
@property (nonatomic,weak) UILabel *rightLab;
// 详情
@property (nonatomic,weak) UILabel *detailLab;
//编号
@property (nonatomic,weak) UILabel *codeLab;

@property (nonatomic,strong) HomeList *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
