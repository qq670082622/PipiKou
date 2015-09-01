// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "WLRangeSlider.h"
#import "WLSliderThumbLayer.h"
#import "WLTrackLayer.h"
#import <QuartzCore/QuartzCore.h>

@interface WLRangeSlider()

@property (nonatomic,strong) WLSliderThumbLayer *leftThumbLayer;
@property (nonatomic,strong) WLSliderThumbLayer *rightThumbLayer;
@property (nonatomic,strong) WLTrackLayer *trackLayer;
@property (nonatomic) CGPoint previousLoction;
@property (nonatomic) BOOL ret;
@end

@implementation WLRangeSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayers];
    }
    return self;
}

- (void)initLayers{
    self.ret = YES;
    _maxValue = 60000;
    _minValue = 0;
    _leftValue = 0;
    _rightValue = 60000;
    _thumbColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuoyuantest"]];
    //_thumbColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hualun"]];
    _trackHighlightTintColor = [UIColor orangeColor];
    _trackColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _cornorRadiusScale = 1;
    
    _trackLayer = [WLTrackLayer layer];
    _trackLayer.contentsScale = [UIScreen mainScreen].scale;
    _trackLayer.rangeSlider = self;
    [self.layer addSublayer:_trackLayer];
    
    _leftThumbLayer = [WLSliderThumbLayer layer];
    _leftThumbLayer.contentsScale = [UIScreen mainScreen].scale;
    _leftThumbLayer.rangeSlider = self;
    [self.layer addSublayer:_leftThumbLayer];
    
    _rightThumbLayer = [WLSliderThumbLayer layer];
    _rightThumbLayer.contentsScale = [UIScreen mainScreen].scale;
    _rightThumbLayer.rangeSlider = self;
    [self.layer addSublayer:_rightThumbLayer];
    
    [self updateLayerFrames];
}

#pragma mark - Setters

- (void)setMinValue:(CGFloat)minValue{
    _minValue = minValue;
    [self updateLayerFrames];
}

- (void)setMaxValue:(CGFloat)maxValue{
    _maxValue = maxValue;
    [self updateLayerFrames];
}

- (void)setLeftValue:(CGFloat)leftValue{
    _leftValue = leftValue;
    [self updateLayerFrames];
}

- (void)setRightValue:(CGFloat)rightValue{
    _rightValue = rightValue;
    [self updateLayerFrames];
}

- (void)setThumbColor:(UIColor *)thumbColor{
    _thumbColor = thumbColor;
    [_leftThumbLayer setNeedsDisplay];
    [_rightThumbLayer setNeedsDisplay];
}

- (void)setTrackColor:(UIColor *)trackColor{
    _trackColor = trackColor;
    [_trackLayer setNeedsDisplay];
}

- (void)setTrackHighlightTintColor:(UIColor *)trackHighlightTintColor{
    _trackHighlightTintColor = trackHighlightTintColor;
    [_trackLayer setNeedsDisplay];
}

- (void)setCornorRadiusScale:(CGFloat)cornorRadiusScale{
    _cornorRadiusScale = cornorRadiusScale;
    [_leftThumbLayer setNeedsDisplay];
    [_rightThumbLayer setNeedsDisplay];
    [_trackLayer setNeedsDisplay];
}

#pragma mark - Utils Methods
- (CGFloat)thumbWidth{
    return CGRectGetHeight(self.bounds);
}

- (void)updateLayerFrames{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
   
    CGFloat leftThumbCenter = [self positionForValue:_leftValue];
    CGFloat rightThumbCenter = [self positionForValue:_rightValue];
        _leftThumbLayer.frame = CGRectMake(leftThumbCenter - [self thumbWidth] / 2.0, 0.0, [self thumbWidth], [self thumbWidth]);
        _rightThumbLayer.frame = CGRectMake(rightThumbCenter - [self thumbWidth] / 2.0, 0.0, [self thumbWidth], [self thumbWidth]);
        _trackLayer.frame = CGRectInset(self.bounds, 2, [self thumbWidth]/3+4);
     [_trackLayer setNeedsDisplay];
    [_leftThumbLayer setNeedsDisplay];
    [_rightThumbLayer setNeedsDisplay];
    [CATransaction commit];
}

- (CGFloat)positionForValue:(CGFloat)value{
    return (CGRectGetWidth(self.bounds) - [self thumbWidth]) * (value - _minValue) / (_maxValue - _minValue) + [self thumbWidth] / 2.0;
}

- (CGFloat)boundaryForValue:(CGFloat)value minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue{
    return MIN(MAX(value, minValue), maxValue);
}

#pragma mark - Override Methods
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    _previousLoction = [touch locationInView:self];
    
    if (CGRectContainsPoint(_leftThumbLayer.frame, _previousLoction)) {
        _leftThumbLayer.highlighted = YES;
    }else if(CGRectContainsPoint(_rightThumbLayer.frame, _previousLoction)){
        _rightThumbLayer.highlighted = YES;
    }
    return _rightThumbLayer.highlighted || _leftThumbLayer.highlighted;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint point = [touch locationInView:self];
    CGFloat deltaX = point.x - _previousLoction.x;
    CGFloat deltaValue = (_maxValue - _minValue) * deltaX / (CGRectGetWidth(self.bounds) - [self thumbWidth]);
    _previousLoction = point;
    if (_leftThumbLayer.highlighted) {
        self.leftValue += deltaValue;
        self.leftValue = [self boundaryForValue:_leftValue minValue:_minValue maxValue:_rightValue];
    }else if (_rightThumbLayer.highlighted){
        self.rightValue += deltaValue;
        self.rightValue = [self boundaryForValue:_rightValue minValue:_leftValue maxValue:_maxValue];
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    _leftThumbLayer.highlighted = NO;
    _rightThumbLayer.highlighted = NO;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event{
    _leftThumbLayer.highlighted = NO;
    _rightThumbLayer.highlighted = NO;
}

@end
