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
    
    UIImageView *longLine = [[UIImageView alloc]init];
    UIImageView *yuandian = [[UIImageView alloc]initWithFrame:CGRectMake(0, -4, 10, 10)];
    
    if (foureSize) {
        longLine.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/8, [UIScreen mainScreen].bounds.size.height/2+15, [UIScreen mainScreen].bounds.size.width*3/4, 2);
        luanchImage.image = [UIImage imageNamed:@"4start"];
        longLine.image = [UIImage imageNamed:@"changxian4_5"];
        yuandian.image = [UIImage imageNamed:@"yuandian4_5"];
    
    }else{
        
        longLine.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/8, [UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width*3/4, 2);
        if(fiveSize){
            luanchImage.image = [UIImage imageNamed:@"5start"];
            longLine.image = [UIImage imageNamed:@"changxian4_5"];
            yuandian.image = [UIImage imageNamed:@"yuandian4_5"];
            
        }else if (sixSize){
            luanchImage.image = [UIImage imageNamed:@"6start"];
            longLine.image = [UIImage imageNamed:@"changxian_6"];
            yuandian.image = [UIImage imageNamed:@"yuandian_6"];
            
        }else if(sixPSize){
            luanchImage.image = [UIImage imageNamed:@"6pstart"];
            longLine.image = [UIImage imageNamed:@"changxian_6p"];
            yuandian.image = [UIImage imageNamed:@"yuandian_6p"];
        }
        
    }
    
    
    luanchImage.userInteractionEnabled = YES;
    [self.window addSubview:luanchImage];
    
    [luanchImage addSubview:longLine];
    [longLine addSubview:yuandian];


    //加载动画
    [UIView animateWithDuration:2.0 animations:^{
        yuandian.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*3/4, -4, 10, 10);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            luanchImage.alpha = 0;
        } completion:^(BOOL finished) {
            [luanchImage removeFromSuperview];
        }];
    }];
    
    
    

}

- (void)value{
    
}



@end