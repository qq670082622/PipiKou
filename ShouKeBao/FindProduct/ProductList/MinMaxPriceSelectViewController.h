//
//  MinMaxPriceSelectViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/2.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol passThePrice<NSObject>
-(void)passTheMinPrice:(NSString *)min AndMaxPrice:(NSString *)max;
@end
@interface MinMaxPriceSelectViewController : UIViewController
@property(nonatomic,weak) id<passThePrice>delegate;
@end
