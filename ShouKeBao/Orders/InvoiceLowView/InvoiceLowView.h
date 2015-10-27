//
//  InvoiceLowView.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenInvoiceWebController.h"
@interface InvoiceLowView : UIView
@property (nonatomic,strong) UINavigationController *LowNav;
@property (nonatomic,strong) NSMutableArray *OrderIDsArr;
@property (nonatomic,strong) UIViewController *ViewCont;
@property (nonatomic,strong) OpenInvoiceWebController *OpenInvoice;
- (IBAction)SelectAllBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
- (IBAction)InbatchesbBtn:(UIButton *)sender;
@end
