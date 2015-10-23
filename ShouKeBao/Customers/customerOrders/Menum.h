//
//  Menum.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/8/11.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArrowBtn;

@protocol menumDelegate <NSObject>

- (void)menumLiftButton:(UIButton *)LiftButton;
- (void)menumRightButton:(UIButton *)rightButton;


@end


@interface Menum : UIView

@property (nonatomic, weak)ArrowBtn *leftButton;
@property (nonatomic, weak)ArrowBtn *reghtButton;

@property (nonatomic, weak)id <menumDelegate>dalegate;

@end
