//
//  CommandTo.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/9/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CommandTo.h"
#import "ShouKeBao.h"
#import "ProduceDetailViewController.h"
@implementation CommandTo


- (IBAction)cananl:(UIButton *)sender {
    [self disappear];
}

//去除半透明背景以及圈口令
-(void)disappear{
    UIView *backgroundgp = [self.superview viewWithTag:101];
    UIView *commendshow = [self.superview viewWithTag:102];
    [backgroundgp  removeFromSuperview];
    [commendshow removeFromSuperview];
}

- (IBAction)nowsee:(UIButton *)sender {
    ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
    detail.produceUrl = @"http://mtest.lvyouquan.cn/Login?appbusid=C2B89DD0E484DE292F1B749B55F775AF6B7AE551F3F4E4D94EDF9E51AF8F1D3E9669C6267BF34CAE8B30398A80A74A2F48B83C8CF056B199&callBack=%2fProduct%2fProductDetail%2f62b55e8212da43918774190296b9e414%3fviewsource%3d2%26isfromapp%3d1%26apptype%3d1%26version%3d1.2.5.0%26appuid%3d7b5524fe3a56456ea3bb008adc313f28%26substation%3d10&substation=10";
    
    [self.NAV pushViewController:detail animated:YES];
    [self disappear];
}
- (void)setProductModel:(DayDetail *)productModel{
//    _productModel = productModel;
//    productModel.Name = @"这只是一个测试，不要在意这些细节,这只是一r个测试，不要在意这些细节,这只是一个测试，不要在意这些细节";
//    self.bodyLabel.text = _productModel.Name;
//    NSLog(@"%@",_productModel.Name);
//    productModel.PersonPeerPrice = @"6000";
//    self.PriceLabel.text = productModel.PersonPeerPrice;
//    productModel.PersonAlternateCash = @"500";
//    self.DiLabel.text = productModel.PersonAlternateCash;
//    productModel.SendCashCoupon = @"500";
//    self.SongLabel.text = productModel.SendCashCoupon;
//    productModel.PersonPrice = @"1234";
//    self.hahaLabel.text = [NSString stringWithFormat:@"%@门市",productModel.PersonPrice];
}
@end
