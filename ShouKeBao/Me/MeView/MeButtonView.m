//
//  MeButtonView.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeButtonView.h"
#import "MeButton.h"

@interface MeButtonView()

@property (nonatomic,weak) MeButton *collectionBtn;

@property (nonatomic,weak) MeButton *previewBtn;

@property (nonatomic,weak) MeButton *sosBtn;

@end

@implementation MeButtonView

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
    MeButton *collectionBtn = [[MeButton alloc] init];
    collectionBtn.tag = 0;
    [collectionBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
    [self setWithButton:collectionBtn];
    [self addSubview:collectionBtn];
    self.collectionBtn = collectionBtn;
    
    MeButton *previewBtn = [[MeButton alloc] init];
    previewBtn.tag = 1;
    [previewBtn setBackgroundImage:[UIImage imageNamed:@"kong"] forState:UIControlStateNormal];
    [previewBtn setTitle:@"客户最近浏览" forState:UIControlStateNormal];
    [self setWithButton:previewBtn];
    [self addSubview:previewBtn];
    self.previewBtn = previewBtn;
    
    MeButton *sosBtn = [[MeButton alloc] init];
    sosBtn.tag = 2;
    [sosBtn setTitle:@"搬救兵" forState:UIControlStateNormal];
    [self setWithButton:sosBtn];
    [self addSubview:sosBtn];
    self.sosBtn = sosBtn;
}

- (void)setWithButton:(MeButton *)button
{
    NSString *name = [NSString stringWithFormat:@"mebutton_%ld",(long)button.tag];
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    for (int i = 0; i < self.subviews.count; i ++) {
        MeButton *btn = self.subviews[i];
        
        CGFloat btnW = self.frame.size.width / 3;
        CGFloat btnX = btnW * i;
        btn.frame = CGRectMake(btnX, 0, btnW, self.frame.size.height);
    }
}

- (void)headerButtonClick:(MeButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(buttonViewSelectedWithIndex:)]) {
        [_delegate buttonViewSelectedWithIndex:btn.tag];
    }
}

@end
