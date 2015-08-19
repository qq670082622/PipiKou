//
//  addCustomerViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
@protocol addCustomerToReferesh<NSObject>
-(void)toRefereshCustomers;
@end
@interface addCustomerViewController : SKViewController
@property(weak,nonatomic) id<addCustomerToReferesh>delegate;



@end
