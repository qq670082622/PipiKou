//
//  MeButtonView.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeButtonViewDelegate <NSObject>

- (void)buttonViewSelectedWithIndex:(NSInteger)index;

- (void)buttonViewLongPressToCall;

@end

@interface MeButtonView : UIView

@property (nonatomic,weak) id<MeButtonViewDelegate> delegate;

@end
