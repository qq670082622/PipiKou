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
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGRect rect = self.leftLab.frame;
    rect.size.width = screenW - 35 - 30;
    self.leftLab.frame = rect;
}

- (void)setRecommend:(Recommend *)recommend
{
    _recommend = recommend;
    
    self.iconView.image = [UIImage imageNamed:@"jinxuan"];
    
    self.titleLab.text = @"精品推荐";
    
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[recommend.CreatedDate doubleValue]];
    self.timeLab.text = [createDate formattedTime];
    
    self.leftLab.text = [NSString stringWithFormat:@"今日共享您推荐%@条精品线路",recommend.Count];
    
    
    NSString *str = [NSString stringWithFormat:@"最低价%@元起",recommend.Price];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    [dic setObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    
    [attrStr addAttributes:dic range:NSMakeRange(3, recommend.Price.length)];
    [self.detailLab setAttributedText:attrStr];
}

@end
