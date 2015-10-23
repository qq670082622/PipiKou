//
//  OrderDetailViewController.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKTableViewController.h"

@class OrderModel;

@interface OrderDetailViewController : SKTableViewController

@property (nonatomic,copy) NSString *url;
@property (nonatomic, strong)NSDictionary * userInfoDic;
- (void)postCustomerToServer:(NSArray * )customerIDs;
@end
