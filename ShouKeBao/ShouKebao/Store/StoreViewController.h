//
//  StoreViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
#import "BeseWebView.h"
@interface StoreViewController : SKViewController
@property (nonatomic,copy) NSString *PushUrl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,assign) BOOL needOpenShare;
@end
