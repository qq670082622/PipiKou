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

@interface ChooseDayViewController ()

@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation ChooseDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.dataSource = @[@"出发日期",@"返回日期"];
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
    
    WMNavigationController *nav = [[WMNavigationController alloc] initWithRootViewController:calendar];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
