//
//  MeHeader.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeHeaderDelegate <NSObject>

- (void)didClickSetting;

- (void)didClickHeadIcon;

- (void)didClickMoreLYGW;

@end

@interface MeHeader : UIImageView
@property (weak, nonatomic) UIImageView *headIcon;
@property (weak, nonatomic)UIImageView *levelIcon;
@property (weak, nonatomic)UILabel * levelName;
@property (weak, nonatomic) UILabel *nickName;

@property (weak, nonatomic) UILabel *personType;

@property (weak, nonatomic)UILabel * positionLab;
@property (weak, nonatomic) UIButton *setBtn;
@property (weak, nonatomic)UIButton *GuWemInfo;

@property (nonatomic,assign) BOOL isPerson;

@property (nonatomic,weak) id<MeHeaderDelegate> delegate;

@end
