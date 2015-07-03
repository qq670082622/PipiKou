//
//  ProduceDetailViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
#import "BeseWebView.h"
//@class BeseWebView;
@protocol notiQRCToStartRuning<NSObject>
-(void)notiQRCToStartRuning;
@end
@interface ProduceDetailViewController : SKViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, assign)BOOL isQRcode;
@property (copy,nonatomic) NSString *produceUrl;//
@property (copy,nonatomic) NSString *productName;
@property(nonatomic,weak) id<notiQRCToStartRuning>delegate;
@end
