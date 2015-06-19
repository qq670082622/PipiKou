//
//  CalendarViewController.h
//  ShouKeBao
//
//  Created by Chard on 15/3/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

@protocol CalendarViewControllerDelegate <NSObject>

- (void)didSelectedDateStr:(NSString *)dateStr atIndex:(NSInteger)index date:(NSDate *)date;

@end

@interface CalendarViewController : SKViewController

@property (nonatomic,copy) NSString *selectedDate;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) NSDate *date;

@property (nonatomic,strong) NSDate *goDate;

@property (nonatomic,assign)BOOL isOrdersTime;

@property (nonatomic,weak) id<CalendarViewControllerDelegate> delegate;

@end
