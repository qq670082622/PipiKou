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
#import "UIImage+QD.h"
#import "WMAnimations.h"
#import "MyListViewController.h"
@interface ProductCell()
@property (nonatomic, copy)NSString * productId;

@end

@implementation ProductCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{ static NSString *cellID = @"productCell";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isHistory = NO;
        [self setup];
    }
    return self;
}

- (void)setup
{
    // 历史浏览的内容
    UILabel *time = [[UILabel alloc] init];
    time.textAlignment = NSTextAlignmentRight;
    time.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:time];
    self.time = time;
    
    UIView *sep = [[UIView alloc] init];
    sep.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [self.contentView addSubview:sep];
    self.sep = sep;
    
    // 与历史浏览无关的
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
    [jiafanBtn setBackgroundImage:[UIImage imageNamed:@"dihesong"] forState:UIControlStateNormal];
    jiafanBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    jiafanBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:jiafanBtn];
    self.jiafanBtn = jiafanBtn;
    UILabel * diLab = [[UILabel alloc]initWithFrame:CGRectMake(4, 0, 15, 15)];
    diLab.text = @"抵";
    diLab.font = [UIFont systemFontOfSize:13.0];
    diLab.textColor = [UIColor redColor];
    [jiafanBtn  addSubview:diLab];
    
    UIButton *quanBtn = [[UIButton alloc] init];
    [quanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quanBtn setBackgroundImage:[UIImage imageNamed:@"songhedi"] forState:UIControlStateNormal];
    quanBtn.titleLabel.font = [UIFont systemFontOfSize:11];
     quanBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:quanBtn];
    self.quanBtn = quanBtn;
    UILabel * songLab = [[UILabel alloc]initWithFrame:CGRectMake(4, 0, 15, 15)];
    songLab.text = @"送";
    songLab.font = [UIFont systemFontOfSize:13.0];
    songLab.textColor = [UIColor colorWithRed:253/255.0 green:134/255.0 blue:39/255.0 alpha:1.0];
    [quanBtn addSubview:songLab];
    
    
    UIButton *ShanDianBtn = [[UIButton alloc] init];
    [ShanDianBtn setTitleColor:[UIColor colorWithRed:0 green:91/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    ShanDianBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [ShanDianBtn setBackgroundImage:[UIImage resizedImageWithName:@"chufa"] forState:UIControlStateNormal];
    ShanDianBtn.userInteractionEnabled = NO;
    ShanDianBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    ShanDianBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.contentView addSubview:ShanDianBtn];
    self.ShanDianBtn = ShanDianBtn;
    
    // 闪电
    UIImageView *flash = [[UIImageView alloc] init];
    flash.image = [UIImage imageNamed:@"sandian"];
    [self.contentView addSubview:flash];
    self.flash = flash;
    //下架lab
    UILabel * theView = [[UILabel alloc]init];
    theView.textAlignment = NSTextAlignmentCenter;
    theView.textColor = [UIColor lightGrayColor];
    theView.text = @"此产品已下架";
    self.undercarriageView = theView;
    [WMAnimations WMAnimationMakeBoarderWithLayer:theView.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:1.0 andNeedShadow:NO andCornerRadius:3];
    self.undercarriageView.font = [UIFont systemFontOfSize:14];
    self.undercarriageView.backgroundColor = [UIColor whiteColor];
    self.undercarriageView.hidden = YES;
    [self.contentView addSubview:theView];
    //相关按钮
    UIButton * RelatedBt = [[UIButton alloc]init];
    self.RelatedBtn = RelatedBt;
    self.RelatedBtn.titleLabel.textColor = [UIColor whiteColor];
    self.RelatedBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:132/255.0 blue:250/155.0 alpha:1.0];
    [self.RelatedBtn setTitle:@"查看相关产品" forState:UIControlStateNormal];
    [self.RelatedBtn addTarget:self action:@selector(RelatedProductClick) forControlEvents:UIControlEventTouchUpInside];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.RelatedBtn.layer andBorderColor:[UIColor clearColor] andBorderWidth:1.0 andNeedShadow:NO andCornerRadius:3];
    self.RelatedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.RelatedBtn.hidden = YES;
    [self.contentView addSubview:RelatedBt];
    //分割线
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = [UIColor colorWithRed:170/255.f green:170/255.f blue:170/255.f alpha:1];
//    [self.contentView addSubview:line];
//    self.line = line;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat iconWid = 60;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    /**
     *  历史控件
     */
    CGFloat timeW = screenW - gap * 2;
    CGFloat timeX = screenW - timeW - gap;
    self.time.frame = CGRectMake(timeX, 5, timeW, 20);
    
    CGFloat sepY = CGRectGetMaxY(self.time.frame) + 5;
    self.sep.frame = CGRectMake(gap, sepY, screenW - gap * 2, 1);
    
    // 其他控件
    CGFloat titleY = 8;
    if (self.isHistory) {
        titleY = CGRectGetMaxY(self.sep.frame) + gap;
    }
    CGFloat titleW = screenW - gap * 2;
    self.title.frame = CGRectMake(gap, titleY, titleW, 45);//产品名称
    
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
    
    //下架产品
    self.undercarriageView.frame = CGRectMake(pX + screenW/10.0, iconY + 30, (screenW*9/10.0 - pX - 10)/2 -2, 30);
    self.RelatedBtn.frame = CGRectMake(CGRectGetMaxX(self.undercarriageView.frame)+4, iconY + 30, (screenW*9/10.0 - pX - 10)/2 -2, 30);
    /**
     底下的三个按钮
     */
    CGFloat jY = CGRectGetMaxY(self.cheapPrice.frame) + 10;
    //默认宽为60
    CGFloat jW = self.fanIsZero ? 60 : 0 ;
    CGFloat qW = self.quanIsZero ? 60 : 0 ;
    
    self.jiafanBtn.frame = CGRectMake(pX, jY, jW, 15);//加返按钮
    
    CGFloat qX = CGRectGetMaxX(self.jiafanBtn.frame)+5;
    self.quanBtn.frame = CGRectMake(qX, jY, qW, 15);//券
    
    // 闪电
    CGFloat fX = CGRectGetMaxX(self.quanBtn.frame)+10;
    CGFloat fW = self.isFlash ? 18 : 0;
    self.flash.frame = CGRectMake(fX, jY, fW, 15);
    
    CGFloat sX = CGRectGetMaxX(self.flash.frame) + 10;
    self.ShanDianBtn.frame = CGRectMake(sX, jY - 2, 60, 20);
    /******   下架产品的button设置   ******/
    
    
    
    
    //分割线
