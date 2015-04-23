//
//  StepView.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "StepView.h"
#import "UIImage+QD.h"

@interface StepView()

@property (nonatomic,strong) NSMutableArray *stepArr;

@end

@implementation StepView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (NSMutableArray *)stepArr
{
    if (!_stepArr) {
        _stepArr = [NSMutableArray array];
    }
    return _stepArr;
}

- (void)setup
{
    for (int i = 0; i < 2;i ++) {
        UIButton *step = [[UIButton alloc] init];
        step.tag = i;
        step.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        step.titleLabel.font = [UIFont systemFontOfSize:13];
        [step setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] forState:UIControlStateNormal];
        [step setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [step setImage:[UIImage imageNamed:[NSString stringWithFormat:@"step%d",i + 1]] forState:UIControlStateNormal];
        [step setImage:[UIImage imageNamed:[NSString stringWithFormat:@"step%d_selected",i + 1]] forState:UIControlStateSelected];
        [step setTitle:i == 0 ? @"验证收客宝手机" : @"登录旅行社账号" forState:UIControlStateNormal];
        step.reversesTitleShadowWhenHighlighted = NO;
        step.adjustsImageWhenHighlighted = NO;
        [self addSubview:step];
        [self.stepArr addObject:step];
    }
    
    UIImageView *arrow = [[UIImageView alloc] init];
    arrow.image = [UIImage imageNamed:@"guid_arrow"];
    CGFloat arrowX = (self.frame.size.width - 15) * 0.5;
    CGFloat arrowY = (self.frame.size.height - 15) * 0.5;
    arrow.frame = CGRectMake(arrowX, arrowY, 15, 15);
    [self addSubview:arrow];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < 2; i ++) {
        UIButton *step = self.stepArr[i];
        
        CGFloat stepW = self.frame.size.width * 0.5;
        CGFloat stepX = stepW * i;
        step.frame = CGRectMake(stepX, 0, stepW, self.frame.size.height);
    }
}

- (void)setStepAtIndex:(NSInteger)index
{
    for (int i = 0; i < 2; i ++) {
        UIButton *step = self.stepArr[i];
        if (i == index) {
            step.selected = YES;
        }else{
            step.selected = NO;
        }
    }
}

@end
