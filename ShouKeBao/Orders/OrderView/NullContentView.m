//
//  NullContentView.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NullContentView.h"

@interface NullContentView()

@property (nonatomic,weak) UIImageView *icon;

@property (nonatomic,weak) UILabel *textLab;

@end

@implementation NullContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_null"]];
    [self addSubview:icon];
    self.icon = icon;
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.font = [UIFont systemFontOfSize:13];
    textLab.numberOfLines = 0;
    textLab.textColor = [UIColor colorWithRed:103/255.0 green:103/255.0 blue:103/255.0 alpha:1];
    [self addSubview:textLab];
    self.textLab = textLab;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat iconW = self.frame.size.width / 2;
    CGFloat iconH = 5 * iconW / 4;
    CGFloat iconX = (self.frame.size.width - iconW) * 0.5;
    self.icon.frame = CGRectMake(iconX, 0, iconW, iconH);
    
    CGFloat labW = self.frame.size.width;
    CGFloat labY = CGRectGetMaxY(self.icon.frame) + 5;
    self.textLab.frame = CGRectMake(0, labY, labW, 40);
}

- (void)setNullContentIsSearch:(BOOL)isSearch
{
       NSLog(@",,,,,,,,咦,您还未下单!您可以进入找产");
    if (isSearch) {
        self.textLab.text = @"咦,还未找到您的订单~";
    }else{
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"咦,您还未下单!\n您可以进入找产品进行下单哟~"];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(9, 14)];
        self.textLab.attributedText = attr;
        NSLog(@"咦,您还未下单!您可以进入找产");
    }
}

@end
