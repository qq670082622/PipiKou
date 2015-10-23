//
//  Menum.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/8/11.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Menum.h"
#import "ArrowBtn.h"

@interface Menum()

@property (nonatomic,weak) UIView *sep;// 中间的线

@property (nonatomic,weak) UIView *sep2;// 下边的线

@end



@implementation Menum

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ArrowBtn *leftBtn = [[ArrowBtn alloc] init];
        [leftBtn addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        self.leftButton = leftBtn;
        
        UIView *sep = [[UIView alloc] init];
        sep.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self addSubview:sep];
        self.sep = sep;
        
        ArrowBtn *rightBtn = [[ArrowBtn alloc] init];
        [rightBtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        self.reghtButton = rightBtn;
        
        
        UIView *sep2 = [[UIView alloc] init];
        sep2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self addSubview:sep2];
        self.sep2 = sep2;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    self.leftButton.frame = CGRectMake(0, 0, screenW * 0.5 - 0.5, self.frame.size.height);
    CGFloat sepX = CGRectGetMaxX(self.leftButton.frame);
    self.sep.frame = CGRectMake(sepX, 5, 1, self.frame.size.height - 10);
    
    CGFloat rightX = CGRectGetMaxX(self.sep.frame);
    self.reghtButton.frame = CGRectMake(rightX, 0, screenW * 0.5 - 0.5, self.frame.size.height);
    
    self.sep2.frame = CGRectMake(0, self.frame.size.height - 1, screenW, 1);
    
    self.leftButton.text = @"时间不限";
    self.reghtButton.text = @"全部状态";
}

- (void)left:(UIButton *)left
{
    if (_dalegate && [_dalegate respondsToSelector:@selector(menumLiftButton:)]) {
        [_dalegate menumLiftButton:left];
    }
}

- (void)right:(UIButton *)right
{
    if (_dalegate && [_dalegate respondsToSelector:@selector(menumRightButton:)]) {
        [_dalegate menumRightButton:right];
    }
}













/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
