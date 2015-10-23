//
//  ProductHistoryCell.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ProductHistoryCell.h"
#import "UIImageView+WebCache.h"
#import "textStyle.h"
#import "ProductModal.h"

@interface ProductHistoryCell()

@end

@implementation ProductHistoryCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"historycell";
    ProductHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ProductHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.separatorInset = UIEdgeInsetsZero;
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
    UILabel *time = [[UILabel alloc] init];
    time.textAlignment = NSTextAlignmentRight;
    time.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:time];
    self.time = time;
    
    UIView *sep = [[UIView alloc] init];
    sep.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [self.contentView addSubview:sep];
    self.sep = sep;
}

// 重新设置位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat iconWid = 60;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    /**
     *  继承的控件
     */
    CGFloat titleW = screenW - gap * 2;
    self.title.frame = CGRectMake(gap, 8, titleW, 45);//产品名称
    
    CGFloat iconY = CGRectGetMaxY(self.title.frame) + 8;//图片
    self.icon.frame = CGRectMake(gap, iconY, iconWid, 60);
    
    /**
     四个label 产品编号和门市价间隔 15，门市价离右边框间隔15;
     */
    CGFloat pX = CGRectGetMaxX(self.icon.frame) + 8;
    CGFloat pW = (screenW - 120)/ 2;
    self.productNum.frame = CGRectMake(pX, iconY, pW*1.2, 15);//产品编号
    
    CGFloat nX = CGRectGetMaxX(self.productNum.frame) ;//门市价
    self.normalPrice.frame = CGRectMake(nX, iconY, pW, 15);
    
    CGFloat cY = CGRectGetMaxY(self.normalPrice.frame) + 5;//同行价
    self.cheapPrice.frame = CGRectMake(pX, cY, pW, 15);
    
    self.profits.frame = CGRectMake(nX, cY, pW, 15);//利润
    
    /**
     底下的三个按钮
     */
    CGFloat jY = CGRectGetMaxY(self.cheapPrice.frame) + 10;
    self.jiafanBtn.frame = CGRectMake(pX, jY, 55, 18);//加返按钮
    
    CGFloat qX = CGRectGetMaxX(self.jiafanBtn.frame)+10;
    self.quanBtn.frame = CGRectMake(qX, jY, 55, 18);//券
    
    // 闪电
    CGFloat fX = CGRectGetMaxX(self.quanBtn.frame)+10;
    CGFloat fW = self.isFlash ? 18 : 0;
    self.flash.frame = CGRectMake(fX, jY, fW, 18);
    
    CGFloat sX = CGRectGetMaxX(self.flash.frame) + 10;
    self.ShanDianBtn.frame = CGRectMake(sX, jY, 70, 18);
}

- (void)setHistoryModel:(ProductModal *)historyModel
{
    _historyModel = historyModel;
    
    // 新增的
    self.time.text = [NSString stringWithFormat:@"浏览时间: %@",historyModel.HistoryViewTime];
    
    // 继承的
    NSLog(@"=========%@",historyModel.PicUrl);
    [self.icon sd_setImageWithURL:[[NSURL alloc] initWithString:historyModel.PicUrl] placeholderImage:[UIImage imageNamed:@"lvyouquanIcon"]];
    
    self.title.text = historyModel.Name;
    
    /**
     *  四个label
     */
    //self.productNum.text = [NSString stringWithFormat:@"产品编号: %@",modal.Code];
    self.normalPrice.text = [NSString stringWithFormat:@"门市价: ￥%@",historyModel.PersonPrice];
    
    NSString *codeStr = [NSString stringWithFormat:@"产品编号: %@",historyModel.Code];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:codeStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, historyModel.Code.length + 1)];
    self.productNum.attributedText = str;
    [textStyle textStyleLabel:self.productNum text:codeStr FontNumber:12 AndRange:NSMakeRange(5, historyModel.Code.length) AndColor:[UIColor blackColor]];
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"同行价: ￥%@",historyModel.PersonPeerPrice]];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, historyModel.PersonPeerPrice.length + 1)];
    
    self.cheapPrice.attributedText = str1;
    //    [textStyle textStyleLabel:self.cheapPrice text:modal.PersonPeerPrice FontNumber:15 AndRange:NSMakeRange(0, modal.PersonPeerPrice.length+1) AndColor:[UIColor redColor]];
    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"利润: ￥%@",historyModel.PersonProfit]];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, historyModel.PersonProfit.length + 1)];
    self.profits.attributedText = str2;
    
    /**
     *  底部按钮
     */
    [self.jiafanBtn setTitle:[NSString stringWithFormat:@"    ￥%@",historyModel.PersonBackPrice] forState:UIControlStateNormal];
    [self.quanBtn setTitle:[NSString stringWithFormat:  @"    ￥%@",historyModel.PersonCashCoupon] forState:UIControlStateNormal];
    [self.ShanDianBtn setTitle:[NSString stringWithFormat:@"    %@出发",historyModel.StartCityName] forState:UIControlStateNormal];
    
    self.isFlash = [historyModel.IsComfirmStockNow integerValue];
    [self setNeedsLayout];

}

@end
