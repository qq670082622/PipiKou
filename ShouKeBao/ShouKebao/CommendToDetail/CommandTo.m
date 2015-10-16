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
    detail.produceUrl = self.NewPageUrl;
    detail.shareInfo = self.shareInfo;
    [self.NAV pushViewController:detail animated:YES];
    [self disappear];
}
- (void)setProductModel:(DayDetail *)productModel{

}
@end
