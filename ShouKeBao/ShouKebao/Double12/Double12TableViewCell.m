//
//  Double12TableViewCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Double12TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Category.h"
#import "NSString+FKTools.h"
#define gap 10
@implementation Double12TableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"double12TableViewCell";
    Double12TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[Double12TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
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
    // 图标
    UIImageView *iconView = [[UIImageView alloc] init];
//    iconView.backgroundColor = [UIColor purpleColor];
    iconView.layer.cornerRadius = 3;
    iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 标题
    UILabel *titleLab = [[UILabel alloc] init];
//    titleLab.backgroundColor = [UIColor greenColor];
    titleLab.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    
    // 时间
    UILabel *timeLab = [[UILabel alloc] init];
//    timeLab.backgroundColor = [UIColor greenColor];
    timeLab.textColor = [UIColor lightGrayColor];
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:timeLab];
    self.timeLab = timeLab;
    
    //红色字部分
    UILabel *redL = [[UILabel alloc] init];
//    redL.backgroundColor = [UIColor redColor];
    redL.textColor = [UIColor redColor];
    redL.textAlignment = NSTextAlignmentLeft;
    redL.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:redL];
    self.redLable = redL;
    
    // 详情
    UILabel *detailLab = [[UILabel alloc] init];
//    detailLab.backgroundColor = [UIColor yellowColor];
    detailLab.textColor = [UIColor blackColor];
    detailLab.font = [UIFont systemFontOfSize:13];
    detailLab.numberOfLines = 0;
    [self.contentView addSubview:detailLab];
    self.detailLable = detailLab;
    
    //双12大图片
    UIImageView *doubleImage = [[UIImageView alloc] init];
//    doubleImage.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:doubleImage];
    self.doubleImage = doubleImage;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentView.frame.size.height;
    // 图标
    CGFloat iconW = 35;
    self.iconView.frame = CGRectMake(gap, gap, iconW, iconW);
    
    // 标题
    CGFloat titleX = CGRectGetMaxX(self.iconView.frame) + gap;
    CGFloat titleW = (screenW - iconW - gap * 4) * 0.5;
    self.titleLab.frame = CGRectMake(titleX, gap, titleW, 20);
    
//    时间
    CGFloat timeX = CGRectGetMaxX(self.titleLab.frame) + gap;
    self.timeLab.frame = CGRectMake(timeX, gap, titleW, 20);
    
//    红色字部分
    CGFloat redLY = CGRectGetMaxY(self.titleLab.frame);
    self.redLable.frame = CGRectMake(titleX, redLY, screenW-titleX-gap, 20);
    
//   详情部分
    
    CGFloat detailY = CGRectGetMaxY(self.redLable.frame);
    self.detailLable.frame = CGRectMake(titleX, detailY, screenW-titleX-gap, 40);
    
//  双12大图
    CGFloat doubleImageY = CGRectGetMaxY(self.detailLable.frame)+gap/2;
    CGFloat doubleImageH = height - doubleImageY-gap;
    self.doubleImage.frame = CGRectMake(titleX, doubleImageY, screenW-2*titleX+gap, doubleImageH);
    
    
}

- (void)setDoubleModel:(DoubleModel *)doubleModel{
    _doubleModel = doubleModel;
 
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _doubleModel.IconUrl]]];
    self.titleLab.text = [NSString stringWithFormat:@"%@", _doubleModel.FirstTitle];
    
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[_doubleModel.CreatedDate doubleValue]];
    self.timeLab.text = [createDate formattedTime];
    
    self.redLable.text = [NSString stringWithFormat:@"%@", _doubleModel.SecondTitle];
    self.detailLable.text = [NSString stringWithFormat:@"%@", _doubleModel.ThirdTitle];
    
    [self.doubleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _doubleModel.BannerUrl]]];
   
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
