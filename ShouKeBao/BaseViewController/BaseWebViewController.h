//
//  BaseWebViewController.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/7/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
#import "YYAnimationIndicator.h"

@class BeseWebView;
@interface BaseWebViewController : SKViewController

@property(nonatomic, copy)NSString * linkUrl;
@property (nonatomic, copy)NSString * webTitle;
@property (nonatomic,strong) BeseWebView *webView;
@property (nonatomic,strong) YYAnimationIndicator *indicator;

- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
