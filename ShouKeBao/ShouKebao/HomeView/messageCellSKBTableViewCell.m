//
//  messageCellSKBTableViewCell.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/6/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "messageCellSKBTableViewCell.h"
#import "NSDate+Category.h"
@implementation messageCellSKBTableViewCell



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"msgCell";
    messageCellSKBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[messageCellSKBTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
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
-(void)setup
{
    // 图标
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.cornerRadius = 3;
    iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 标题
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    
    // 时间
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.textColor = [UIColor lightGrayColor];
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:timeLab];
    self.timeLab = timeLab;
    
    // 详情
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.textColor = [UIColor grayColor];
    detailLab.font = [UIFont systemFontOfSize:13];
    detailLab.numberOfLines = 0;
    [self.contentView addSubview:detailLab];
    self.detailLab = detailLab;


}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 图标
    CGFloat iconW = 35;
    self.iconView.frame = CGRectMake(gap, gap, iconW, iconW);
    
    // 标题
    CGFloat titleX = CGRectGetMaxX(self.iconView.frame) + gap;
    CGFloat titleW = (screenW - iconW - gap * 4) * 0.5;
    self.titleLab.frame = CGRectMake(titleX, gap, titleW, 20);
    // 时间
    CGFloat timeX = CGRectGetMaxX(self.titleLab.frame) + gap;
    self.timeLab.frame = CGRectMake(timeX, gap, titleW, 20);
//详情
    CGFloat detailY = CGRectGetMaxY(self.titleLab.frame)+gap;
    CGFloat detailW = screenW - 2*titleX;
    self.detailLab.frame = CGRectMake(titleX, detailY, detailW, 50);
    
}

- (void)setModel:(MessageModel2 *)model
{
    _model = model;
    self.iconView.image = [UIImage imageNamed:@"tix"];
        self.detailLab.text = model.title;
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[model.CreatedDate doubleValue]];
    self.timeLab.text = [createDate formattedTime];
    self.titleLab.text = model.Type;
    self.titleLab.textColor = [UIColor colorWithRed:70/255.f green:215/255.f blue:59/255.f alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
