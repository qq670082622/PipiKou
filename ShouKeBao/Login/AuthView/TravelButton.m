//
//  TravelButton.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/7.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "TravelButton.h"

@implementation TravelButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(5, 5, 70, contentRect.size.height - 10);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = CGRectGetMaxX(self.imageView.frame) + 5;
    return CGRectMake(x, 5, contentRect.size.width - 70 - 15, 20);
}

//- (void)setHighlighted:(BOOL)highlighted
//{
//    
//}

@end
