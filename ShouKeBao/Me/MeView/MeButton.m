//
//  MeButton.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeButton.h"

@implementation MeButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat X = (contentRect.size.width - 20) * 0.5;
    return CGRectMake(X, 10, 20, 20);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 35, contentRect.size.width, 20);
}

@end
