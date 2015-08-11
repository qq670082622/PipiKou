//
//  CalendarViewController.m
//  ShouKeBao
//
//  Created by Chard on 15/3/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CalendarViewController.h"
#import "MyCalendarItem.h"
#import "MobClick.h"
#import "Orders.h"
@interface CalendarViewController ()

@property (nonatomic,assign) BOOL isCurrent;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择日期";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setup];
    //[self setNavBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"OrdersCalendarView"];

    if (self.selectedDate) {
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectedDateStr:atIndex:date:)]) {
            [_delegate didSelectedDateStr:self.selectedDate atIndex:self.index date:self.date];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"OrdersCalendarView"];

}
//- (void)setNavBar
//{
//    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
//    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    btn.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24);
//    [btn setImage:[UIImage imageNamed:@"appzuojiantou"] forState:UIControlStateNormal];
//    
//    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [cover addSubview:btn];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cover];
//}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setup
{
    CGFloat itemW = self.view.frame.size.width / 7;
    CGFloat viewH = itemW * 6;
    
    // scrollview
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    scroll.scrollEnabled = YES;
    [self.view addSubview:scroll];
    
    // weekday 1-7
    NSArray *array = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    UIView *weekBg = [[UIView alloc] init];
    weekBg.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:238/255.0 alpha:1];
    weekBg.frame = CGRectMake(0, 0, self.view.frame.size.width, 25);
    [scroll addSubview:weekBg];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 25);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor       = [UIColor blackColor];
        [weekBg addSubview:week];
    }
    
    
    
    
    // today month
    MyCalendarItem *calendarView = [[MyCalendarItem alloc] init];
    if (self.isOrdersTime) {
        calendarView.isOrderTime = YES;
    }
    calendarView.frame = CGRectMake(0, CGRectGetMaxY(weekBg.frame), self.view.frame.size.width, viewH);
    if (self.isOrdersTime) {
        calendarView.frame = CGRectMake(0, CGRectGetMaxY(weekBg.frame) + 4*viewH, self.view.frame.size.width, viewH);
    }
    [scroll addSubview:calendarView];
    
    calendarView.date = [NSDate date];
    calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
        
        // 判断返回时间是否大于出发时间
        if (self.index == 1) {
            NSTimeInterval first = [date timeIntervalSince1970];
            NSTimeInterval second = [self.goDate timeIntervalSince1970];
            if (first < second) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"返回时间必须大于出发时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
        }
        
        self.date = date;
        self.selectedDate = [NSString stringWithFormat:@"%li-%li-%li",(long)year,(long)month,(long)day];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    // other month
    for (int i = 0; i < 4; i ++) {
        MyCalendarItem *ca = [[MyCalendarItem alloc] init];
        
        CGFloat caY = calendarView.frame.origin.y + viewH * (i + 1);
        if (self.isOrdersTime) {
            caY = calendarView.frame.origin.y - viewH * (i + 1);
        }
        ca.frame = CGRectMake(0, caY, self.view.frame.size.width, viewH);
        
        NSDate *date = [NSDate date];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = + (i + 1);
        if (self.isOrdersTime) {
            dateComponents.month = - (i + 1);
        }
        NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
        ca.date = newDate;
        
        ca.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year, NSDate *date){
            
            // 判断返回时间是否大于出发时间
            if (self.index == 1) {
                NSTimeInterval first = [date timeIntervalSince1970];
                NSTimeInterval second = [self.goDate timeIntervalSince1970];
                if (first < second) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"返回时间必须大于出发时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    return;
                }
            }
            
            self.date = date;
            self.selectedDate = [NSString stringWithFormat:@"%li-%li-%li",(long)year,(long)month,(long)day];
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        [scroll addSubview:ca];
    }
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, viewH * 5 + 25);
}

@end
