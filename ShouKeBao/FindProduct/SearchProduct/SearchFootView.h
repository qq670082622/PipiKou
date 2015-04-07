//
//  SearchFootView.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/7.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchFootView;
@protocol searchFootViewDelegate <NSObject>
@optional
- (void)searchFootViewDidClickedLoadBtn:(SearchFootView *)footView;
@end

@interface SearchFootView : UIView
- (IBAction)clear:(id)sender;
+(instancetype)footView;
@property(nonatomic,weak) id<searchFootViewDelegate> delegate;
@end
