//
//  NewVersionWebViewController.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/7/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
typedef void (^ResturnBlock)(BOOL isFromDown);
@interface NewVersionWebViewController : SKViewController

@property (copy, nonatomic)ResturnBlock block;
@property (nonatomic, strong)UIWebView * webView;
@property (nonatomic, copy)NSString * LinkUrl;
- (void)isFromBlock:(ResturnBlock)returnBlock;

@end
