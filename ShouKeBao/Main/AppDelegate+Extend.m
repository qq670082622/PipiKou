//
//  AppDelegate+Extend.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/13.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "AppDelegate+Extend.h"
#define foureSize ([UIScreen mainScreen].bounds.size.height == 480)
#define fiveSize ([UIScreen mainScreen].bounds.size.height == 568)
#define sixSize ([UIScreen mainScreen].bounds.size.height == 667)
#define sixPSize ([UIScreen mainScreen].bounds.size.height > 668)


@implementation AppDelegate (Extend)

-(void)setStartAnamation{
    UIImageView * luanchImage = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    if (foureSize) {
        luanchImage.image = [UIImage imageNamed:@"4start"];
    }else if(fiveSize){
        luanchImage.image = [UIImage imageNamed:@"5start"];
    }else if (sixSize){
        luanchImage.image = [UIImage imageNamed:@"6start"];
    }else if(sixPSize){
        luanchImage.image = [UIImage imageNamed:@"6pstart"];
    }
    luanchImage.userInteractionEnabled = YES;
    [self.window addSubview:luanchImage];
    
    //加载动画
    [UIView animateWithDuration:5.0 animations:^{
        luanchImage.alpha = 0;
    } completion:^(BOOL finished) {
        [luanchImage removeFromSuperview];
    }];

}


@end
