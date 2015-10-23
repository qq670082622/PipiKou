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

@interface DayDetailCell : UITableViewCell//MGSwipeTableCell

@property (weak, nonatomic) UILabel *title;
@property (weak, nonatomic) UIImageView *icon;
@property (weak, nonatomic) UILabel *productNum;
@property (weak, nonatomic) UILabel *normalPrice;
@property (weak, nonatomic) UILabel *cheapPrice;
@property (weak, nonatomic) UILabel *profits;

@property (weak, nonatomic) UILabel *diLab;
@property (weak, nonatomic) UILabel *songLab;
@property (nonatomic,weak) UIView *line;// xixian
@property (nonatomic,weak) UIView *longLine;// 分割线

@property (weak, nonatomic) UIButton *li;
@property (weak, nonatomic) UIButton *di;
@property (weak, nonatomic) UIButton *song;
//@property (weak, nonatomic) UIButton *jiafanBtn;
//@property (weak, nonatomic) UIButton *quanBtn;
@property (weak, nonatomic) UIButton *ShanDianBtn;

@property (nonatomic,weak) UIButton *flash;

@property (nonatomic,assign) BOOL isFlash;
@property (nonatomic,assign) BOOL quanIsZero;
@property (nonatomic,assign) BOOL fanIsZero;

@property (nonatomic,weak) UILabel *time;// 浏览时间

@property (nonatomic,weak) UIView *sep;// 线条



@property (nonatomic,assign) BOOL isHistory;


@property (nonatomic,weak) UILabel *descripLab;//描述lab
@property (nonatomic,weak) UIButton *descripBtn;//描述按钮
@property (nonatomic,weak) UILabel *goDateLab;//出发lab
@property (nonatomic,weak) UIButton *shareBtn;//分享按钮
+(instancetype)cellWithTableView:(UITableView *)tableView withTag:(NSInteger)tag;
@property (nonatomic,copy) DayDetail *detail;

@property (nonatomic,assign) BOOL isPlain;
//@property (nonatomic,assign)NSInteger btnTag;

@property (nonatomic,assign) CGFloat rouHei;



@end
