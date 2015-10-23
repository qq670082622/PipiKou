//
//  SwipeView.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/9/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModal.h"
#import "NSString+FKTools.h"

//#warning 协议传值
//@protocal SwipeViewDelegate<NSObject>

@interface SwipeView : UIView

//@property (nonatomic, strong)ProductModal *model;

+ (instancetype)addSubViewLable:(UIButton *)button Model:(ProductModal *)model;
@end
