//
//  YesterDayCell.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DayDetail;
@interface YesterDayCell : UITableViewCell
@property (weak, nonatomic) UILabel *title;
@property (weak, nonatomic) UIImageView *icon;
@property (weak, nonatomic) UILabel *productNum;
@property (weak, nonatomic) UILabel *normalPrice;
@property (weak, nonatomic) UILabel *cheapPrice;
@property (weak, nonatomic) UILabel *profits;
@property (weak, nonatomic) UILabel *diLab;
@property (weak, nonatomic) UILabel *songLab;

//@property (weak, nonatomic) UIButton *jiafanBtn;
//@property (weak, nonatomic) UIButton *quanBtn;
@property (weak, nonatomic) UIButton *li;
@property (weak, nonatomic) UIButton *di;
@property (weak, nonatomic) UIButton *song;
@property (weak, nonatomic) UIButton *ShanDianBtn;

@property (nonatomic,weak) UIButton *flash;

@property (nonatomic,assign) BOOL isFlash;
@property (nonatomic,assign) BOOL quanIsZero;
@property (nonatomic,assign) BOOL fanIsZero;

@property (nonatomic,weak) UILabel *time;// 浏览时间

@property (nonatomic,weak) UIView *sep;// 线条
@property (nonatomic,weak) UIView *line;
@property (nonatomic,weak) UIView *longLine;

@property (nonatomic,assign) BOOL isHistory;

@property (nonatomic,weak) UILabel *goDateLab;//出发lab
@property (nonatomic,weak) UIButton *shareBtn;//分享按钮

@property (strong, nonatomic)  DayDetail*modal;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,weak) UILabel *warningLab;

@end
