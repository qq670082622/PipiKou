//
//  MenuButton.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/9.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuButtonDelegate <NSObject>

- (void)menuDidSelectLeftBtn:(UIButton *)leftBtn;

- (void)menuDidSelectRightBtn:(UIButton *)RightBtn;

@end

@interface MenuButton : UIView

@property (nonatomic,weak) UIButton *leftBtn;

@property (nonatomic,weak) UIButton *rightBtn;

@property (nonatomic,weak) id<MenuButtonDelegate> delegate;

@end
