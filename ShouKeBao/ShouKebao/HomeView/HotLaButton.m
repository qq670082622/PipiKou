//
//  HotLaButton.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "HotLaButton.h"
#define gap 5
@implementation HotLaButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

//        self.lable = [[UIButton alloc]initWithFrame:CGRectMake(gap, 0, 40, frame.size.height)];
//        NSLog(@"frame = %f", self.lable.frame.size.height);
//       [self.lable setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        
//        [self.lable setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
//        
//        [self.lable setImageEdgeInsets:UIEdgeInsetsMake(12, 0, 12, 0)];
//// UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)];
//        [self.lable setImage:[UIImage imageNamed:@"red-bg"] forState:UIControlStateNormal];
//        [self.lable setTitle:@"专辑" forState:UIControlStateNormal];
//        [self.lable.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        
//        self.lable.imageView.layer.masksToBounds = YES;
//        self.lable.imageView.layer.cornerRadius = 4;
//        [self addSubview:self.lable];

        self.lable = [[UILabel alloc]initWithFrame:CGRectMake(gap, 12, 40, frame.size.height-24)];
        NSLog(@"frame = %f", self.lable.frame.size.height);
        self.lable.textColor = [UIColor whiteColor];
        self.lable.backgroundColor = [UIColor redColor];
        self.lable.text = @"专辑";
        self.lable.textAlignment = NSTextAlignmentCenter;
        self.lable.font = [UIFont boldSystemFontOfSize:17];
        
        self.lable.layer.masksToBounds = YES;
        self.lable.layer.cornerRadius = 4;
        [self addSubview:self.lable];
        
        self.button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.lable.frame), 0, frame.size.width-CGRectGetMaxX(self.lable.frame)-gap, frame.size.height)];
        [self.button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.button setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 20)];
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.button];
    
    }
    return self;
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
