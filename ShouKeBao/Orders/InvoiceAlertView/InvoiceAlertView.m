//
//  InvoiceAlertView.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "InvoiceAlertView.h"
#import "Orders.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@implementation InvoiceAlertView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)Iknowbtn:(UIButton *)sender {

    UIView *Ikonw = [self.superview viewWithTag:107];
    UIView *backgroundgp = [self.superview viewWithTag:102];
    [backgroundgp  removeFromSuperview];
    [Ikonw removeFromSuperview];
    
    InvoiceLowView *InvoiceLow = [[[NSBundle mainBundle] loadNibNamed:@"InvoiceLowView" owner:self options:nil] lastObject];
    InvoiceLow.tag = 110;
    InvoiceLow.LowNav = self.AlertNav;
    InvoiceLow.ViewCont = self.viewCont;
    InvoiceLow.InvoiceAllBtn = YES;
    InvoiceLow.ord.InoicelowView = InvoiceLow;
    InvoiceLow.orderNumLabel.text = [NSString stringWithFormat:@"已经选择%ld张订单",InvoiceLow.ord.invoiceArr.count];
//    InvoiceLow.layer.masksToBounds = YES;
//    InvoiceLow.layer.cornerRadius = 6.0;
//    Orders *ord = [[Orders alloc] init];
//    [ord ChangeFrame];
    
    InvoiceLow.frame = CGRectMake(0,kScreenSize.height-89,kScreenSize.width ,40);
    
    [[[UIApplication sharedApplication].delegate window] addSubview:InvoiceLow];
}

@end
