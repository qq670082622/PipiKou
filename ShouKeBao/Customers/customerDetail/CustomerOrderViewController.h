//
//  CustomerOrderViewController.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/6.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKTableViewController.h"
#import "SKViewController.h"
@interface CustomerOrderViewController : SKViewController
@property (nonatomic, copy)NSString *customerId;
@property (nonatomic, strong)UINavigationController * mainNav;
@end
