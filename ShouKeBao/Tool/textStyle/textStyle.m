//
//  textStyle.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "textStyle.h"

@implementation textStyle
//设置不同字体颜色
+ (void)textStyleLabel:(UILabel *)labell text:(NSString *)text FontNumber:(CGFloat)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    
    //设置字号
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
    
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    labell.attributedText = str;
}
@end
