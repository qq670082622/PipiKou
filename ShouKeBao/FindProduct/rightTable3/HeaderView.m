//
//  HeaderView.m
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView
- (IBAction)btn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickedLoadBtn:)]) {
        [self.delegate headerViewDidClickedLoadBtn:self];
    }
}

+(instancetype)headerView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
//    self.btn.layer.cornerRadius = 5;
//    self.btn.layer.borderColor = [UIColor orangeColor].CGColor;
//    self.btn.layer.borderWidth = 1;
//    self.btn.layer.masksToBounds = YES;
}

@end
