//
//  QRHistoryViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
@interface QRHistoryViewController : SKViewController
@property (nonatomic,strong) NSMutableArray *dataArr;
@property(nonatomic,assign) BOOL isLogin;
@end
