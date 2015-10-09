//
//  SwipeView.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/9/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SwipeView.h"

@interface SwipeView()
@property (nonatomic, strong)UILabel *lastScheduleDate;
@property (nonatomic, strong)UILabel *lastScheduleDateStr;
@property (nonatomic, strong)UILabel *SupplierName;
@property (nonatomic, strong)UILabel *SupplierNameStr;
@end
@implementation SwipeView



- (instancetype)initWithFrame:(CGRect)frame
{self = [super initWithFrame:frame];
    if (self) {
        self.lastScheduleDate = [[UILabel alloc]init];
        self.lastScheduleDate.font = [UIFont systemFontOfSize:13];
        self.lastScheduleDate.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1];
        
        self.lastScheduleDateStr = [[UILabel alloc]init];
        self.lastScheduleDateStr.font = [UIFont systemFontOfSize:12];
        self.lastScheduleDateStr.textColor = [UIColor grayColor];
        self.lastScheduleDateStr.numberOfLines = 0;
        
        self.SupplierName = [[UILabel alloc]init];
        self.SupplierName.font = [UIFont systemFontOfSize:13];
        self.SupplierName.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1];
        
        self.SupplierNameStr = [[UILabel alloc]init];
        self.SupplierNameStr.font = [UIFont systemFontOfSize:12];
        self.SupplierNameStr.textColor = [UIColor grayColor];
        self.SupplierNameStr.numberOfLines = 0;
        
        [self addSubview:self.lastScheduleDate];
        [self addSubview:self.lastScheduleDateStr];
        [self addSubview:self.SupplierName];
        [self addSubview:self.SupplierNameStr];
    
    }
    return self;

}


+ (instancetype)addSubViewLable:(UIButton *)button Model:(ProductModal *)model
{
    SwipeView *swipView = [[SwipeView alloc]initWithFrame:button.frame];
    swipView.lastScheduleDate.text = @"最近班期:";
    swipView.lastScheduleDateStr.text = model.LastScheduleDate;
    swipView.SupplierName.text = @"供应商:";
    swipView.SupplierNameStr.text = model.SupplierName;
//    NSLog(@"%@-%@-%@", model.LastScheduleDate, model.SupplierName, swipView.lastScheduleDateStr.text);
//    NSLog(@"frame = %@", NSStringFromCGRect(button.frame));
    return swipView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.bounds.size.height;
    NSLog(@"ww = %f, %f", w, self.frame.size.height);
    
    CGFloat H1 = [self.lastScheduleDate.text heigthWithsysFont:13 withWidth:w*5/6];
    self.lastScheduleDate.frame = CGRectMake(w/12, h/10, w*5/6, H1);
    //    self.lastScheduleDate.backgroundColor = [UIColor yellowColor];
    self.lastScheduleDate.font = [UIFont systemFontOfSize:13];
    self.lastScheduleDate.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1];
    
    CGFloat H1_1 = [self.lastScheduleDateStr.text heigthWithsysFont:12 withWidth:w*5/6];
    self.lastScheduleDateStr.font = [UIFont systemFontOfSize:12];
    self.lastScheduleDateStr.frame = CGRectMake(w/12, CGRectGetMaxY(self.lastScheduleDate.frame), w*5/6, H1_1);
    self.lastScheduleDateStr.textColor = [UIColor grayColor];
    self.lastScheduleDateStr.numberOfLines = 0;
    
    
    //    self.SupplierName.text = @"供应商:";
    CGFloat H2 = [self.SupplierName.text heigthWithsysFont:13 withWidth:w*5/6];
    self.SupplierName.frame = CGRectMake(w/12, CGRectGetMaxY(self.lastScheduleDateStr.frame)+5, w*5/6, H2);
    self.SupplierName.font = [UIFont systemFontOfSize:13];
    self.SupplierName.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1];
    
    self.SupplierNameStr.font = [UIFont systemFontOfSize:12];
    CGFloat H2_2 = [self.SupplierNameStr.text heigthWithsysFont:12 withWidth:w*5/6];
    self.SupplierNameStr.frame = CGRectMake(w/12, CGRectGetMaxY(self.SupplierName.frame), w*5/6, H2_2);
    self.SupplierNameStr.textColor = [UIColor grayColor];
    self.SupplierNameStr.numberOfLines = 0;
    
    
}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
