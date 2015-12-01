//
//  Double12TableViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubleModel.h"
@interface Double12TableViewCell : UITableViewCell

@property (nonatomic,weak) UIImageView *iconView;// 图标
@property (nonatomic,weak) UILabel *titleLab;// 标题
@property (nonatomic,weak) UILabel *timeLab;// 时间
@property (nonatomic,weak) UILabel *redLable;//红色字部分
@property (nonatomic,weak) UILabel *detailLable;// 详情
@property (nonatomic,weak) UIImageView *doubleImage;//双12大图片
@property (nonatomic,strong)DoubleModel *doubleModel;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
