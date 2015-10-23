//
//  RecentlyCell.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "recentlyModel.h"
#import "recentlyModel.h"
@interface RecentlyCell : UITableViewCell
@property (weak, nonatomic) UILabel *title;
@property (weak, nonatomic) UIImageView *icon;
@property (weak, nonatomic) UILabel *productNum;
@property (weak, nonatomic) UILabel *normalPrice;
@property (weak, nonatomic) UILabel *cheapPrice;
@property (weak, nonatomic) UILabel *profits;

@property (weak, nonatomic) UIButton *jiafanBtn;
@property (weak, nonatomic) UIButton *quanBtn;
@property (weak, nonatomic) UIButton *ShanDianBtn;

@property (nonatomic,weak) UIImageView *flash;

@property (nonatomic,assign) BOOL isFlash;
@property (nonatomic,assign) BOOL quanIsZero;
@property (nonatomic,assign) BOOL fanIsZero;

@property (nonatomic,weak) UILabel *time;// 浏览时间

@property (nonatomic,weak) UIView *sep;// 线条

@property (strong, nonatomic) recentlyModel *modal;

@property (nonatomic,assign) BOOL isHistory;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
