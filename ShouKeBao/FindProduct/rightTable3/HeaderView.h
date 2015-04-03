//
//  HeaderView.h
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeaderView;
@protocol headerViewDelegate <NSObject>
@optional
- (void)headerViewDidClickedLoadBtn:(HeaderView *)headerView;


@end
@interface HeaderView : UIView
- (IBAction)btn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn;
+(instancetype)headerView;
@property(nonatomic,weak) id<headerViewDelegate> delegate;
@end
