//
//  LeaveShare.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "LeaveShare.h"
#import "ProduceDetailViewController.h"
#import "NSString+FKTools.h"
@implementation LeaveShare

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)thisatest:(NSString *)body{

}
//去除半透明背景以及退出分享页面
-(void)disappear{
   
    UIView *CancelSe = [self.superview viewWithTag:103];
    UIView *backgroundgp = [self.superview viewWithTag:102];
    [backgroundgp  removeFromSuperview];
    [CancelSe removeFromSuperview];
}
- (IBAction)CancelBtn:(UIButton *)sender {
   
    ProduceDetailViewController *app = [[ProduceDetailViewController alloc] init];
    NSLog(@"--%@",self.nav);//
    [app CancelLeaveShareBlock:self.nav];
     [self disappear];
}

- (IBAction)NeedShareBtn:(UIButton *)sender {
    [self.theVC shareIt:nil];
    [self disappear];
}

@end
