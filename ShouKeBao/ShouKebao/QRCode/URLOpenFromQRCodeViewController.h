//
//  URLOpenFromQRCodeViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol notifiQRCodeToRefresh<NSObject>
-(void)refresh;
@end
@interface URLOpenFromQRCodeViewController : UIViewController
@property (nonatomic,copy) NSString *url;
@property(nonatomic,weak) id<notifiQRCodeToRefresh>delegate;
@property (nonatomic, copy)NSString * titleStr;
@end
