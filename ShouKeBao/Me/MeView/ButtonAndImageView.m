//
//  ButtonAndImageView.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ButtonAndImageView.h"
#import "NSString+FKTools.h"
@implementation ButtonAndImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        CGFloat w = [self.button.titleLabel.text widthWithsysFont:15];
        self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/2, frame.size.height)];
        [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:self.button];
     
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2+5, 10, frame.size.width - frame.size.width/2-15, frame.size.height-20)];
        [self addSubview:self.imageView];
        
        
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
