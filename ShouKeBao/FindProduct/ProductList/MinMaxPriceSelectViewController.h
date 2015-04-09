//
//  MinMaxPriceSelectViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/2.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
@protocol passThePrice<NSObject>
-(void)passTheMinPrice:(NSString *)min AndMaxPrice:(NSString *)max;
@end
@interface MinMaxPriceSelectViewController : SKViewController
@property(nonatomic,weak) id<passThePrice>delegate;
@end
