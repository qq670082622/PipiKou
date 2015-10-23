//
//  MeProgressView.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/6/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeProgressView.h"

@interface MeProgressView()
@property (nonatomic, strong)UILabel * progressLabel;
@property (nonatomic, strong)UIProgressView * progressView;
@property (nonatomic, strong)UIImageView * imageView;
@end

@implementation MeProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]initWithFrame:frame];
        self.imageView.image = [UIImage imageNamed:@"w4.png"];
        [self addSubview:self.imageView];
        self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2.0, [UIScreen mainScreen].bounds.size.width, 20)];
        self.progressView.transform = CGAffineTransformMakeScale(1.0f,5.0f);
        [self.progressView setProgressViewStyle:UIProgressViewStyleDefault]; //设置进度条类型
        self.progressView.progressTintColor=[UIColor yellowColor];
        [self.imageView addSubview:self.progressView];
        self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2.0 + 10, [UIScreen mainScreen].bounds.size.width , 30)];
        self.progressLabel.backgroundColor = [UIColor clearColor];
        self.progressLabel.textAlignment = NSTextAlignmentCenter;
        self.progressLabel.textColor = [UIColor redColor];
        [self.imageView addSubview:self.progressLabel];
    }
    return self;
}
+ (id)creatProgressViewWithFrame:(CGRect)frame{
    MeProgressView * progress = [[MeProgressView alloc]initWithFrame:frame];
    return progress;
}
- (void)setProgressValue:(CGFloat)progressValue{
    _progressValue = progressValue;
    self.progressView.progress = _progressValue;
    self.progressLabel.text = [NSString stringWithFormat:@"%g%@", _progressValue * 100.0,@"%"];
}
@end
