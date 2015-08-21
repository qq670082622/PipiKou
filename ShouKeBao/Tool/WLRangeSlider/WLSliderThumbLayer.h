// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <QuartzCore/QuartzCore.h>

@class WLRangeSlider;
@interface WLSliderThumbLayer : CALayer

//whether highlighted
@property (nonatomic) BOOL highlighted;
//weak to avoid retain cycle
@property (nonatomic,weak) WLRangeSlider *rangeSlider;

@end
