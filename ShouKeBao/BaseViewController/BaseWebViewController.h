//
//  BaseWebViewController.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/7/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
@class BeseWebView;
@interface BaseWebViewController : SKViewController

@property(nonatomic, copy)NSString * linkUrl;
@property (nonatomic, copy)NSString * webTitle;
@property (nonatomic,strong) BeseWebView *webView;



@end
