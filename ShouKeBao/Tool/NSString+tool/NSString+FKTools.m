//
//  NSString+FKTools.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/9/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NSString+FKTools.h"
@implementation NSString (FKTools)
- (BOOL)myContainsString:(NSString*)other{
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}
- (CGFloat)heigthWithsysFont:(CGFloat)font
                   withWidth:(CGFloat)width{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil];
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}
- (CGFloat)widthWithsysFont:(CGFloat)font{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil];
    CGRect rect = [self boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.width;
}


@end
