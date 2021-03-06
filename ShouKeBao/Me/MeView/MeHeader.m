//
//  MeHeader.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeHeader.h"

@implementation MeHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *headIcon = [[UIImageView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead:)];
        headIcon.userInteractionEnabled = YES;
        [headIcon addGestureRecognizer:tap];
        headIcon.layer.masksToBounds = YES;
        headIcon.layer.borderWidth = 3;
        headIcon.layer.borderColor = [UIColor whiteColor].CGColor;
        headIcon.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:headIcon];
        self.headIcon = headIcon;
        
        UILabel *nickName = [[UILabel alloc] init];
        nickName.textAlignment = NSTextAlignmentCenter;
        nickName.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:nickName];
        self.nickName = nickName;
        
        UILabel *personType = [[UILabel alloc] init];
        personType.textColor = [UIColor whiteColor];
        personType.textAlignment = NSTextAlignmentCenter;
        personType.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        personType.layer.cornerRadius = 5;
        personType.layer.masksToBounds = YES;
        personType.font = [UIFont systemFontOfSize:13];
        [self addSubview:personType];
        self.personType = personType;
        
        UIButton *setBtn = [[UIButton alloc] init];
        [setBtn setBackgroundImage:[UIImage imageNamed:@"setting_icon"] forState:UIControlStateNormal];
//        [setBtn addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:setBtn];
        self.setBtn = setBtn;
        CGFloat btnX = self.frame.size.width - 47;
        UIButton *bigSetBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 40, 40, 40)];
        [bigSetBtn addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bigSetBtn];
        
        
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.image = [UIImage imageNamed:@"wobg"];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
    CGFloat headW = self.isPerson ? 90 : 120;
    CGFloat headX = (self.frame.size.width - headW) * 0.5;
    self.headIcon.frame = CGRectMake(headX, 40, headW, 90);
    
    CGFloat nameY = CGRectGetMaxY(self.headIcon.frame) + 8;
    self.nickName.frame = CGRectMake(0, nameY, self.frame.size.width, 20);

    CGFloat typeY = CGRectGetMaxY(self.nickName.frame) + 8;
    self.personType.frame = CGRectMake(headX, typeY, headW, 20);
    
    CGFloat btnX = self.frame.size.width - 37;
    self.setBtn.frame = CGRectMake(btnX, 40, 20, 20);
}

- (void)setting:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didClickSetting)]) {
        [_delegate didClickSetting];
    }
}

- (void)clickHead:(UITapGestureRecognizer *)ges
{
    NSLog(@"aa");
    if (_delegate && [_delegate respondsToSelector:@selector(didClickHeadIcon)]) {
        [_delegate didClickHeadIcon];
    }
}

- (void)setIsPerson:(BOOL)isPerson
{
    _isPerson = isPerson;
    
    self.headIcon.layer.cornerRadius = isPerson ? 45 : 3;
}

@end
