//
//  InvoiceLowView.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "InvoiceLowView.h"
#import "Orders.h"
@implementation InvoiceLowView


-(OpenInvoiceWebController *)OpenInvoice{
    if (_OpenInvoice == nil) {
        _OpenInvoice = [[OpenInvoiceWebController alloc] init];
    }
    return _OpenInvoice;
}

- (IBAction)SelectAllBtn:(UIButton *)sender {
    
}
- (IBAction)InbatchesbBtn:(UIButton *)sender {

    self.OpenInvoice.vvvc = self.ViewCont;
    [self.LowNav pushViewController:self.OpenInvoice animated:YES];
    if ([[[UIApplication sharedApplication].delegate window] viewWithTag:110] != nil) {
        [[[[UIApplication sharedApplication].delegate window] viewWithTag:110] removeFromSuperview];
    }
}
@end
