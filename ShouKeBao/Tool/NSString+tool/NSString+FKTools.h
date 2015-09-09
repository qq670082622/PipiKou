//
//  NSString+FKTools.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/9/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (FKTools)
//为适应iOS7写的一个是否包含某字符的方法
- (BOOL)myContainsString:(NSString*)other;

//根据宽度确定字符串的高度
- (CGFloat)heigthWithsysFont:(CGFloat)font
                   withWidth:(CGFloat)width;
//一行字体的宽度
- (CGFloat)widthWithsysFont:(CGFloat)font;
@end
