//
//  InvoiceLowView.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "InvoiceLowView.h"
#import "OpenInvoiceViewController.h"
@implementation InvoiceLowView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (IBAction)SelectAllBtn:(UIButton *)sender {

}
- (IBAction)InbatchesbBtn:(UIButton *)sender {
//    UIAlertView *showshow = [[UIAlertView alloc] initWithTitle:@"不知道往哪跳" message:@"666" delegate:self cancelButtonTitle:@"回去吧" otherButtonTitles:@"不回去", nil];
//    [showshow show];

    OpenInvoiceViewController *OpenInvoice = [[OpenInvoiceViewController alloc] init];
    [self.LowNav pushViewController:OpenInvoice animated:YES];
    if ([[[UIApplication sharedApplication].delegate window] viewWithTag:110] != nil) {
        [[[[UIApplication sharedApplication].delegate window] viewWithTag:110] removeFromSuperview];
    }
}
@end
