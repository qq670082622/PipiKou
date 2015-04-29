//
//  RecommendCell.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "RecommendCell.h"
#import "Recommend.h"
#import "NSDate+Category.h"

@interface RecommendCell()

@end

@implementation RecommendCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"recommendcell";
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftLab.font = [UIFont systemFontOfSize:13];
        self.leftLab.textColor = [UIColor lightGrayColor];
        
        UIImageView *redTip = [[UIImageView alloc] init];
        redTip.backgroundColor = [UIColor redColor];
        redTip.hidden = YES;
        redTip.layer.cornerRadius = 5;
        redTip.layer.masksToBounds = YES;
        [self.contentView addSubview:redTip];
        self.redTip = redTip;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_redTip isHidden]) {
        _redTip.backgroundColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_redTip isHidden]) {
        _redTip.backgroundColor = [UIColor redColor];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGRect rect = self.leftLab.frame;
    rect.size.width = screenW - 35 - 30;
    self.leftLab.frame = rect;
    
    CGFloat detailY = CGRectGetMaxY(self.leftLab.frame) + gap;
    CGFloat detailW = screenW - gap * 3 - self.iconView.frame.size.width;
    self.detailLab.frame = CGRectMake(self.leftLab.frame.origin.x, detailY, detailW, 20);
    
    CGFloat tipX = CGRectGetMaxX(self.iconView.frame) - 5;
    CGFloat tipY = self.iconView.frame.origin.y - 5;
    self.redTip.frame = CGRectMake(tipX, tipY, 10, 10);
}

- (void)setRecommend:(Recommend *)recommend
{
    _recommend = recommend;
    
    self.iconView.image = [UIImage imageNamed:@"jinxuan"];
    
    self.titleLab.text = @"精品推荐";
    
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[recommend.CreatedDate doubleValue]];
    self.timeLab.text = [createDate formattedTime];
    
    self.leftLab.text = [NSString stringWithFormat:@"今日共向您推荐%@条精品线路",recommend.Count];
    
    
    NSString *str = [NSString stringWithFormat:@"最低价%@元起",recommend.Price];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    [dic setObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    
    [attrStr addAttributes:dic range:NSMakeRange(3, recommend.Price.length)];
    [self.detailLab setAttributedText:attrStr];
}

@end
