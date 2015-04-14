//
//  DayDetailCell.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "DayDetailCell.h"
#import "DayDetail.h"
#import "UIImageView+WebCache.h"
#import "NSString+QD.h"

#define gap 10

@interface DayDetailCell()

@property (weak, nonatomic) UIImageView *iconView;

@property (weak, nonatomic) UILabel *titleLab;

@property (weak, nonatomic) UILabel *aPriceLab;

@property (weak, nonatomic) UILabel *bPriceLab;

@end

@implementation DayDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"daydetailcell";
    DayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DayDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.numberOfLines = 0;
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    
    UILabel *aPriceLab = [[UILabel alloc] init];
    aPriceLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:aPriceLab];
    self.aPriceLab = aPriceLab;
    
    UILabel *bPriceLab = [[UILabel alloc] init];
    bPriceLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:bPriceLab];
    self.bPriceLab = bPriceLab;
}

- (void)setDetail:(DayDetail *)detail
{
    _detail = detail;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat iconW = 75;
    self.iconView.frame = CGRectMake(gap, gap, 75, 60);
    
    CGFloat maxTitleW = screenW - iconW - gap * 3;
    CGSize titleMax = CGSizeMake(maxTitleW, 40);
    CGSize titleSize = [NSString textSizeWithText:detail.title font:[UIFont systemFontOfSize:14] maxSize:titleMax];
    CGFloat titleX = CGRectGetMaxX(self.iconView.frame) + gap;
    self.titleLab.frame = CGRectMake(titleX, gap, titleSize.width, titleSize.height);
    
    // 设置数据
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:detail.icon] placeholderImage:nil];
    
    self.titleLab.text = detail.title;
    
    self.aPriceLab.text = [NSString stringWithFormat:@"门市价￥%@",detail.aPrice];
    
    NSString *tmp = [NSString stringWithFormat:@"￥%@起",detail.bPrice];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:tmp];
    NSMutableDictionary *mutaDic = [NSMutableDictionary dictionary];
    [mutaDic setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    [mutaDic setObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [attr addAttributes:mutaDic range:NSMakeRange(0, detail.bPrice.length + 1)];
    
    [self.bPriceLab setAttributedText:attr];
    
    // 因为要知道文字大小 所有放后面算
    CGFloat priceY = 80 - 20 - gap;
    CGSize bMax = CGSizeMake(screenW * 0.5, 20);
    CGSize bSize = [NSString textSizeWithText:[attr string] font:[UIFont systemFontOfSize:12] maxSize:bMax];
    CGFloat bX = screenW - (bSize.width + 20 + gap);
    self.bPriceLab.frame = CGRectMake(bX, priceY, bSize.width + 20, 20);
    
    CGSize aMax = CGSizeMake(screenW * 0.5, 20);
    CGSize aSize = [NSString textSizeWithText:[NSString stringWithFormat:@"门市价￥%@",detail.aPrice] font:[UIFont systemFontOfSize:12] maxSize:aMax];
    CGFloat aX = bX - (aSize.width + gap);
    self.aPriceLab.frame = CGRectMake(aX, priceY, aSize.width, 20);
}

@end
