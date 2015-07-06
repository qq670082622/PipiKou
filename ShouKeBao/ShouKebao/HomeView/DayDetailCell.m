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
#import "textStyle.h"
#import "UIImage+QD.h"
#import "NSDate+Category.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "StrToDic.h"
#define gap 10
//此处三点要注意：1，通过点击button 确定是哪个cell需要改变高度，用dic记录并[_tableView beginUpdates];
//2,利用cell的高度确定当前按钮的作用是展开还是收起，以及按钮的title为何（在button的点击事件里说明）
//3,列表下拉会导致展开的cell的按钮title还是展开，这里在cell初始化时根据cell的高度进行判断给button标题
//4,此乃原创，切勿抄袭
@interface DayDetailCell()

//@property (weak, nonatomic) UIImageView *iconView;
//
//@property (weak, nonatomic) UILabel *titleLab;
//
//@property (weak, nonatomic) UILabel *aPriceLab;
//
//@property (weak, nonatomic) UILabel *bPriceLab;
@property(nonatomic,weak) UILabel *warningLab;
@end

@implementation DayDetailCell

//+ (instancetype)cellWithTableView:(UITableView *)tableView
//{
//    static NSString *ID = @"daydetailcell";
//    DayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[DayDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    return cell;
//}
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        [self setup];
//    }
//    return self;
//}
//
//- (void)setup
//{
//    UIImageView *iconView = [[UIImageView alloc] init];
//    [self.contentView addSubview:iconView];
//    self.iconView = iconView;
//    
//    UILabel *titleLab = [[UILabel alloc] init];
//    titleLab.font = [UIFont systemFontOfSize:14];
//    titleLab.numberOfLines = 0;
//    [self.contentView addSubview:titleLab];
//    self.titleLab = titleLab;
//    
//    UILabel *aPriceLab = [[UILabel alloc] init];
//    aPriceLab.font = [UIFont systemFontOfSize:12];
//    [self.contentView addSubview:aPriceLab];
//    self.aPriceLab = aPriceLab;
//    
//    UILabel *bPriceLab = [[UILabel alloc] init];
//    bPriceLab.font = [UIFont systemFontOfSize:12];
//    [self.contentView addSubview:bPriceLab];
//    self.bPriceLab = bPriceLab;
//}
//
//- (void)setDetail:(DayDetail *)detail
//{
//    _detail = detail;
//    
//    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
//    
//    CGFloat iconW = 75;
//    self.iconView.frame = CGRectMake(gap, gap, 75, 60);
//    
//    CGFloat maxTitleW = screenW - iconW - gap * 3;
//    CGSize titleMax = CGSizeMake(maxTitleW, 40);
//    CGSize titleSize = [NSString textSizeWithText:detail.title font:[UIFont systemFontOfSize:14] maxSize:titleMax];
//    CGFloat titleX = CGRectGetMaxX(self.iconView.frame) + gap;
//    self.titleLab.frame = CGRectMake(titleX, gap, titleSize.width, titleSize.height);
//    
//    // 设置数据
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:detail.icon] placeholderImage:nil];
//    
//    self.titleLab.text = detail.title;
//    
//    self.aPriceLab.text = [NSString stringWithFormat:@"门市价￥%@",detail.aPrice];
//    
//    NSString *tmp = [NSString stringWithFormat:@"￥%@起",detail.bPrice];
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:tmp];
//    NSMutableDictionary *mutaDic = [NSMutableDictionary dictionary];
//    [mutaDic setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
//    [mutaDic setObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
//    [attr addAttributes:mutaDic range:NSMakeRange(0, detail.bPrice.length + 1)];
//    
//    [self.bPriceLab setAttributedText:attr];
//    
//    // 因为要知道文字大小 所有放后面算
//    CGFloat priceY = 80 - 20 - gap;
//    CGSize bMax = CGSizeMake(screenW * 0.5, 20);
//    CGSize bSize = [NSString textSizeWithText:[attr string] font:[UIFont systemFontOfSize:12] maxSize:bMax];
//    CGFloat bX = screenW - (bSize.width + 20 + gap);
//    self.bPriceLab.frame = CGRectMake(bX, priceY, bSize.width + 20, 20);
//    
//    CGSize aMax = CGSizeMake(screenW * 0.5, 20);
//    CGSize aSize = [NSString textSizeWithText:[NSString stringWithFormat:@"门市价￥%@",detail.aPrice] font:[UIFont systemFontOfSize:12] maxSize:aMax];
//    CGFloat aX = bX - (aSize.width + gap);
//    self.aPriceLab.frame = CGRectMake(aX, priceY, aSize.width, 20);
//}

