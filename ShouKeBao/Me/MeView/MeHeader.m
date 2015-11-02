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
        UILabel *lable = [[UILabel alloc]init];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor colorWithRed:99/255.0 green:33/255.0 blue:0/255.0 alpha:1.0];
#warning 设置顾问字体
        lable.font = [UIFont fontWithName:@"Helvetica" size:14];
        NSLog(@"%@", [UIFont familyNames]);
        self.levelName = lable;
        UIImageView * levelIcon = [[UIImageView alloc]init];
        [self addSubview:levelIcon];
        self.levelIcon = levelIcon;

        [self.levelIcon addSubview:self.levelName];
        
        UILabel *nickName = [[UILabel alloc] init];
        nickName.textAlignment = NSTextAlignmentCenter;
        nickName.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:nickName];
        self.nickName = nickName;
        
        UILabel *positionLab = [[UILabel alloc] init];
        positionLab.textAlignment = NSTextAlignmentCenter;
        positionLab.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:positionLab];
        self.positionLab = positionLab;

        
        UILabel *personType = [[UILabel alloc] init];
        personType.textColor = [UIColor blackColor];
        personType.textAlignment = NSTextAlignmentCenter;
//        personType.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        personType.layer.cornerRadius = 5;
        personType.layer.masksToBounds = YES;
        personType.font = [UIFont systemFontOfSize:14];
        [self addSubview:personType];
        self.personType = personType;
        
        UIButton *setBtn = [[UIButton alloc] init];
        [setBtn setBackgroundImage:[UIImage imageNamed:@"setting_icon"] forState:UIControlStateNormal];
        [self addSubview:setBtn];
        self.setBtn = setBtn;
        CGFloat btnX = self.frame.size.width - 47;
        UIButton *bigSetBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 40, 40, 40)];
        [bigSetBtn addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bigSetBtn];
        //更多旅游顾问详细
        UIButton * moreBtn = [[UIButton  alloc]initWithFrame:CGRectMake(self.frame.size.width - 125, 160, 125, 20)];
        [moreBtn addTarget:self action:@selector(clickMore:) forControlEvents:UIControlEventTouchUpInside];
        [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.GuWemInfo = moreBtn;
        
        [self addSubview:moreBtn];

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
   
    CGFloat headW = self.isPerson ? 100 : 100;
    if (self.isPerson) {
        self.headIcon.frame = CGRectMake(20, 60, headW, 100);
        self.levelIcon.frame = CGRectMake(20, 143, 100, 20);
        self.levelName.frame = CGRectMake(20, 0, 70, 20);
        
        CGFloat nameY = CGRectGetMinY(self.headIcon.frame) + 8;
        CGFloat nameX = CGRectGetMaxX(self.headIcon.frame) + 13;
        CGFloat labW = self.frame.size.width - 150;
        self.nickName.frame = CGRectMake(nameX, nameY, labW, 20);
        self.nickName.textAlignment = NSTextAlignmentLeft;
        
        
        CGFloat positionY = CGRectGetMaxY(self.nickName.frame) + 8;
        self.positionLab.frame = CGRectMake(nameX, positionY, labW, 20);
        self.positionLab.textAlignment = NSTextAlignmentLeft;
        
        
        CGFloat typeY = CGRectGetMaxY(self.positionLab.frame) + 8;
        self.personType.frame = CGRectMake(nameX, typeY, self.frame.size.width, 20);
        self.personType.textAlignment = NSTextAlignmentLeft;
        
        [self.GuWemInfo  setTitle:@"查看顾问明细〉" forState:UIControlStateNormal];

    }else{
        CGFloat headX = (self.frame.size.width - headW) * 0.5;
        self.headIcon.frame = CGRectMake(headX, 40, headW, 70);
        self.positionLab.frame = CGRectZero;
        CGFloat nameY = CGRectGetMaxY(self.headIcon.frame) + 8;
        self.nickName.frame = CGRectMake(0, nameY, self.frame.size.width, 20);
        
        CGFloat typeY = CGRectGetMaxY(self.nickName.frame) + 8;
        self.personType.frame = CGRectMake(0, typeY, self.frame.size.width, 20);
        [self.GuWemInfo  setTitle:@"更多顾问明细〉" forState:UIControlStateNormal];

    }
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
- (void)clickMore:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(didClickMoreLYGW)]) {
        [_delegate didClickMoreLYGW];
    }

}
- (void)setIsPerson:(BOOL)isPerson
{
    _isPerson = isPerson;
    
    self.headIcon.layer.cornerRadius = isPerson ? 50 : 3;
}

@end
