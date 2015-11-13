//
//  messageCellSKBTableViewCell.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/6/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "MessageModel2.h"
#define gap 10
@class messageModel;
@interface messageCellSKBTableViewCell : MGSwipeTableCell
// 图标
@property (nonatomic,weak) UIImageView *iconView;
// 标题
@property (nonatomic,weak) UILabel *titleLab;
// 时间
@property (nonatomic,weak) UILabel *timeLab;
// 详情
@property (nonatomic,weak) UILabel *detailLab;

@property(nonatomic,strong) messageModel *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
