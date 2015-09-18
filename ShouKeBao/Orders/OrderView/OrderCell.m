//
//  OrderCell.m
//  ShouKeBao
//
//  Created by Chard on 15/3/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "OrderCell.h"
#import "OrderModel.h"
#import "UIImageView+WebCache.h"
#import "ButtonList.h"
#import "LinkButton.h"
#import "NSString+QD.h"

#define gap 10

@interface OrderCell()

// 上线条
//@property (weak, nonatomic) UIView *sep1;

// 中线条
@property (weak, nonatomic) UIView *sep2;

// 下线条
@property (weak, nonatomic) UIView *sep3;

// 订单号
@property (weak, nonatomic) UILabel *tourCode;
// 状态图标
@property (weak, nonatomic) UIImageView *statusIcon;
// 创建时间
@property (weak, nonatomic) UILabel *createTime;
// 旅游图标
@property (weak, nonatomic) UIImageView *tourIcon;
// 旅游标题
@property (weak, nonatomic) UILabel *tourTitle;
// 价格
@property (weak, nonatomic) UILabel *price;
// 成人个数
@property (weak, nonatomic) UILabel *adultCount;
// 儿童个数
@property (weak, nonatomic) UILabel *childCount;
// 出发日期
@property (weak, nonatomic) UILabel *goTime;
// 状态描述
@property (weak, nonatomic) UILabel *statusDes;

// 底部按钮
@property (weak, nonatomic) UIView *bottomView;

@property (nonatomic,strong) NSMutableArray *buttonArr;

@end

@implementation OrderCell

#pragma mark - initailize
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ordercellaa";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self.contentView addSubview:self.orderTmpView];
        [self setup];
    }
    return self;
}

//- (OrderTmpView *)orderTmpView
//{
//    if (!_orderTmpView) {
//        _orderTmpView = [[[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:nil options:nil] lastObject];
//        _orderTmpView.frame = self.bounds;
//    }
//    return _orderTmpView;
//}

#pragma mark - setup
- (void)setup
{
    // 上线条
//    UIView *sep1 = [[UIView alloc] init];
//    [self.contentView addSubview:sep1];
//    self.sep1 = sep1;
    
    // 中线条
    UIView *sep2 = [[UIView alloc] init];
    sep2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [self.contentView addSubview:sep2];
    self.sep2 = sep2;
    
    // 下线条
    UIView *sep3 = [[UIView alloc] init];
    sep3.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [self.contentView addSubview:sep3];
    self.sep3 = sep3;
    
    // 订单号
    UILabel *tourCode = [[UILabel alloc] init];
    tourCode.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:tourCode];
    self.tourCode = tourCode;
    
    // 状态图标
    UIImageView *statusIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:statusIcon];
    self.statusIcon = statusIcon;
    
    // 创建时间
    UILabel *createTime = [[UILabel alloc] init];
    createTime.font = [UIFont systemFontOfSize:12];
    createTime.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:createTime];
    self.createTime = createTime;
    
    // 旅游图标
    UIImageView *tourIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:tourIcon];
    self.tourIcon = tourIcon;
    
    // 旅游标题
    UILabel *tourTitle = [[UILabel alloc] init];
    tourTitle.font = [UIFont systemFontOfSize:15];
    tourTitle.numberOfLines = 0;
    [self.contentView addSubview:tourTitle];
    self.tourTitle = tourTitle;
    
    // 价格
    UILabel *price = [[UILabel alloc] init];
    price.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:price];
    self.price = price;
    
    // 成人个数
    UILabel *adultCount = [[UILabel alloc] init];
    adultCount.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:adultCount];
    self.adultCount = adultCount;
    
    // 儿童个数
    UILabel *childCount = [[UILabel alloc] init];
    childCount.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:childCount];
    self.childCount = childCount;
    
    // 出发日期
    UILabel *goTime = [[UILabel alloc] init];
    goTime.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:goTime];
    self.goTime = goTime;
    
    // 状态描述
    UILabel *statusDes = [[UILabel alloc] init];
    statusDes.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:statusDes];
    self.statusDes = statusDes;
    
    // 底部按钮
    UIView *bottomView = [[UIView alloc] init];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (void)setFrameWithModel:(OrderModel *)model
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 上线条
//    self.sep1.frame = CGRectMake(0, 0, screenW, 2);
    
    // 状态图标
    CGFloat statusIconX = gap * 2;
