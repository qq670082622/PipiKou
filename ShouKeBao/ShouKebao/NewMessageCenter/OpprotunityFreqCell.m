//
//  OpprotunityFreqCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import "OpprotunityFreqCell.h"
#import "CustomDynamicModel.h"
#import "UIImageView+WebCache.h"
#import "ProductModal.h"

@interface OpprotunityFreqCell ()
@property (strong, nonatomic) IBOutlet UIImageView *diImage;
@property (strong, nonatomic) IBOutlet UILabel *diY;
@property (strong, nonatomic) IBOutlet UIImageView *liImage;
@property (strong, nonatomic) IBOutlet UILabel *liY;

@property (strong, nonatomic) IBOutlet UIImageView *songImage;
@property (strong, nonatomic) IBOutlet UILabel *songY;
@end

@implementation OpprotunityFreqCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(CustomDynamicModel *)model{
    _model = model;
    [self.HeadImage sd_setImageWithURL:[NSURL URLWithString:model.HeadUrl] placeholderImage:[UIImage imageNamed:@"customtouxiang"]];
    self.TitleImage.image = [UIImage imageNamed:@"dongtaichanpin"];
    self.TimerLabel.text = model.CreateTimeText;
    self.TitleLabel.text = model.DynamicContent;
    self.topTitleLab.text = model.DynamicTitle;
    self.DiLabel.text = model.ProductdetailModel.PersonCashCoupon;
    self.SongLabel.text = model.ProductdetailModel.PersonBackPrice;
    self.ProfitLabel.text = model.ProductdetailModel.PersonProfit;
    self.MenShiLabel.text = model.ProductdetailModel.PersonPrice;
    self.SameJobLabel.text = model.ProductdetailModel.PersonPeerPrice;
    self.NumberLabel.text = model.ProductdetailModel.Code;
    self.BodyLabel.text = model.ProductdetailModel.Name;
    
    if (![model.ProductdetailModel.IsComfirmStockNow intValue]) {
        self.sandian.hidden = YES;
    }
    if ([model.ProductdetailModel.PersonCashCoupon isEqualToString:@""]) {
        self.diImage.hidden = YES;
        self.diY.hidden = YES;
    }
    if ([model.ProductdetailModel.PersonBackPrice isEqualToString:@""]) {
        self.songImage.hidden = YES;
        self.songY.hidden = YES;
    }
    if ([model.ProductdetailModel.PersonProfit isEqualToString:@""]) {
        self.liImage.hidden = YES;
        self.liY.hidden = YES;
    }
}
//@property (nonatomic, copy) NSString *AdvertText;//广告文本
//
//@property (nonatomic, copy) NSString *ID;//产品ID(用于收藏)
//@property (nonatomic, copy) NSString *PicUrl;//
//@property (nonatomic, copy) NSString *Name;//产品介绍
//@property (nonatomic, copy) NSString *Code;//产品编号
//@property (nonatomic, copy) NSString *PersonPrice;//门市价
//@property (nonatomic, copy) NSString *PersonPeerPrice;//同行价
//@property (nonatomic, copy) NSString *PersonProfit;//利润
//@property (nonatomic, copy) NSString *PersonBackPrice;//加返
//@property (nonatomic, copy) NSString *PersonCashCoupon;//券
//@property (nonatomic, copy) NSString *StartCityName;//出发城市名称
//@property (copy , nonatomic) NSString *IsComfirmStockNow;//是否闪电发班
//@property (strong , nonatomic) NSNumber *StartCity;//出发城市编号
//@property (copy,nonatomic) NSString *LastScheduleDate;//最近班期
//@property (copy,nonatomic) NSString *SupplierName;//供应商
//@property (copy , nonatomic) NSString *IsFavorites;//是否收藏
//@property (copy,nonatomic) NSString *ContactName;//联系人名称
//@property (copy,nonatomic) NSString *ContactMobile;//联系人电话
//@property (copy,nonatomic) NSString *LinkUrl;//产品详情页
//
//@property (nonatomic,copy) NSString *IsOffLine;// 是否离线
//@property (nonatomic,copy) NSString *HistoryViewTime;// 历史流浪时间
//@property (nonatomic,strong) NSMutableDictionary *ShareInfo;
//@property (nonatomic , copy)NSString * PushDate;

@end
