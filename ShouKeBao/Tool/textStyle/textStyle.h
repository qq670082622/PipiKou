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
@end
