//
//  ProductCell.m
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ProductCell.h"
#import "UIImageView+WebCache.h"
#import "textStyle.h"
@interface ProductCell()

@end

@implementation ProductCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{ static NSString *cellID = @"productCell";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
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
    UILabel *title = [[UILabel alloc] init];
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:title];
    self.title = title;
    self.title.numberOfLines = 0;
    self.title.tintColor = [UIColor lightGrayColor];
    UIImageView *icon = [[UIImageView alloc] init];
    [self.contentView addSubview:icon];
    self.icon = icon;
    
    /**
       四个label
     */
    UILabel *productNum = [[UILabel alloc] init];
    productNum.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:productNum];
    self.productNum = productNum;
    
    UILabel *normalPrice = [[UILabel alloc] init];
    normalPrice.font = [UIFont systemFontOfSize:11];
//    normalPrice.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:normalPrice];
    self.normalPrice = normalPrice;
    
    UILabel *cheapPrice = [[UILabel alloc] init];
    cheapPrice.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:cheapPrice];
    self.cheapPrice = cheapPrice;
    
    UILabel *profits = [[UILabel alloc] init];
//    profits.textAlignment = NSTextAlignmentRight;
    profits.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:profits];
    self.profits = profits;
    
    /**
       底下的三个按钮
     */
    UIButton *jiafanBtn = [[UIButton alloc] init];
    [jiafanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [jiafanBtn setBackgroundImage:[UIImage imageNamed:@"jiafan"] forState:UIControlStateNormal];
    jiafanBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:jiafanBtn];
    self.jiafanBtn = jiafanBtn;
    
    UIButton *quanBtn = [[UIButton alloc] init];
    [quanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quanBtn setBackgroundImage:[UIImage imageNamed:@"quan"] forState:UIControlStateNormal];
    quanBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:quanBtn];
    self.quanBtn = quanBtn;
    
    UIButton *ShanDianBtn = [[UIButton alloc] init];
    [ShanDianBtn setTitleColor:[UIColor colorWithRed:128/255.0 green:188/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    ShanDianBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [ShanDianBtn setBackgroundImage:[UIImage imageNamed:@"chufa"] forState:UIControlStateNormal];
    ShanDianBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:ShanDianBtn];
    self.ShanDianBtn = ShanDianBtn;
    
    // 闪电
    UIImageView *flash = [[UIImageView alloc] init];
    flash.image = [UIImage imageNamed:@"sandian"];
    [self.contentView addSubview:flash];
    self.flash = flash;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   // CGFloat iconWid = [UIScreen mainScreen].applicationFrame.size.width*7/32;
    CGFloat iconWid = 60;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
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

-(void)setModal:(ProductModal *)modal
{
//    @property (weak, nonatomic) IBOutlet UIImageView *jiafanImage;
//    @property (weak, nonatomic) IBOutlet UILabel *jiafanValue;
//    @property (weak, nonatomic) IBOutlet UIImageView *quanImage;
//    @property (weak, nonatomic) IBOutlet UILabel *quanValue;
//    @property (weak, nonatomic) IBOutlet UIImageView *ShanDian;
//    @property (weak, nonatomic) IBOutlet UILabel *setUpPlace;
//    
    _modal = modal;
   // self.icon.image = [UIImage imageNamed:modal.PicUrl];
    NSLog(@"=========%@",modal.PicUrl);
         [self.icon sd_setImageWithURL:[[NSURL alloc] initWithString:modal.PicUrl] placeholderImage:[UIImage imageNamed:@"lvyouquanIcon"]];
    
   
    self.title.text = modal.Name;
    
    /**
     *  四个label
     */
    //self.productNum.text = [NSString stringWithFormat:@"产品编号: %@",modal.Code];
    self.normalPrice.text = [NSString stringWithFormat:@"门市价: ￥%@",modal.PersonPrice];
    
    NSString *codeStr = [NSString stringWithFormat:@"产品编号: %@",modal.Code];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:codeStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, modal.Code.length + 1)];
   self.productNum.attributedText = str;
    [textStyle textStyleLabel:self.productNum text:codeStr FontNumber:12 AndRange:NSMakeRange(5, modal.Code.length) AndColor:[UIColor blackColor]];
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"同行价: ￥%@",modal.PersonPeerPrice]];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, modal.PersonPeerPrice.length + 1)];
    
    self.cheapPrice.attributedText = str1;
//    [textStyle textStyleLabel:self.cheapPrice text:modal.PersonPeerPrice FontNumber:15 AndRange:NSMakeRange(0, modal.PersonPeerPrice.length+1) AndColor:[UIColor redColor]];
    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"利润: ￥%@",modal.PersonProfit]];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, modal.PersonProfit.length + 1)];
    self.profits.attributedText = str2;
    
    /**
     *  底部按钮
     */
    [self.jiafanBtn setTitle:[NSString stringWithFormat:@"    ￥%@",modal.PersonBackPrice] forState:UIControlStateNormal];
    [self.quanBtn setTitle:[NSString stringWithFormat:  @"    ￥%@",modal.PersonCashCoupon] forState:UIControlStateNormal];
    [self.ShanDianBtn setTitle:[NSString stringWithFormat:@"    %@出发",modal.StartCityName] forState:UIControlStateNormal];
    
    self.isFlash = [modal.IsComfirmStockNow integerValue];
    [self setNeedsLayout];
    
//    @property (nonatomic, copy) NSString *ID;//产品ID(用于收藏)
//    @property (nonatomic, copy) NSString *PicUrl;//
//    @property (nonatomic, copy) NSString *Name;//产品介绍
//    @property (nonatomic, copy) NSString *Code;//产品编号
//    @property (nonatomic, copy) NSString *PersonPrice;//门市价
//    @property (nonatomic, copy) NSString *PersonPeerPrice;//同行价
//    @property (nonatomic, copy) NSString *PersonProfit;//利润
//    @property (nonatomic, copy) NSString *PersonBackPrice;//加返
//    @property (nonatomic, copy) NSString *PersonCashCoupon;//券
//    @property (nonatomic, copy) NSString *StartCityName;//出发城市名称
//    @property (assign , nonatomic) BOOL *IsComfirmStockNow;//是否闪电发班
//    @property (assign , nonatomic) NSNumber *StartCity;//出发城市编号
//    @property (copy,nonatomic) NSString *LastScheduleDate;//最近班期
//    @property (copy,nonatomic) NSString *SupplierName;//供应商
//    @property (assign , nonatomic) BOOL *IsFavorites;//是否收藏
//    @property (copy,nonatomic) NSString *ContactName;//联系人名称
//    @property (copy,nonatomic) NSString *ContactMobile;//联系人电话
   
}



@end
