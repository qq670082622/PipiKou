//
//  Me.h
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTableViewController.h"
#import <StoreKit/StoreKit.h>
@interface Me : SKTableViewController<SKStoreProductViewControllerDelegate>
@property (nonatomic) NSInteger isPush;
@end
