//
//  ChooseDayViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/14.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ChooseDayViewController.h"
#import "CalendarViewController.h"
#import "WMNavigationController.h"

@interface ChooseDayViewController ()<CalendarViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) BOOL isSelected;// 是否选择

@end

@implementation ChooseDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.isSelected = NO;
    
    NSArray *tmp = @[@"出发日期",@"返回日期"];
    self.dataSource = [NSMutableArray arrayWithArray:tmp];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isSelected) {
        if (_delegate && [_delegate respondsToSelector:@selector(finishChoosedTimeArr:andType:)]) {
            [_delegate finishChoosedTimeArr:self.dataSource andType:self.type];
        }
    }
}

#pragma mark - tableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"choosedaycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark - tableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarViewController *calendar = [[CalendarViewController alloc] init];
    calendar.delegate = self;
    calendar.index = indexPath.row;
    WMNavigationController *nav = [[WMNavigationController alloc] initWithRootViewController:calendar];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - CalendarViewControllerDelegate
- (void)didSelectedDate:(NSString *)date atIndex:(NSInteger)index
{
    self.isSelected = YES;
    [self.dataSource replaceObjectAtIndex:index withObject:date];
    [self.tableView reloadData];
}

@end
