//
//  ProductHistoryCell.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ProductHistoryCell.h"

@interface ProductHistoryCell()

@property (nonatomic,weak) UILabel *customer;// 客户类型

@property (nonatomic,weak) UILabel *time;// 浏览时间

@property (nonatomic,weak) UIView *sep;// 线条

@end

@implementation ProductHistoryCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"";
    ProductHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ProductHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UILabel *customer = [[UILabel alloc] init];
    customer.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:customer];
    self.customer = customer;
    
    UILabel *time = [[UILabel alloc] init];
    time.textAlignment = NSTextAlignmentRight;
    time.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:time];
    self.time = time;
    
    UIView *sep = [[UIView alloc] init];
    sep.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.contentView addSubview:sep];
    self.sep = sep;
}

// 重新设置位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    /**
     *  新的控件
     */
    CGFloat customerW = (screenW - gap * 2) * 0.5;
    self.customer.frame = CGRectMake(gap, 5, customerW, 20);
    
    
    CGFloat timeX = screenW - customerW - gap;
    self.time.frame = CGRectMake(timeX, 5, customerW, 20);
    
    CGFloat sepY = CGRectGetMaxY(self.time.frame) + 5;
    self.sep.frame = CGRectMake(gap, sepY, screenW - gap * 2, 1);
    
    
    /**
     *  继承的控件
     */
    CGFloat titleW = screenW - gap * 2;
    self.title.frame = CGRectMake(gap, gap + 30, titleW, 35);
    
    CGFloat iconY = CGRectGetMaxY(self.title.frame) + gap;
    self.icon.frame = CGRectMake(gap, iconY, 70, 70);
    
    /**
     四个label
     */
    CGFloat pX = CGRectGetMaxX(self.icon.frame) + gap;
    CGFloat pW = (screenW - 120 - gap * 3.5) / 2;
    self.productNum.frame = CGRectMake(pX, iconY, pW, 20);
    
    CGFloat nX = CGRectGetMaxX(self.productNum.frame) + gap * 0.5;
    self.normalPrice.frame = CGRectMake(nX, iconY, pW, 20);
    
    CGFloat cY = CGRectGetMaxY(self.normalPrice.frame) + gap * 0.5;
    self.cheapPrice.frame = CGRectMake(pX, cY, pW, 20);
    
    self.profits.frame = CGRectMake(nX, cY, pW, 20);
    
    /**
     底下的三个按钮
     */
    CGFloat jY = CGRectGetMaxY(self.cheapPrice.frame) + gap * 0.5;
    self.jiafanBtn.frame = CGRectMake(pX, jY, 70, 20);
    
    CGFloat qX = CGRectGetMaxX(self.jiafanBtn.frame);
    self.quanBtn.frame = CGRectMake(qX, jY, 70, 20);
    
    // 闪电
    CGFloat fX = CGRectGetMaxX(self.quanBtn.frame);
    CGFloat fW = self.isFlash ? 20 : 0;
    self.flash.frame = CGRectMake(fX, jY, fW, 20);
    
    CGFloat sX = CGRectGetMaxX(self.flash.frame) + gap * 0.5;
    self.ShanDianBtn.frame = CGRectMake(sX, jY, 60, 20);
}

@end
