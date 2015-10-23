//
//  NSString+QD.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/1.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NSString+QD.h"

@implementation NSString (QD)

+ (CGSize)textSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (NSString *)pinYin

{
    
    //方式一
    
    //先转换为带声调的拼音
    
    NSMutableString *str = [self mutableCopy];
    
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    
    //再转换为不带声调的拼音
    
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    
    return str;
    
    //方式二 (简单明了,易于使用,一行代码 方便他人)
    
//     return [ChineseToPinyin pinyinFromChiniseString:self];
    
}

//补充:

//获取拼音首字母

- (NSString *)firstCharactor

{
    
    //1.先传化为拼音
    
    NSString *pinYin = [self pinYin];
    
    //2.获取首字母
    
    return [pinYin substringToIndex:1];
    
}
@end
