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

@property (weak, nonatomic) UIButton *jiafanBtn;
@property (weak, nonatomic) UIButton *quanBtn;
@property (weak, nonatomic) UIButton *ShanDianBtn;

@property (nonatomic,weak) UIImageView *flash;

@property (nonatomic,assign) BOOL isFlash;


@property (strong, nonatomic) ProductModal *modal;

+(instancetype)cellWithTableView:(UITableView *)tableView;


@end
