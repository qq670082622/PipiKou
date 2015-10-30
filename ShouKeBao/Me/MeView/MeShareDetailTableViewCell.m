//
//  MeShareDetailTableViewCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeShareDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "textStyle.h"
#define gap 10
@implementation MeShareDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{ static NSString *cellId = @"MeShareDetail";
    MeShareDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[MeShareDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.layer.cornerRadius = 5;
//    imageV.backgroundColor = [UIColor purpleColor];
    imageV.layer.masksToBounds = YES;
    [self.contentView addSubview:imageV];
    self.imageV = imageV;
    
    UILabel *title = [[UILabel alloc]init];
//    title.backgroundColor = [UIColor yellowColor];
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:title];
    self.titleLable = title;
    
    UILabel *go = [[UILabel alloc]init];
    go.textAlignment = NSTextAlignmentCenter;
    go.font = [UIFont systemFontOfSize:11];
    go.backgroundColor = [UIColor blackColor];
    go.alpha = 0.5;
    go.textColor = [UIColor whiteColor];
    [self.imageV addSubview:go];
    self.goLable = go;
    
    UILabel *skim = [[UILabel alloc]init];
//    skim.backgroundColor = [UIColor greenColor];
    skim.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:skim];
    self.skimLable = skim;
    
    UILabel *order = [[UILabel alloc]init];
//    order.backgroundColor = [UIColor redColor];
    order.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:order];
    self.orderLable = order;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = self.contentView.bounds.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageWidth = height-2*gap;

    self.imageV.frame = CGRectMake(gap, gap, imageWidth, imageWidth);
    self.titleLable.frame = CGRectMake(CGRectGetMaxX(self.imageV.frame)+5, gap, screenW-(CGRectGetMaxX(self.imageV.frame)+gap+5), imageWidth/2);
    
    self.goLable.frame = CGRectMake(0, imageWidth*4/5, imageWidth, imageWidth/5);
    self.skimLable.frame = CGRectMake(screenW/2+gap, CGRectGetMaxY(self.titleLable.frame), (screenW/2-2*gap)/2, imageWidth/2);
    self.orderLable.frame = CGRectMake(CGRectGetMaxX(self.skimLable.frame), CGRectGetMaxY(self.titleLable.frame), (screenW/2-2*gap)/2, imageWidth/2);
    
}

- (void)setShareModel:(MeShareDetailModel *)shareModel{
    _shareModel = shareModel;
    
    NSString *imageStr = self.shareModel.PicUrl;
    NSURL *url = [NSURL URLWithString:imageStr];
    [self.imageV sd_setImageWithURL:url];
//    NSLog(@"urllll = %@, urllll ------- %@", url, self.shareModel.StartCityName);
    
    self.titleLable.text = self.shareModel.Name;
    self.goLable.text = self.shareModel.StartCityName;
    
    
    NSString *skimStr = [NSString stringWithFormat:@"%@", self.shareModel.VisitCount];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"浏览数:%@",self.shareModel.VisitCount]];
//    [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(3, skimStr.length)];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(4, skimStr.length)];
    self.skimLable.attributedText = str1;
    
    NSString *orderStr = [NSString stringWithFormat:@"%@", self.shareModel.OrderCount];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单数:%@",self.shareModel.OrderCount]];
//    [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(4, orderStr.length)];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(4, orderStr.length)];
    self.orderLable.attributedText = str2;
    
    

}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
