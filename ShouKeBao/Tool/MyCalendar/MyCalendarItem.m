//
//  MyCalendarItem.m
//  HYCalendar
//
//  Created by nathan on 14-9-17.
//  Copyright (c) 2014年 nathan. All rights reserved.
//

#import "MyCalendarItem.h"


@implementation MyCalendarItem
{
    UIButton  *_selectButton;
    NSMutableArray *_daysArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            UIButton *button = [[UIButton alloc] init];
            [self addSubview:button];
            [_daysArray addObject:button];
        }
    }
    return self;
}

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
//  获取返回今天的日期
//    NSLog(@"---- %ld", [components day]);
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
  //  获取返回yue
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
//    NSLog(@"--year---- %ld", [components year]);
//    返回年
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
//   comp 信息为年月日
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
        NSLog(@"--comp---- %@", comp);

    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
//    设定每月的第一天从星期几开始 周日为1
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
//    NSLog(@"--firstWeekday---- %ld", firstWeekday);
//    NSLog(@"--firstDayOfMonthDate---- %@", firstDayOfMonthDate);

    return firstWeekday - 1;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
//    上个月的今天
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
//    NSLog(@"lastMonth:newDate===== %@", newDate);
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
//    NSLog(@"nextMonth:newDate===== %@", newDate);

    return newDate;
}

#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    
    [self createCalendarViewWith:date];
}

- (void)createCalendarViewWith:(NSDate *)date{

    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = self.frame.size.height / 7;
    CGFloat gap = (itemW - itemSize) * 0.5;
    
//    self.backgroundColor = [UIColor orangeColor];
    // 1.year month
    UILabel *headlabel = [[UILabel alloc] init];
    headlabel.text     = [NSString stringWithFormat:@"%li年%li月",(long)[self year:date],(long)[self month:date]];
    headlabel.font     = [UIFont systemFontOfSize:14];
    headlabel.frame           = CGRectMake(0, 0, self.frame.size.width, 25);
    headlabel.textAlignment   = NSTextAlignmentCenter;
    [self addSubview:headlabel];
//    细横线
    UIView *sep1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headlabel.frame), self.frame.size.width, 0.5)];
    sep1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self addSubview:sep1];
    
    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    sep2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self addSubview:sep2];
    
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW + gap;
        int y = (i / 7) * itemH + CGRectGetMaxY(headlabel.frame) + gap;
        
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, itemSize, itemSize);
        dayButton.titleLabel.font = [UIFont systemFontOfSize:16];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.layer.cornerRadius = 5.0f;
//        [dayButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [dayButton setBackgroundImage:[UIImage imageNamed:@"bule"] forState:UIControlStateSelected];
        [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
        
        // this month
        if ([self month:date] == [self month:[NSDate date]]) {
            
            NSInteger todayIndex = [self day:date] + firstWeekday - 1;
            
            if (i < todayIndex && i >= firstWeekday) {
                [self setStyle_BeforeToday:dayButton];
            
            }else if(i ==  todayIndex){
                [self setStyle_Today:dayButton];
                
            }
        }
    }
}

#pragma mark - output date
-(void)logDate:(UIButton *)dayBtn
{
    _selectButton.selected = NO;
    dayBtn.selected = YES;
    _selectButton = dayBtn;
    
    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit) fromDate:self.date];
    
    NSDate *tmpDate = [self dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)[comp year],(long)[comp month],(long)day]];
    
    NSDateComponents *co = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit) fromDate:tmpDate];
    NSLog(@"------%ld",(long)co.weekday - 1);
    
    if (self.calendarBlock) {
        
        
        self.calendarBlock(day, [comp month], [comp year] ,tmpDate);
    }
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

#pragma mark - date button style

- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    if (self.isOrderTime) {
//        btn.enabled = YES;
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }

}

- (void)setStyle_BeforeToday:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    if (self.isOrderTime) {
        btn.enabled = YES;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }

}

- (void)setStyle_Today:(UIButton *)btn
{
    btn.enabled = NO;
    if (self.isOrderTime) {
        btn.enabled = YES;
    }
    [btn setTitle:@"今天" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:19/255.0 green:143/255.0 blue:221/255.0 alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//    [btn setBackgroundColor:[UIColor orangeColor]];
}

- (void)setStyle_AfterToday:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (self.isOrderTime) {
        btn.enabled = NO;
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }

}


@end
