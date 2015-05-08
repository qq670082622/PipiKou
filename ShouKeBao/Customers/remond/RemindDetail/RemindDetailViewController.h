//
//  RemindDetailViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/1.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"

@protocol remindDetailDelegate <NSObject>

- (void)didLookUpRemind;

@end

@interface RemindDetailViewController : SKViewController
@property (nonatomic,copy)NSString *note;
@property (nonatomic,copy)NSString *time;

@property (nonatomic,copy) NSString *remindId;

@property (nonatomic,weak) id<remindDetailDelegate> delegate;

@end
