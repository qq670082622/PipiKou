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
+ (void)WMAnimationToMoveWithTableLayer:(CALayer *)layer andFromPiont:(CGPoint )fromPoint ToPoint:(CGPoint )toPoint;//移动
+ (void)WMAnimationToShakeWithView:(UIView *)layer andDuration:(CGFloat )duration;//震动
+ (void)WMAnimationToScaleWithLayer:(CALayer *)layer andFromValue:(id)fromValue andToValue:(id)toValue;//放大
+ (void)WMAnimationMakeBoarderWithLayer:(CALayer *)layer andBorderColor:(UIColor *)color andBorderWidth:(float)borderWid andNeedShadow:(BOOL)needShow;//给view增加边框

+ (void)WMAnimationMakeBoarderNoCornerRadiosWithLayer:(CALayer *)layer andBorderColor:(UIColor *)color andBorderWidth:(int)borderWid andNeedShadow:(BOOL)needShow;//给view增加边框

+ (void)WMAnimationMakeBoarderWithLayer:(CALayer *)layer andBorderColor:(UIColor *)color andBorderWidth:(float)borderWid andNeedShadow:(BOOL)needShow andCornerRadius:(float)radius;
+ (void)wmPaoMaDengWithView:(UIView *)view andMovePointW:(CGFloat)ponitWidth  andMidDuration:(double)duration;//跑马灯

+(void)WMChuckViewWithView:(UIView *)view fromValue:(id)fromValue toValue:(id)toValue duration:(double)duration;//闪图

+(void)WMShakeWithView:(UIView *)view;//震动

+(void)WMNewWebWithScrollView:(UIScrollView *)scroll;

+(void)WMNewTableViewCellWithCell:(UITableViewCell *)cell
                     withRightStr:(NSString *)str
                        withImage:(UIImage *)image;
@end
