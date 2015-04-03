//
//  WMAnimations.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/2.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WMAnimations : NSObject
+ (void)WMAnimationToMoveWithTableLayer:(CALayer *)layer andFromPiont:(CGPoint *)fromPoint ToPoint:(CGPoint *)toPoint;//移动
+ (void)WMAnimationToShakeWithView:(UIView *)layer andDuration:(CGFloat )duration;//震动
+ (void)WMAnimationToScaleWithLayer:(CALayer *)layer andFromValue:(CGFloat)fromValue andToValue:(CGFloat)toValue;//放大
+ (void)WMAnimationMakeBoarderWithLayer:(CALayer *)layer andBorderColor:(UIColor *)color andBorderWidth:(int)borderWid andNeedShadow:(BOOL)needShow;//给view增加边框
@end
