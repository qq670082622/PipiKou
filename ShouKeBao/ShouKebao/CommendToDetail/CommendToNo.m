//
//  CommendToNo.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/24.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import "CommendToNo.h"

@implementation CommendToNo

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)IKnowBtn:(UIButton *)sender {
    UIView *backgroundgp = [self.superview viewWithTag:117];
    UIView *commendshow = [self.superview viewWithTag:116];
    [backgroundgp  removeFromSuperview];
    [commendshow removeFromSuperview];
    

}
@end
