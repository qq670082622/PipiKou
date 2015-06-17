//
//  WelcomeViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "WelcomeView.h"
#import "WelcomePageControl.h"

#define WelcomeImageCount 5

// 2.获得RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 4.不同屏幕尺寸
#define foureSize ([UIScreen mainScreen].bounds.size.height == 480)
#define fiveSize ([UIScreen mainScreen].bounds.size.height == 568)
#define sixSize ([UIScreen mainScreen].bounds.size.height > 667)

@interface WelcomeView() <UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic,weak) UIScrollView *scrollView;

@end

@implementation WelcomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.添加UISrollView
        [self setupScrollView];
        
        // 2.添加pageControl
        [self setupPageControl];
        
        self.backgroundColor = [UIColor whiteColor];
        
        NSLog(@"---- chichun  %f",[UIScreen mainScreen].bounds.size.height);
    }
    return self;
}

/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = WelcomeImageCount;
    CGFloat centerX = self.frame.size.width * 0.5;
    CGFloat centerY = self.frame.size.height - 30;
    pageControl.center = CGPointMake(centerX, centerY);
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    pageControl.userInteractionEnabled = NO;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = IWColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = IWColor(189, 189, 189);
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.bounds;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    for (int index = 0; index < WelcomeImageCount; index++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 设置图片
        NSString *name4 = [NSString stringWithFormat:@"w%d-4s", index];
        NSString *name5 = [NSString stringWithFormat:@"w%d-5s",index];
        NSString *name6 = [NSString stringWithFormat:@"w%d",index];
        
        if (foureSize) {
            imageView.image = [UIImage imageNamed:name4];
        }else if(fiveSize){
            imageView.image = [UIImage imageNamed:name5];
        }else{
            imageView.image = [UIImage imageNamed:name6];
        }
        
        // 设置frame
        CGFloat imageX = index * imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        
        [scrollView addSubview:imageView];
        
        // 在最后一个图片上面添加按钮
        if (index == WelcomeImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置滚动的内容尺寸
    scrollView.contentSize = CGSizeMake(imageW * WelcomeImageCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
}

/**
 *  添加内容到最后一个图片
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    // 0.让imageView能跟用户交互
    imageView.userInteractionEnabled = YES;
    
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    [startButton setBackgroundImage:[UIImage imageNamed:@"welcome_finish_button"] forState:UIControlStateNormal];
//    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    
    // 2.设置frame
    CGFloat centerX = imageView.frame.size.width * 0.5;
    CGFloat centerY = imageView.frame.size.height * 0.85;
    startButton.center = CGPointMake(centerX, centerY);
    startButton.bounds = (CGRect){CGPointZero, 160,48};
    
    // 3.设置文字
    [startButton setTitle:@"进入旅游圈" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startButton];
}

/**
 *  开始旅游圈
 */
- (void)start
{
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)checkboxClick:(UIButton *)checkbox
{
    checkbox.selected = !checkbox.isSelected;
}

#pragma mark - scrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 2.求出页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;
}

@end
