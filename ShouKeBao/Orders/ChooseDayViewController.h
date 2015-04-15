//
//  ChooseDayViewController.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/14.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKTableViewController.h"
#import "DressView.h"

@protocol ChooseDayViewControllerDelegate <NSObject>

- (void)finishChoosedTimeArr:(NSMutableArray *)timeArr andType:(timeType)type;

@end

@interface ChooseDayViewController : SKTableViewController

@property (nonatomic,assign) timeType type;

@property (nonatomic,weak) id<ChooseDayViewControllerDelegate> delegate;

@end
