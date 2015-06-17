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
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, -70, [[UIScreen mainScreen] bounds].size.width, 30)];
        lab.text = @"网页由 www.lvyouquan.cn 提供";
        lab.textColor = [UIColor lightGrayColor];
        lab.font = [UIFont systemFontOfSize:12];
        lab.textAlignment = NSTextAlignmentCenter;
        self.scrollView.backgroundColor = [UIColor colorWithRed:45/255.f green:49/255.f blue:48/255.f alpha:1];
        [self.scrollView addSubview:lab];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, -70, [[UIScreen mainScreen] bounds].size.width, 30)];
        lab.text = @"网页由 www.lvyouquan.cn 提供";
        lab.textColor = [UIColor lightGrayColor];
        lab.font = [UIFont systemFontOfSize:12];
        lab.textAlignment = NSTextAlignmentCenter;
        self.scrollView.backgroundColor = [UIColor colorWithRed:45/255.f green:49/255.f blue:48/255.f alpha:1];
        [self.scrollView addSubview:lab];
        
    }
    return self;
}

-(void)goBackPageNum:(NSInteger)pageNum{
    for (int i = 0 ; i < self.pageCount - 2; i++) {
        [self goBack];
    }
}
@end
