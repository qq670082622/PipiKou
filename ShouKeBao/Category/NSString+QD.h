//
//  NSString+QD.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/1.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (QD)

+ (CGSize)textSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
- (NSString *)pinYin;
- (NSString *)firstCharactor;

@end