//    CGFloat statusIconY = CGRectGetMaxY(self.sep1.frame) + gap;
    CGFloat statusIconY = gap;
    CGFloat statusW = [model.ProgressState integerValue] == 0 ? 0 : 24;
    self.statusIcon.frame = CGRectMake(statusIconX, statusIconY, statusW, 20);
    
    // 订单号
    CGFloat codeX = CGRectGetMaxX(self.statusIcon.frame) + gap;
    CGFloat codeW = (screenW - statusW - gap * 5) * 0.65 + 10;
    self.tourCode.frame = CGRectMake(codeX, statusIconY, codeW, 20);
    
    // 创建时间
    CGFloat creatTimeW = (screenW - statusW - gap * 5) * 0.35;
    CGFloat creatTimeX = screenW - creatTimeW - gap * 2;
    self.createTime.frame = CGRectMake(creatTimeX, statusIconY, creatTimeW, 20);
    
    // 中线条
    CGFloat sep2Y = CGRectGetMaxY(self.statusIcon.frame) + gap;
    CGFloat sep2W = screenW - gap * 4;
    self.sep2.frame = CGRectMake(gap * 2, sep2Y, sep2W, 1);
    
    // 旅游图标
    CGFloat iconY = CGRectGetMaxY(self.sep2.frame) + gap;
    self.tourIcon.frame = CGRectMake(statusIconX, iconY, 40, 40);
    
    // 旅游标题
    CGFloat titleX = CGRectGetMaxX(self.tourIcon.frame) + gap;
    CGFloat titleW = sep2W - 40 - gap;
    self.tourTitle.frame = CGRectMake(titleX, iconY, titleW, 40);
    
    // 价格
    CGFloat priceY = CGRectGetMaxY(self.tourIcon.frame) + gap;
    self.price.frame = CGRectMake(statusIconX, priceY, 100, 20);
    
    // 成人个数
    CGFloat adultX = screenW * 0.4;
    CGFloat adultW = [model.IsCruiseShip integerValue] == 1 ? 0 : 40;
    self.adultCount.frame = CGRectMake(adultX, priceY, adultW, 20);
    
    // 儿童个数
    CGFloat childX = CGRectGetMaxX(self.adultCount.frame) + gap * 0.5;
    self.childCount.frame = CGRectMake(childX, priceY, 40, 20);
    
    // 出发日期
    CGFloat goTimeX = CGRectGetMaxX(self.childCount.frame) + gap * 0.5;
    self.goTime.frame = CGRectMake(goTimeX, priceY, 100, 20);
    
    // 状态描述
    CGFloat statusDesH = 20;
    CGFloat bottomGap = gap;
    CGFloat sep3H = 1;
    if (!model.buttonList.count) {
        statusDesH = 0;
        bottomGap = 0;
        sep3H = 0;
    }
    CGFloat statusY = CGRectGetMaxY(self.price.frame) + gap;
    self.statusDes.frame = CGRectMake(statusIconX, statusY, sep2W, statusDesH);
    
    // 下线条
    CGFloat sep3Y = CGRectGetMaxY(self.statusDes.frame) + bottomGap;
    self.sep3.frame = CGRectMake(0, sep3Y, screenW, sep3H);
    
    // 底部按钮
    CGFloat bottomY = CGRectGetMaxY(self.sep3.frame);
    self.bottomView.frame = CGRectMake(0, bottomY, screenW, 40);
}

