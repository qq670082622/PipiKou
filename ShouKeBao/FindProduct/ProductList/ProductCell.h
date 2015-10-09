//
//  ProductCell.h
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModal.h"
#import "MGSwipeTableCell.h"

#define gap 10

@class ProductModal;
@interface ProductCell : MGSwipeTableCell


@property (weak, nonatomic) UILabel *title;
@property (weak, nonatomic) UIImageView *icon;
@property (weak, nonatomic) UILabel *productNum;
@property (weak, nonatomic) UILabel *normalPrice;
@property (weak, nonatomic) UILabel *cheapPrice;
@property (weak, nonatomic) UILabel *profits;
@property (weak, nonatomic) UILabel *diLab;
@property (weak, nonatomic) UILabel *songLab;

@property (weak, nonatomic) UIButton *li;
@property (weak, nonatomic) UIButton *di;
@property (weak, nonatomic) UIButton *song;
@property (weak, nonatomic) UIButton *jiafanBtn;
@property (weak, nonatomic) UIButton *quanBtn;
@property (weak, nonatomic) UIButton *ShanDianBtn;

@property (nonatomic,weak) UIButton *flash;

@property (nonatomic,assign) BOOL isFlash;
@property (nonatomic,assign) BOOL quanIsZero;
@property (nonatomic,assign) BOOL fanIsZero;

@property (nonatomic,weak) UILabel *time;// 浏览时间
@property (nonatomic,weak) UIView *line;// xixian
@property (nonatomic,weak) UIView *sep;// 线条

@property (strong, nonatomic) ProductModal *modal;

@property (nonatomic,assign) BOOL isHistory;
@property (nonatomic,strong) UILabel * undercarriageView;//下架产品lab
@property (nonatomic, strong)UIButton * RelatedBtn;//相关产品按钮
@property (nonatomic, strong)UINavigationController * MylistVCNav;

+(instancetype)cellWithTableView:(UITableView *)tableView;




@end
