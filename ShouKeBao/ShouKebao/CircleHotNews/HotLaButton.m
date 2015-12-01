//
//  HotLaButton.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "HotLaButton.h"
#define gap 5
@implementation HotLaButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 16, 35, frame.size.height-32)];
        NSLog(@"frame = %f", self.lable.frame.size.height);
        self.lable.textColor = [UIColor orangeColor];
//        self.lable.backgroundColor = [UIColor redColor];
        self.lable.layer.borderWidth = 1;
        self.lable.layer.borderColor = [UIColor orangeColor].CGColor;
        self.lable.text = @"专辑";
        self.lable.textAlignment = NSTextAlignmentCenter;
        self.lable.font = [UIFont systemFontOfSize:13];
//        self.lable.layer.masksToBounds = YES;
//        self.lable.layer.cornerRadius = 4;
        [self addSubview:self.lable];
        
        self.button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.lable.frame), 0, frame.size.width-CGRectGetMaxX(self.lable.frame)-gap, frame.size.height)];
        [self.button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        self.button.titleLabel.lineBreakMode = 1;
        self.button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.button.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:self.button];
    
    }
    return self;
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
