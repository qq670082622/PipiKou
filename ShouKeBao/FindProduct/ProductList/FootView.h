//
//  FootView.h
//  CustomTableView
//
//  Created by David on 15/1/29.
//  Copyright (c) 2015年 Wm. All rights reserved.
//
//fileOwner无需修改，只需修改view或者viewcontroller的身份类
#import <UIKit/UIKit.h>
@class FootView;
@protocol footViewDelegate <NSObject>
@optional
- (void)footViewDidClickedLoadBtn:(FootView *)footView;


@end
@interface FootView : UIView
- (IBAction)btn:(id)sender;
+(instancetype)footView;
@property(nonatomic,weak) id<footViewDelegate> delegate;
@end
