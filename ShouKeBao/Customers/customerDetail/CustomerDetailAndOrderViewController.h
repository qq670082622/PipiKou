//
//  CustomerDetailAndOrderViewController.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/7.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
@class CustomModel;
@class Customers;
@interface CustomerDetailAndOrderViewController : SKViewController
@property (nonatomic, strong)Customers * customVC;
@property (nonatomic, copy  )NSString * keyWords;
//@property (nonatomic, strong)CustomModel * model;
@property (nonatomic, copy)NSString *customerID;
@property (nonatomic, copy)NSString *appUserID;

@end
