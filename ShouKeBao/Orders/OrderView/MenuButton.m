//
//  MenuButton.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MenuButton.h"

@interface MenuButton()

@property (nonatomic,weak) UIView *sep;

@end

@implementation MenuButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn setTitle:@"时间不限" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftBtn addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        self.leftBtn = leftBtn;
        
        UIView *sep = [[UIView alloc] init];
        sep.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self addSubview:sep];
        self.sep = sep;
        
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn setTitle:@"全部状态" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        self.rightBtn = rightBtn;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    self.leftBtn.frame = CGRectMake(0, 0, screenW * 0.5 - 0.5, self.frame.size.height);
    
    CGFloat sepX = CGRectGetMaxX(self.leftBtn.frame);
    self.sep.frame = CGRectMake(sepX, 5, 1, self.frame.size.height - 10);
    
    CGFloat rightX = CGRectGetMaxX(self.sep.frame);
    self.rightBtn.frame = CGRectMake(rightX, 0, screenW * 0.5 - 0.5, self.frame.size.height);
}

- (void)left:(UIButton *)left
{
    if (_delegate && [_delegate respondsToSelector:@selector(menuDidSelectLeftBtn:)]) {
        [_delegate menuDidSelectLeftBtn:left];
    }
}

- (void)right:(UIButton *)right
{
    if (_delegate && [_delegate respondsToSelector:@selector(menuDidSelectRightBtn:)]) {
        [_delegate menuDidSelectRightBtn:right];
    }
}

@end
