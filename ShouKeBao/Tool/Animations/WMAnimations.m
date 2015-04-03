//
//  WMAnimations.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/2.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "WMAnimations.h"

@implementation WMAnimations
+ (void)WMAnimationToMoveWithTableLayer:(CALayer *)layer andFromPiont:(CGPoint *)fromPoint ToPoint:(CGPoint *)toPoint
{
     CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    
theAnimation.fromValue=[NSValue valueWithCGPoint:*fromPoint];
    theAnimation.toValue=[NSValue valueWithCGPoint:*toPoint];
    
    
    theAnimation.duration=0.8;
    
    
    theAnimation.autoreverses = NO;
    [layer addAnimation:theAnimation forKey:@"move"];
}

+ (void)WMAnimationToShakeWithView:(UIView *)view andDuration:(CGFloat )duration{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    // set the fromValue and toValue to the appropriate points
    
    theAnimation.fromValue=[NSValue valueWithCGPoint:CGPointMake(view.center.x-5,view.center.y)];
    
    theAnimation.toValue=[NSValue valueWithCGPoint:CGPointMake(view.center.y+5,view.center.y)];
    
    // set the duration to 3.0 seconds
    
    theAnimation.duration=duration;//duration一半越小震动越明显，建议duration = 0.05
    
    theAnimation.repeatCount = 10;
    
    // set a custom timing function
    
    //theAnimation.timingFunction=[CAMediaTimingFunction functionWithControlPoints:0.25f :0.1f :0.25f :1.0f];
    
    theAnimation.autoreverses = YES;
    
    [view.layer addAnimation:theAnimation forKey:@"move"];
    
}

+ (void)WMAnimationToScaleWithLayer:(CALayer *)layer andFromValue:(CGFloat)fromValue andToValue:(CGFloat)toValue{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    animation.duration = 0.2;
    animation.repeatCount = 1;
    //animation.autoreverses = YES;//是否变回原来的属性
    [layer addAnimation:animation forKey:@"scale"];

}

+ (void)WMAnimationMakeBoarderWithLayer:(CALayer *)layer andBorderColor:(UIColor *)color andBorderWidth:(int)borderWid andNeedShadow:(BOOL)needShow
{
    layer.borderColor = color.CGColor;
    layer.borderWidth = borderWid;
    layer.cornerRadius = 8;
    layer.masksToBounds = YES;
    if (needShow) {
        layer.shadowColor = [UIColor lightGrayColor].CGColor;
        layer.shadowOpacity = 0.5;
        layer.shadowOffset = CGSizeMake(2, 2);

    }
    
    
    
   
}
@end
