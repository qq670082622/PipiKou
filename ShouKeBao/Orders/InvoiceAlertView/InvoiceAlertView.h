//
//  InvoiceAlertView.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceLowView.h"
@interface InvoiceAlertView : UIView
@property (nonatomic,strong) UINavigationController *AlertNav;
@property (nonatomic,strong) NSMutableArray *OrderIDs;
@property (nonatomic,strong) UIViewController *viewCont;
- (IBAction)Iknowbtn:(UIButton *)sender;

@end
