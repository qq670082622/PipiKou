//
//  textStyle.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface textStyle : NSObject
+(void)textStyleLabel:(UILabel *)labell text:(NSString *)text FontNumber:(CGFloat)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;

//lable/字符串/文字大小/文字整个范围/有背景范围/有背景文字颜色/背景颜色/无背景范围/无背景文字颜色
+(void)textStyleLabel:(UILabel *)label text:(NSString *)text FontNumber:(CGFloat)font Range:(NSRange)range AndHaveRange:(NSRange)haveRange AndHaveColor:(UIColor *)haveVaColor  BackGroundColor:(UIColor *)backGroundColor AndNoHaveRange:(NSRange)noHaveRange AndnoHaveBackGroundColor:(UIColor *)noHaveBackGroundColor;

//lable/字符串/文字大小/文字整个范围/有边框的范围/有边框的字的颜色/边框的颜色/无边框文字的范围／无边框文字的颜色
+(void)textStyleLabel:(UILabel *)label text:(NSString *)text FontNumber:(CGFloat)font AndRange:(NSRange)range AndHaveRange:(NSRange)haveRange AndHaveWordColor:(UIColor *)HWordColor BianColor:(UIColor *)bianColor noRange:(NSRange)noRange noColor:(UIColor *)noColor;


@end
