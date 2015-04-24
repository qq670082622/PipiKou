//
//  AddRemindViewController.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKTableViewController.h"

@protocol AddRemindViewControllerDelegate<NSObject>

-(void)ringToRefreshRemind;

@end

@interface AddRemindViewController : SKTableViewController

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,weak) id<AddRemindViewControllerDelegate> delegate;

@end
