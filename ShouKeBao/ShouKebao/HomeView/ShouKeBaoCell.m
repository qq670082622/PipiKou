//
//  tableviewCell.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ShouKeBaoCell.h"
#import "HomeModel.h"

#define gap 10

@interface ShouKeBaoCell()
// 图标
@property (nonatomic,weak) UIImageView *iconView;
// 标题
@property (nonatomic,weak) UILabel *titleLab;
// 时间
@property (nonatomic,weak) UILabel *timeLab;
// 左边待定内容
@property (nonatomic,weak) UILabel *leftLab;
// 右边待定内容
@property (nonatomic,weak) UILabel *rightLab;
// 详情
@property (nonatomic,weak) UILabel *detailLab;

@end

@implementation ShouKeBaoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"ShouKeBaoCell";
    ShouKeBaoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ShouKeBaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
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
    // 图标
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.cornerRadius = 3;
    iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 标题
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    
    // 时间
    UILabel *timeLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor lightGrayColor];
    titleLab.textAlignment = NSTextAlignmentRight;
    titleLab.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:timeLab];
    self.timeLab = timeLab;
    

    // 左边待定内容
    UILabel *leftLab = [[UILabel alloc] init];
    leftLab.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:leftLab];
    self.leftLab = leftLab;
    

    // 右边待定内容
    UILabel *rightLab = [[UILabel alloc] init];
    rightLab.font = [UIFont systemFontOfSize:13];
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.textColor = [UIColor blueColor];
    [self.contentView addSubview:rightLab];
    self.rightLab = rightLab;
    

    // 详情
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.textColor = [UIColor grayColor];
    detailLab.font = [UIFont systemFontOfSize:15];
    detailLab.numberOfLines = 0;
    [self.contentView addSubview:detailLab];
    self.detailLab = detailLab;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 图标
    CGFloat iconW = 35;
    self.iconView.frame = CGRectMake(gap, gap, iconW, iconW);
    
    // 标题
    CGFloat titleX = CGRectGetMaxX(self.iconView.frame) + gap;
    CGFloat titleW = (screenW - iconW - gap * 4) * 0.5;
    self.titleLab.frame = CGRectMake(titleX, gap, titleW, 20);
    // 时间
    CGFloat timeX = CGRectGetMaxX(self.titleLab.frame) + gap;
    self.timeLab.frame = CGRectMake(timeX, gap, titleW, 20);
    
    // 左边待定内容
    CGFloat leftY = CGRectGetMaxY(self.titleLab.frame) + gap;
    CGFloat leftW = 100;
    self.leftLab.frame = CGRectMake(titleX, leftY, leftW, 20);
    
    // 右边待定内容
    CGFloat rightX = CGRectGetMaxX(self.leftLab.frame) + gap;
    CGFloat rightW = (screenW - iconW - gap * 4) - leftW;
    self.rightLab.frame = CGRectMake(rightX, leftY, rightW, 20);
    
    // 详情
    CGFloat detailY = CGRectGetMaxY(self.leftLab.frame) + gap;
    CGFloat detailW = screenW - iconW - gap * 3;
    self.detailLab.frame = CGRectMake(titleX, detailY, detailW, 40);
}

- (void)setModel:(HomeModel *)model
{
    _model = model;
}

@end
