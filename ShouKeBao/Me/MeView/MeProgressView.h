//
//  MeProgressView.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/6/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeProgressView : UIView

@property (nonatomic, assign)CGFloat progressValue;
+ (id)creatProgressViewWithFrame:(CGRect)frame;
@end
