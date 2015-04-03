//
//  SKSearchBar.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKSearchBar.h"

@implementation SKSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (UIView *searchbuttons in self.subviews)
        {
            if ([searchbuttons isKindOfClass:[UIButton class]])
            {
                UIButton *cancelButton = (UIButton*)searchbuttons;
                [cancelButton setTitle:@"搜索" forState:UIControlStateNormal];
                break;
            }
        }
    }
    return self;
}

@end
