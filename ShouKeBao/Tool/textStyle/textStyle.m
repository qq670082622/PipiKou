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
    NSLog(@"color = %@ ", vaColor);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    
    //设置字号
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
    
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    labell.attributedText = str;
}

//lable/字符串/文字大小/文字整个范围/有背景范围/有背景文字颜色/背景颜色/无背景范围/无背景文字颜色
+(void)textStyleLabel:(UILabel *)label text:(NSString *)text FontNumber:(CGFloat)font Range:(NSRange)range AndHaveRange:(NSRange)haveRange AndHaveColor:(UIColor *)haveVaColor BackGroundColor:(UIColor *)backGroundColor AndNoHaveRange:(NSRange)noHaveRange AndnoHaveBackGroundColor:(UIColor *)noHaveBackGroundColor{
    //    NSLog(@"haveVaColor = %@, str = %@, text = %f, range = %f, noRange = %f, haveB = %f, clolor = %@",haveVaColor, text, font, range, noHaveRange, haveRange, backGroundColor);
    
    //    初始化字符串
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    //设置字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:range];
    
    //设置有背景的文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:haveVaColor range:haveRange];
    //    设置文字背景的颜色
    [str addAttribute:NSBackgroundColorAttributeName value:backGroundColor range:haveRange];
    
    //设置无背景文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:noHaveBackGroundColor range:noHaveRange];
    
    label.attributedText = str;
    
}

//lable/字符串/文字大小/文字整个范围/有边框的范围/有边框的字的颜色/边框的颜色/无边框文字的范围／无边框文字的颜色
+(void)textStyleLabel:(UILabel *)label text:(NSString *)text FontNumber:(CGFloat)font AndRange:(NSRange)range AndHaveRange:(NSRange)haveRange AndHaveWordColor:(UIColor *)HWordColor BianColor:(UIColor *)bianColor noRange:(NSRange)noRange noColor:(UIColor *)noColor{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    //    设置文字的大小
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
    
    //设置边框颜色
    [str addAttribute:NSForegroundColorAttributeName value:bianColor range:haveRange];
    //设置有边框的文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:HWordColor range:haveRange];
    //    设置无边框文字的颜色
    [str addAttribute:NSForegroundColorAttributeName value:noColor range:noRange];
    
    label.attributedText = str;
    
}
@end
