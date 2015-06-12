//
//  BeseWebView.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/6/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BeseWebView.h"

@implementation BeseWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (NSString *)changeUserAgent{
    BOOL shutDownUserAgent = YES;
    NSString *oldAgent = [self stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *package = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *ext = [[package componentsSeparatedByString:@"."] lastObject];
    NSString *myAgent = [NSString stringWithFormat:@" %@/%@", ext, version];
    return myAgent;
}
@end
