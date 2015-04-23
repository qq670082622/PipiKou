//
//  StepView.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "StepView.h"

@implementation StepView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
        self.image = [UIImage imageNamed:@""];
    }
    return self;
}

- (void)setup
{
    UIButton *step1 = [[UIButton alloc] init];
    [step1 setTitle:@"" forState:UIControlStateNormal];
    step1.enabled = NO;
    step1.adjustsImageWhenDisabled = NO;
    [self addSubview:step1];
    
    UIButton *step2 = [[UIButton alloc] init];
    [step2 setTitle:@"" forState:UIControlStateNormal];
    step2.enabled = NO;
    step2.adjustsImageWhenDisabled = NO;
    [self addSubview:step2];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
