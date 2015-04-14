//
//  CalendarViewController.m
//  ShouKeBao
//
//  Created by Chard on 15/3/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CalendarViewController.h"


@interface CalendarViewController ()

@property (nonatomic,assign) BOOL isCurrent;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isCurrent = YES;
    
    [self calendarConfigure];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - private
- (void)calendarConfigure
{
   
}

#pragma mark - getter


#pragma mark - JTCalendarDataSource


#pragma mark - FSCalendarDelegate


@end
