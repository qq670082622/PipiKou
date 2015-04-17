//
//  UIImage+QD.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "UIImage+QD.h"

@implementation UIImage (QD)

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

@end
