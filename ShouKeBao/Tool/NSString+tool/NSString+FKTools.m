//
//  NSString+FKTools.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/9/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NSString+FKTools.h"
#import "CommandTo.h"
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
+(void)showbackgroundgray{
    //半透明背景
    UIView *backgroundGray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundGray.backgroundColor = [UIColor blackColor];
    backgroundGray.alpha = 0.5;
    backgroundGray.tag = 102;
    [[[UIApplication sharedApplication].delegate window] addSubview:backgroundGray];

}
+(void)showcommendToDetailbody:(NSString *)body Di:(NSString *)Di song:(NSString *)song retailsales:(NSString *)retailsalesLabel Nav:(UINavigationController *)nav{
    CommandTo *commandto = [[[NSBundle mainBundle] loadNibNamed:@"CommandTo" owner:self options:nil] lastObject];
    commandto.NAV = nav;
    NSLog(@"%@", commandto.NAV);
    commandto.backgroundView.layer.cornerRadius = 4;
    commandto.backgroundView.layer.masksToBounds = YES;
    
    commandto.tag = 101;
    commandto.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height/4,[UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height/2);
    
    commandto.bodyLabel.text = body;
    commandto.DiLabel.text = @"500";
    commandto.SongLabel.text = @"500";
    commandto.retailsalesLabel.text = @"1234门市";
    
    [[[UIApplication sharedApplication].delegate window] addSubview:commandto];
}

@end
