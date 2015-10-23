//
//  DressFooter.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/20.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "DressFooter.h"

@implementation DressFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.isRefund.on = NO;
}

@end
