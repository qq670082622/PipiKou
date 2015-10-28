//
//  InvoiceLowView.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenInvoiceWebController.h"
#import "Orders.h"
typedef void (^ReloadLowView)();
@interface InvoiceLowView : UIView
@property (nonatomic,strong) UINavigationController *LowNav;
@property (nonatomic,strong) NSMutableArray *OrderIDsArr;
@property (nonatomic) BOOL InvoiceAllBtn;
@property (nonatomic,strong) UIViewController *ViewCont;
@property (nonatomic,strong) Orders *ord;
@property (nonatomic,strong) OpenInvoiceWebController *OpenInvoice;
@property (weak, nonatomic) IBOutlet UIButton *ChangeClickAllBtn;
@property (nonatomic,strong) ReloadLowView reloadlowView;
- (IBAction)SelectAllBtn:(UIButton *)sender;
- (IBAction)InbatchesbBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
-(void)reloadLowView:(ReloadLowView)reloadView;
@end
