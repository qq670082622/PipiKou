//
//  addRemondViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
@protocol ringToRefreshTheRemind<NSObject>
-(void)ringToRefreshRemind;
@end
@interface addRemondViewController : SKViewController
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,weak) id<ringToRefreshTheRemind>delegate;
@end
