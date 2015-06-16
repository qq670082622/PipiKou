//
//  BeseWebView.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/6/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BeseWebView.h"

@implementation BeseWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, -80, [UIScreen mainScreen].bounds.size.width, 70)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"网页由 www.lvyouquan.cn 提供";
        //53  161 191
        self.scrollView.backgroundColor = [UIColor colorWithRed:53/ 255.0 green:161 / 255.0 blue:191 / 255.0 alpha:1.0];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor grayColor];
        [self.scrollView addSubview:label];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, -80, [UIScreen mainScreen].bounds.size.width, 70)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"网页由 www.lvyouquan.cn 提供";
        //53  161 191
        self.scrollView.backgroundColor = [UIColor colorWithRed:53/ 255.0 green:161 / 255.0 blue:191 / 255.0 alpha:1.0];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor grayColor];
        [self.scrollView addSubview:label];
    }
    return self;
}


@end
