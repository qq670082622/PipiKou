//
//  UIColor+SK.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "UIColor+SK.h"

@implementation UIColor (SK)

/*
 1 灰色 2蓝色 3橙色 4绿色 5红色 6紫色
 */
+ (UIColor *)configureColorWithNum:(NSInteger)num
{
    switch (num) {
        case 1:
            return [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
            break;
        case 2:
            return [UIColor colorWithRed:21/255.0 green:105/255.0 blue:254/255.0 alpha:1];
            break;
        case 3:
            return [UIColor colorWithRed:253/255.0 green:129/255.0 blue:8/255.0 alpha:1];
            break;
        case 4:
            return [UIColor colorWithRed:55/255.0 green:1 blue:7/255.0 alpha:1];
            break;
        case 5:
            return [UIColor colorWithRed:251/255.0 green:0/255.0 blue:6/255.0 alpha:1];
            break;
        case 6:
            return [UIColor purpleColor];
            break;
        default:
            return [UIColor grayColor];
            break;
    }
}

@end