- (void)setModel:(OrderModel *)model
{
    _model = model;
    
    [self setFrameWithModel:model];
    
//    self.sep3.hidden = !model.buttonList.count;
    
    // 上线条
//    self.sep1.backgroundColor = model.TopBarColor;
    // 订单号
    self.tourCode.text = model.Code;
    
    // 状态图标
    NSString *name = [NSString stringWithFormat:@"progress%@",model.ProgressState];
    self.statusIcon.image = [UIImage imageNamed:name];
    
    // 创建时间
    self.createTime.text = model.CreatedDate;
    // 旅游图标
    [self.tourIcon sd_setImageWithURL:[NSURL URLWithString:model.ProductPicUrl] placeholderImage:nil];
    // 旅游标题
    self.tourTitle.text = model.ProductName;
    // 价格
    NSString *tmp = [NSString stringWithFormat:@"￥%@(同行)",model.OrderPrice];

    //    富文本：NSMutableAttributedString
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:tmp];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],
                             NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} range:NSMakeRange(0, model.OrderPrice.length + 1)];
    [self.price setAttributedText:attrStr];
    
    if ([model.IsCruiseShip integerValue] == 1) {
        NSString *count = [NSString stringWithFormat:@"%ld",[model.PersonCount integerValue] + [model.ChildCount integerValue]];
        self.childCount.text = [NSString stringWithFormat:@"人数%@",count];
    }else{
        // 成人个数
        self.adultCount.text = [NSString stringWithFormat:@"成人%@",model.PersonCount];
        // 儿童个数
        self.childCount.text = [NSString stringWithFormat:@"儿童%@",model.ChildCount];
    }
    
    // 出发日期
    self.goTime.text = model.GoDate;
    
    // 状态描述
    if ([model.StateText isEqual:[NSNull null]]) {
        
    }else{
    self.statusDes.text = model.StateText;
    }
    NSLog(@"%@33333333%@22222222%@", model.StateText, model.DetailLinkUrl, model.Code);
    self.statusDes.textColor = model.StateTextColor;
    
    // 先清空再添加
    [self.buttonArr removeAllObjects];
    for (UIView *view in self.bottomView.subviews) {
        [view removeFromSuperview];
    }
    
//    判断是否有数据，有则布局‘查看客户订单信息’和‘立即采购’控件。
    if (model.buttonList.count) {

//        for (ButtonList *btn in model.buttonList) {
        for (int i = (int)model.buttonList.count-1;i > -1; i--) {
            ButtonList * btn = [model.buttonList objectAtIndex:i];
            LinkButton *b = [[LinkButton alloc] init];
             [b setBackgroundImage:[UIImage imageNamed:@"lightgraybg"] forState:UIControlStateHighlighted];
            b.titleLabel.font = [UIFont systemFontOfSize:14];
            [b setTitle:btn.text forState:UIControlStateNormal];
            [b setTitleColor:btn.color forState:UIControlStateNormal];
            b.layer.borderWidth = 1;
            b.layer.cornerRadius = 3;
            b.layer.borderColor = btn.color.CGColor;
            b.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
            b.linkUrl = btn.linkurl;
            b.text = btn.text;
            NSLog(@"btn.text= %@", btn.text);
            NSLog(@"b.text= %@", b.text);
            NSLog(@"model.buttonList.count = %ld", model.buttonList.count);
            [b addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomView addSubview:b];
            [self.buttonArr addObject:b];
        }
        [self layoutButtons];
        
    }else{
  
        NSLog(@"2 model.buttonList.count = %ld", model.buttonList.count);

        CGFloat x = [UIScreen mainScreen].bounds.size.width - 90 - gap;
        UILabel *doneLab = [[UILabel alloc] initWithFrame:CGRectMake(x, 5, 90, 25)];
        doneLab.font = [UIFont boldSystemFontOfSize:20];
        doneLab.text = [model.ProgressState integerValue] == 0 ? @"订单取消" : @"交易完成";
        doneLab.textColor = [UIColor grayColor];
        [self.bottomView addSubview:doneLab];
        
        self.statusDes.text = nil;
    }
}

#pragma mark - getter
- (NSMutableArray *)buttonArr
{
    if (!_buttonArr) {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}

#pragma mark - private
- (void)layoutButtons
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGSize max = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGFloat btnW = 0;
    
    for (int i = 0; i < self.buttonArr.count; i++) {
        
        LinkButton *btn = self.buttonArr[i];
        CGSize btnSize = [NSString textSizeWithText:btn.text font:[UIFont systemFontOfSize:14] maxSize:max];
        btnW += btnSize.width + 12 + gap;
        CGFloat btnX = screenW - btnW;
        btn.frame = CGRectMake(btnX, 5, btnSize.width + 12, btnSize.height + 12);
    }
}

- (void)clickButton:(LinkButton *)sender
{
//    [sender setBackgroundColor:[UIColor grayColor]];
//    sender.showsTouchWhenHighlighted = YES;
    
//  [sender setBackgroundImage:[UIImage imageNamed:@"lightgraybg"] forState:UIControlStateHighlighted];
    
    if (sender.linkUrl.length) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"orderCellDidClickButton" object:nil userInfo:@{@"linkUrl":sender.linkUrl,@"title":sender.text}];
        NSLog(@"kkkkk  /////");
    }else{
        if (_orderDelegate && [_orderDelegate respondsToSelector:@selector(checkDetailAtIndex:)]) {
            [_orderDelegate checkDetailAtIndex:self.indexPath.section ];
        }
    }
   
}

@end
