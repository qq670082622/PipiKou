//
//  InvoiceLowView.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "InvoiceLowView.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
@implementation InvoiceLowView

-(Orders *)ord{
    if (_ord == nil) {
        _ord = (Orders *)self.ViewCont;
    }
    return _ord;
}
-(OpenInvoiceWebController *)OpenInvoice{
    if (_OpenInvoice == nil) {
        _OpenInvoice = [[OpenInvoiceWebController alloc] init];
    }
    return _OpenInvoice;
}

- (IBAction)SelectAllBtn:(UIButton *)sender {
    //Orders *ord = (Orders *)self.ViewCont;
    if (self.InvoiceAllBtn) {
        if (sender.tag != 2015) {
            [sender setImage:[UIImage imageNamed:@"InvoiceClickAll"] forState:UIControlStateNormal];
        }
        self.InvoiceAllBtn = NO;
    }else{
        if (sender.tag != 2015) {
            [sender setImage:[UIImage imageNamed:@"InvoiceClickAll"] forState:UIControlStateNormal];
        }
        self.InvoiceAllBtn = YES;
    }
    [self.ord ClickAllBtn];
}
- (IBAction)InbatchesbBtn:(UIButton *)sender {
    if (self.ord.invoiceArr.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有选中需要开发票的订单" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
        [alert show];
    }else{
        
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"OrdersChoceOrdersTackInvoiceClick" attributes:dict];
//        self.OpenInvoice.viewCont = self.ViewCont;
//        Orders *order = (Orders *)self.ord;
        self.OpenInvoice.OrderIDArr = [self.ord.invoiceArr mutableCopy];
        NSLog(@"%@",self.ord.invoiceArr);
        
        
        [self.LowNav pushViewController:self.OpenInvoice animated:YES];
        if ([[[UIApplication sharedApplication].delegate window] viewWithTag:110] != nil) {
            [[[[UIApplication sharedApplication].delegate window] viewWithTag:110] removeFromSuperview];
        }
    }

}
-(void)reloadLowView:(ReloadLowView)reloadView{
     //Orders *ord = (Orders *)self.ViewCont;
    if (self.ord.invoiceArr.count < self.ord.InvoicedataArr.count) {
        [self.ChangeClickAllBtn setImage:[UIImage imageNamed:@"InvoiceAllBtn"] forState:UIControlStateNormal];
    }else if(self.ord.invoiceArr.count == self.ord.InvoicedataArr.count){
        [self.ChangeClickAllBtn setImage:[UIImage imageNamed:@"InvoiceClickAll"] forState:UIControlStateNormal];
    }
    self.orderNumLabel.text = [NSString stringWithFormat:@"已经选择%ld张订单",self.ord.invoiceArr.count];
}

@end
