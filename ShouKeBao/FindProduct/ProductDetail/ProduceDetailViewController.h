//
//  ProduceDetailViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProduceDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (copy,nonatomic) NSString *produceUrl;//
@property (copy,nonatomic) NSString *productName;
@end
