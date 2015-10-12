//
//  LeaveShare.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "LeaveShare.h"
#import "ProduceDetailViewController.h"
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
    UIAlertView *aa = [[UIAlertView alloc] initWithTitle:@"欢迎你被秀了" message:@"快说你是逗比,哈哈" delegate:self cancelButtonTitle:@"我是逗比" otherButtonTitles:@"我是逗比", nil];
    [aa show];
}

@end
