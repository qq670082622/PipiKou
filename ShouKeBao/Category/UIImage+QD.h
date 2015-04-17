//
//  UIImage+QD.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QD)

+ (UIImage *)resizedImageWithName:(NSString *)name;

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

@end
