//
//  TravelCell.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/7.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "TravelCell.h"
#import "TravelButton.h"
#import "Travel.h"

@interface TravelCell()

@property (nonatomic,weak) TravelButton *travelBtn;

@end

@implementation TravelCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"travelcell";
    TravelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TravelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    TravelButton *travelBtn = [[TravelButton alloc] init];
    [travelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    travelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    travelBtn.layer.cornerRadius = 5;
    travelBtn.layer.masksToBounds = YES;
    [travelBtn setBackgroundImage:[UIImage imageNamed:@"lxsbtn"] forState:UIControlStateNormal];
    [travelBtn setBackgroundImage:[UIImage imageNamed:@"lxsbtn_selected"] forState:UIControlStateHighlighted];
    [travelBtn addTarget:self action:@selector(selectedTravel:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:travelBtn];
    self.travelBtn = travelBtn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    self.travelBtn.frame = CGRectMake(20, 10, screenW - 40, 60);
}

- (void)setModel:(Travel *)model
{
    _model = model;
    
    [self.travelBtn setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
    
    [self.travelBtn setTitle:model.title forState:UIControlStateNormal];
}

- (void)selectedTravel:(TravelButton *)btn
{
    NSLog(@"00000----%d",self.indexPath.row);
}

@end