+ (instancetype)cellWithTableView:(UITableView *)tableView withTag:(NSInteger)tag
{
   
    
    DayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld",(long)tag]];
    if (cell == nil) {
        cell = [[DayDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell%ld",(long)tag]];
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
        self.isPlain = NO;//是否展开
                [self setup];
    }
    return self;
}

- (void)setup
{
    // 历史浏览的内容
//    UILabel *time = [[UILabel alloc] init];
//    time.textAlignment = NSTextAlignmentRight;
//    time.font = [UIFont systemFontOfSize:12];
//    [self.contentView addSubview:time];
//    self.time = time;
    
//    UIView *sep = [[UIView alloc] init];
//    sep.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
//    [self.contentView addSubview:sep];
//    self.sep = sep;
    
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
    [ShanDianBtn setTitleColor:[UIColor colorWithRed:0 green:91/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    ShanDianBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [ShanDianBtn setBackgroundImage:[UIImage resizedImageWithName:@"chufa"] forState:UIControlStateNormal];
    ShanDianBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    ShanDianBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.contentView addSubview:ShanDianBtn];
    self.ShanDianBtn = ShanDianBtn;
    
    // 闪电
    UIImageView *flash = [[UIImageView alloc] init];
    flash.image = [UIImage imageNamed:@"sandian"];
    [self.contentView addSubview:flash];
    self.flash = flash;
    //
   
    
    
    UILabel *descLab = [[UILabel alloc] init];
    descLab.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
    descLab.textColor = [UIColor grayColor];
    descLab.font = [UIFont boldSystemFontOfSize:13];
    descLab.numberOfLines = 0;
    [self.contentView addSubview:descLab];
    self.descripLab = descLab;
    
    
    UIButton *descBtn = [[UIButton alloc] init];
    [descBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    descBtn.titleLabel.font= [UIFont systemFontOfSize:14];
  [self.contentView addSubview:descBtn];
   self.descripBtn = descBtn;
    
   
    UILabel *goLab = [[UILabel alloc] init];
    goLab.textColor = [UIColor grayColor];
   goLab.font = [UIFont systemFontOfSize:11];
    goLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:goLab];
    self.goDateLab = goLab;
    
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setImage:[UIImage imageNamed:@"fenxianglan"] forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    self.shareBtn = btn;
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
    
    //分割线
    //    self.line.frame = CGRectMake(0, 135.5, self.contentView.frame.size.width, 0.5);
    //描述view
    CGFloat viewY = CGRectGetMaxY(self.icon.frame) + gap;
    CGFloat viewX = gap;
    CGFloat viewW = screenW - 2*gap;
    CGFloat viewH;
    if (_isPlain) {
        viewH = 130;//[self sizeWithText:self.descripLab.text].height ;
    }else {
        viewH = 20;
    }
    self.descripLab.frame = CGRectMake(viewX, viewY, viewW, viewH);
 //收起按钮
    CGFloat descBtnY = CGRectGetMaxY(self.descripLab.frame);
    self.descripBtn.frame = CGRectMake(viewX, descBtnY, viewW, 30);
    [self.descripBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewW-40)];
//出发日期
    CGFloat goLabY = CGRectGetMaxY(self.descripBtn.frame) + gap;
    self.goDateLab.frame = CGRectMake(viewX, goLabY, 200, 15);
    //分享按钮
    CGFloat shareX = screenW - 120 - gap;
    CGFloat shareW = 120;
    self.shareBtn.frame = CGRectMake(shareX, goLabY, shareW, 18);
    //self.shareBtn.contentMode = UIViewContentModeScaleAspectFill;
     [self.shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 75)];
    [self.shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0 , 0, -5)];
    
    self.rouHei = CGRectGetMaxY(self.shareBtn.frame)+10;
    
    [self.descripBtn addTarget:self action:@selector(changeTheRowHeight) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(shareIt) forControlEvents:UIControlEventTouchUpInside];

}