//    self.line.frame = CGRectMake(0, 135.5, self.contentView.frame.size.width, 0.5);
}

- (void)setModal:(ProductModal *)modal
{
    NSLog(@"%@, %@",modal.PersonAlternateCash
          ,modal.SendCashCoupon);
        _modal = modal;
    self.productId = modal.ID;
    if (!self.isHistory) {
        self.time.hidden = YES;
        self.sep.hidden = YES;
    }
    
    // 历史时间
    self.time.text = [NSString stringWithFormat:@"浏览时间: %@",modal.HistoryViewTime];
    
    self.fanIsZero = [modal.PersonAlternateCash integerValue];
    self.quanIsZero = [modal.SendCashCoupon integerValue];
    
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
    [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(5, modal.PersonPeerPrice.length + 1)];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:201/255.0 green:36/255.0 blue:46/255.0 alpha:1] range:NSMakeRange(5, modal.PersonPeerPrice.length + 1)];
    
    self.cheapPrice.attributedText = str1;
//    [textStyle textStyleLabel:self.cheapPrice text:modal.PersonPeerPrice FontNumber:15 AndRange:NSMakeRange(0, modal.PersonPeerPrice.length+1) AndColor:[UIColor redColor]];
    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"利润: ￥%@",modal.PersonProfit]];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:201/255.0 green:36/255.0 blue:46/255.0 alpha:1] range:NSMakeRange(4, modal.PersonProfit.length + 1)];
    self.profits.attributedText = str2;
    
    /**
     *  底部按钮
     */
    [self.jiafanBtn setTitle:[NSString stringWithFormat:@"     ￥%@",modal.PersonAlternateCash] forState:UIControlStateNormal];
    [self.quanBtn setTitle:[NSString stringWithFormat:  @"     ￥%@",modal.SendCashCoupon] forState:UIControlStateNormal];
    [self.ShanDianBtn setTitle:[NSString stringWithFormat:@"%@出发",modal.StartCityName] forState:UIControlStateNormal];
    if ([modal.StartCityName isEqualToString:@"不限"]) {
        [self.ShanDianBtn setTitle:[NSString stringWithFormat:@"%@",modal.StartCityName] forState:UIControlStateNormal];
    }

    [self.ShanDianBtn sizeToFit];
    
    self.isFlash = [modal.IsComfirmStockNow integerValue];
    if ([modal.IsOffLine isEqualToString:@"1"]) {
        NSLog(@"%@", modal.ID);
        self.normalPrice.hidden = YES;
        self.cheapPrice.hidden = YES;
        self.profits.hidden = YES;
        self.flash.hidden = YES;
        self.ShanDianBtn.hidden = YES;
        self.jiafanBtn.hidden = YES;
        self.quanBtn.hidden = YES;
        self.undercarriageView.hidden = NO;
        self.RelatedBtn.hidden = NO;
    }else{
        self.normalPrice.hidden = NO;
        self.cheapPrice.hidden = NO;
        self.profits.hidden = NO;
        self.flash.hidden = NO;
        self.ShanDianBtn.hidden = NO;
        self.jiafanBtn.hidden = NO;
        self.quanBtn.hidden = NO;
        self.undercarriageView.hidden = YES;
        self.RelatedBtn.hidden = YES;
    }
    
    
    
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
- (void)RelatedProductClick{
    MyListViewController * MLVC = [[MyListViewController alloc]init];
    MLVC.listType = RelatedProductType;
    MLVC.productId = self.productId;
    [self.MylistVCNav pushViewController:MLVC animated:YES];
}


@end
