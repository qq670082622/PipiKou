//
//  WMAnimations.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/2.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "WMAnimations.h"
#define K_ScreenWidth [UIScreen mainScreen].bounds.size.width
@implementation WMAnimations
+ (void)WMAnimationToMoveWithTableLayer:(CALayer *)layer andFromPiont:(CGPoint )fromPoint ToPoint:(CGPoint )toPoint
{
     CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    theAnimation.fromValue=[NSValue valueWithCGPoint:fromPoint];
    theAnimation.toValue=[NSValue valueWithCGPoint:toPoint];
    
    
    theAnimation.duration=0.2;
    
    
    //theAnimation.autoreverses = YES;
    theAnimation.removedOnCompletion = NO;
    theAnimation.fillMode = kCAFillModeForwards;
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

+ (void)WMAnimationToScaleWithLayer:(CALayer *)layer andFromValue:(id)fromValue andToValue:(id)toValue{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = 0.01f;
    animation.repeatCount = 1;
    //animation.autoreverses = YES;//是否变回原来的属性
    [layer addAnimation:animation forKey:@"scale"];

}

+ (void)WMAnimationMakeBoarderWithLayer:(CALayer *)layer andBorderColor:(UIColor *)color andBorderWidth:(float)borderWid andNeedShadow:(BOOL)needShow
{
    layer.borderColor = color.CGColor;
    layer.borderWidth = borderWid;
    layer.cornerRadius = 4;
    layer.masksToBounds = YES;
    //将绘制的圆角缓存， 避免影响屏幕帧数；
//    layer.shouldRasterize = YES;
//    layer.rasterizationScale = [UIScreen mainScreen].scale;

    if (needShow) {
        layer.shadowColor = [UIColor lightGrayColor].CGColor;
        layer.shadowOpacity = 0.5;
        layer.shadowOffset = CGSizeMake(2, 2);

    }
    
    }
+ (void)WMAnimationMakeBoarderWithLayer:(CALayer *)layer andBorderColor:(UIColor *)color andBorderWidth:(float)borderWid andNeedShadow:(BOOL)needShow andCornerRadius:(float)radius
{
    layer.borderColor = color.CGColor;
    layer.borderWidth = borderWid;
    layer.cornerRadius = radius;
    layer.masksToBounds = YES;
    //将绘制的圆角缓存， 避免影响屏幕帧数；
//    layer.shouldRasterize = YES;
//    layer.rasterizationScale = [UIScreen mainScreen].scale;
    if (needShow) {
        layer.shadowColor = [UIColor lightGrayColor].CGColor;
        layer.shadowOpacity = 0.5;
        layer.shadowOffset = CGSizeMake(2, 2);
        
    }
    
}

+ (void)WMAnimationMakeBoarderNoCornerRadiosWithLayer:(CALayer *)layer andBorderColor:(UIColor *)color andBorderWidth:(int)borderWid andNeedShadow:(BOOL)needShow//给view增加边框
{
    layer.borderColor = color.CGColor;
    layer.borderWidth = borderWid;
   layer.masksToBounds = YES;
    //将绘制的圆角缓存， 避免影响屏幕帧数；
//    layer.shouldRasterize = YES;
//    layer.rasterizationScale = [UIScreen mainScreen].scale;

    if (needShow) {
        layer.shadowColor = [UIColor lightGrayColor].CGColor;
        layer.shadowOpacity = 0.5;
        layer.shadowOffset = CGSizeMake(2, 2);
        
    }


}

+ (void)wmPaoMaDengWithView:(UIView *)view andMovePointW:(CGFloat)ponitWidth  andMidDuration:(double)duration
{//view:在哪个图片上转，移动点的宽，一个动画的持续时间，（默认创建80个移动点）
    
    CGFloat viewW = view.frame.size.width;
    CGFloat viewH = view.frame.size.height;
    
    CAKeyframeAnimation *an = [CAKeyframeAnimation animation];//绕指定路径走
    an.keyPath = @"position";
    NSValue *v = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    NSValue *v1 = [NSValue valueWithCGPoint:CGPointMake(viewW - ponitWidth, 0)];
    NSValue *v2 = [NSValue valueWithCGPoint:CGPointMake(viewW - ponitWidth,viewH - ponitWidth)];
    NSValue *v3 = [NSValue valueWithCGPoint:CGPointMake(0,viewH - ponitWidth)];
    NSValue *v4 = [NSValue valueWithCGPoint:CGPointMake(0,0)];
    an.values = @[v,v1,v2,v3,v4];//动画值的数组
    //an.duration = duration;
    an.repeatCount = MAXFLOAT;
    
    for (int i = 0; i<80; i++) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ponitWidth, ponitWidth)];
        view1.backgroundColor = [UIColor colorWithRed:((arc4random() % 250) + 1)/250.f green:((arc4random() % 250) + 1)/250.f blue:((arc4random() % 250) + 1)/250.f alpha:1];
        
        view1.layer.anchorPoint = CGPointZero;
        view1.layer.cornerRadius = ponitWidth;
        view1.layer.masksToBounds = YES;
        an.duration =duration+i*0.1;
        
               [view1.layer addAnimation:an forKey:nil];
        
        [view addSubview:view1];
        
    }
    
}

+(void)WMChuckViewWithView:(UIView *)view fromValue:(id)fromValue toValue:(id)toValue duration:(double)duration
{
    // toValue is @0.8f
    
    //animation 闪图
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = duration;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = NO;//是否变回原来的属性
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(7, 7);
    view.layer.shadowOpacity = 0.7;
    [view.layer addAnimation:animation forKey:@"scale"];
    
    
}

//震动
+(void)WMShakeWithView:(UIView *)view
{
    CABasicAnimation *theAnimation;
    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    
    // set the fromValue and toValue to the appropriate points
    CGFloat shakeWid = view.center.x;
    CGFloat shakeheit = view.center.y;
    
    theAnimation.fromValue=[NSValue valueWithCGPoint:CGPointMake(shakeWid-5,shakeheit)];
    theAnimation.toValue=[NSValue valueWithCGPoint:CGPointMake(shakeWid+5,shakeheit)];
    
    // set the duration to 3.0 seconds
    theAnimation.duration=0.05;
    theAnimation.repeatCount = MAXFLOAT;
    
    // set a custom timing function
    //theAnimation.timingFunction=[CAMediaTimingFunction functionWithControlPoints:0.25f :0.1f :0.25f :1.0f];
    theAnimation.autoreverses = YES;
    [view.layer addAnimation:theAnimation forKey:@"move"];
    
}

+(void)WMNewWebWithScrollView:(UIScrollView *)scroll
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, -70, [[UIScreen mainScreen] bounds].size.width, 30)];
    lab.text = @"网页由 www.lvyouquan.cn 提供";
    lab.textColor = [UIColor lightGrayColor];
    lab.font = [UIFont systemFontOfSize:12];
    lab.textAlignment = NSTextAlignmentCenter;
   scroll.backgroundColor = [UIColor colorWithRed:45/255.f green:49/255.f blue:48/255.f alpha:1];
    
    [scroll addSubview:lab];
    

}
+(void)WMNewTableViewCellWithCell:(UITableViewCell *)cell
                     withRightStr:(NSString *)str
                        withImage:(UIImage *)image;
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(K_ScreenWidth - 130, 5, 95, 40)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentRight;
    label.text = str;
    [cell.contentView addSubview:label];
    if (image) {
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(86, 12.5, 55, 23)];
        imgView.image = image;
        [cell.contentView addSubview:imgView];
    }
    
}

@end
