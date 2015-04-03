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

@end

@interface MeHeader : UIImageView
@property (weak, nonatomic) UIButton *headIcon;

@property (weak, nonatomic) UILabel *nickName;

@property (weak, nonatomic) UILabel *personType;

@property (weak, nonatomic) UIButton *setBtn;

@property (nonatomic,weak) id<MeHeaderDelegate> delegate;

@end
