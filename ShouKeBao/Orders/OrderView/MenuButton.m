//
//  MenuButton.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MenuButton.h"
#import "ArrowBtn.h"

@interface MenuButton()

@property (nonatomic,weak) UIView *sep;// 中间的线

@property (nonatomic,weak) UIView *sep2;// 下边的线

@end

@implementation MenuButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ArrowBtn *leftBtn = [[ArrowBtn alloc] init];
        
//        [leftBtn setImage:[UIImage imageNamed:@"xiangxia"] forState:UIControlStateNormal];
//        [leftBtn setTitle:@"时间不限" forState:UIControlStateNormal];
//        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftBtn addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        self.leftBtn = leftBtn;
        
        UIView *sep = [[UIView alloc] init];
        sep.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self addSubview:sep];
        self.sep = sep;
        
        ArrowBtn *rightBtn = [[ArrowBtn alloc] init];
//        [rightBtn setTitle:@"全部状态" forState:UIControlStateNormal];
//        [rightBtn setImage:[UIImage imageNamed:@"xiangxia"] forState:UIControlStateNormal];
//        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        self.rightBtn = rightBtn;

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
    
    self.leftBtn.frame = CGRectMake(0, 0, screenW * 0.5 - 0.5, self.frame.size.height);
    
    CGFloat sepX = CGRectGetMaxX(self.leftBtn.frame);
    self.sep.frame = CGRectMake(sepX, 5, 1, self.frame.size.height - 10);
    
    CGFloat rightX = CGRectGetMaxX(self.sep.frame);
    self.rightBtn.frame = CGRectMake(rightX, 0, screenW * 0.5 - 0.5, self.frame.size.height);
    
    self.sep2.frame = CGRectMake(0, self.frame.size.height - 1, screenW, 1);
    
    self.leftBtn.text = @"时间不限";
    self.rightBtn.text = @"全部状态";
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