-(void)changeTheRowHeight
{
  
//   
//    if(_isPlain == NO && [self.descripBtn.currentTitle isEqualToString:@"展开"]){
//    
//  self.isPlain = YES;
//        [self.descripBtn setTitle:@"收起" forState:UIControlStateNormal];
//    [self layoutSubviews];
//   
//
//    }else if(_isPlain == YES && [self.descripBtn.currentTitle isEqualToString:@"收起"]){
//        self.isPlain = NO;
//        [self layoutSubviews];
//        [self.descripBtn setTitle:@"展开" forState:UIControlStateNormal];
//    }
    
    if (self.frame.size.height == 330) {
        [self.descripBtn setTitle:@"收起" forState:UIControlStateNormal];
        self.isPlain = YES;
        [self layoutSubviews];
    }else if (self.frame.size.height == 220){
        [self.descripBtn setTitle:@"全文" forState:UIControlStateNormal];
        self.isPlain = NO;
        [self layoutSubviews];
    }
}
-(void)shareIt
{
    NSDictionary *tmp = [StrToDic dicCleanSpaceWithDict:_detail.ShareInfo];
        //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:tmp[@"Desc"]
                                       defaultContent:tmp[@"Desc"]
                                                image:[ShareSDK imageWithUrl:tmp[@"Pic"]]
                                                title:tmp[@"Title"]
                                                  url:tmp[@"Url"]                                          description:tmp[@"Desc"]
                                            mediaType:SSPublishContentMediaTypeNews];
    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@   ,  %@ ,  %@",tmp[@"Tile"],tmp[@"Desc"],tmp[@"Url"]] image:nil];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //    [container setIPadContainerWithView:sender  arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 [self.warningLab removeFromSuperview];
                                if (state == SSResponseStateSuccess)
                                {
                                    [self.warningLab removeFromSuperview];
                                    [IWHttpTool postWithURL:@"Common/SaveShareRecord" params:@{@"ShareType":@"1",@"ShareUrl":tmp[@"Url"]} success:^(id json) {
                                    } failure:^(NSError *error) {
                                        
                                    }];
                                    //今日推荐
                                    [MBProgressHUD showSuccess:@"操作成功"];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                                        [MBProgressHUD hideHUD];
                                    });
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    [self.warningLab removeFromSuperview];
                                    //NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                   // NSLog(@"分享失败%ld,%@",(long)[error errorCode],[error errorDescription]);
                                }else if (state == SSResponseStateCancel){
                                    [self.warningLab removeFromSuperview];
                                }
                            }];
    
    [self addAlert];

}
- (void)setDetail:(DayDetail *)modal
{
    
    _detail = modal;
    
    if (!self.isHistory) {
        self.time.hidden = YES;
        self.sep.hidden = YES;
    }
    
    // 历史时间
    self.time.text = [NSString stringWithFormat:@"浏览时间: %@",modal.HistoryViewTime];
    
    //出发时间
//    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[modal.LastScheduleDate doubleValue]];
//  self.goDateLab.text = [createDate formattedTime];
    self.goDateLab.text = modal.PushDate;
  
    self.fanIsZero = [modal.PersonBackPrice integerValue];
    self.quanIsZero = [modal.PersonCashCoupon integerValue];
    
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
    [self.jiafanBtn setTitle:[NSString stringWithFormat:@"      ￥%@",modal.PersonBackPrice] forState:UIControlStateNormal];
    [self.quanBtn setTitle:[NSString stringWithFormat:  @"      ￥%@",modal.PersonCashCoupon] forState:UIControlStateNormal];
    [self.ShanDianBtn setTitle:[NSString stringWithFormat:@"%@出发",modal.StartCityName] forState:UIControlStateNormal];
    if ([modal.StartCityName isEqualToString:@"不限"]) {
        [self.ShanDianBtn setTitle:[NSString stringWithFormat:@"%@",modal.StartCityName] forState:UIControlStateNormal];
    }
    
    [self.ShanDianBtn sizeToFit];
    
    self.isFlash = [modal.IsComfirmStockNow integerValue];
    
    //描述块
   
    
    self.descripLab.text = modal.AdvertText;
    
    self.descripBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.descripBtn.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
   
    self.descripBtn.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];

    if (self.frame.size.height == 330) {
       
        [self.descripBtn setTitle:@"收起" forState:UIControlStateNormal];
    
    }else{
    
    [self.descripBtn setTitle:@"全文" forState:UIControlStateNormal];
    }

    
    [self.shareBtn setTitle:@"分享给客户" forState:UIControlStateNormal];
    [self.shareBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
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
- (CGSize)sizeWithText:(NSString *)text
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    CGFloat maxW = [[UIScreen mainScreen] bounds].size.width;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}

-(void)addAlert
{
    
    
    // 获取到现在应用中存在几个window，ios是可以多窗口的
    
    NSArray *windowArray = [UIApplication sharedApplication].windows;
    
    // 取出最后一个，因为你点击分享时这个actionsheet（其实是一个window）才会添加
    
    UIWindow *actionWindow = (UIWindow *)[windowArray lastObject];
    
    // 以下就是不停的寻找子视图，修改要修改的
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat labY = 180;
    if (screenH == 667) {
        labY = 260;
    }else if (screenH == 568){
        labY = 160;
    }else if (screenH == 480){
        labY = 180;
    }else if (screenH == 736){
        labY = 440;
    }
    
    CGFloat labW = [[UIScreen mainScreen] bounds].size.width;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH, labW, 30)];
    lab.text = @"您分享出去的内容对外只显示门市价";
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    [actionWindow addSubview:lab];
    [UIView animateWithDuration:0.4 animations:^{
        lab.transform = CGAffineTransformMakeTranslation(0, labY-screenH);
    }];
    self.warningLab = lab;

}



@end
