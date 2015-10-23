//
//  AddViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/8/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKTableViewController.h"
#import "SKViewController.h"

@protocol AddCustomerToReferesh<NSObject>
-(void)toRefereshCustomers;
@end
@interface AddViewController : SKTableViewController

@property(weak,nonatomic) id<AddCustomerToReferesh>delegate;

@end
