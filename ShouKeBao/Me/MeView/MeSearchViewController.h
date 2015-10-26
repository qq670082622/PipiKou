//
//  MeSearchViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
//协议传值
@protocol transmitPopKeyWords <NSObject>
- (void)transmitPopKeyWord:(NSString *)keyWords;
@end


@interface MeSearchViewController : SKViewController
@property(nonatomic, weak)id<transmitPopKeyWords>transmitDelegate;
@end
