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

@property (nonatomic,weak) UIButton *confirm;// 确认按钮

@property (nonatomic,weak) UIButton *reset;// 重置按钮

@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,copy) NSString *start;

@property (nonatomic,copy) NSString *end;

@end

@implementation ChooseDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.title = @"选择日期";
    
    NSArray *tmp = @[@"最早时间",@"最晚时间"];
    self.dataSource = [NSMutableArray arrayWithArray:tmp];
    
    [self setFoot];
    
    [self setNav];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

#pragma mark - getter


#pragma mark - private
- (void)setNav
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
}

-(void)back
{
    if (_delegate && [_delegate respondsToSelector:@selector(backToDress)]) {
        [_delegate backToDress];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setFoot
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    CGFloat resetX = (self.view.frame.size.width - 210) * 0.5;
    UIButton *reset = [[UIButton alloc] initWithFrame:CGRectMake(resetX, 5, 100, 40)];
    reset.layer.cornerRadius = 2;
    reset.layer.masksToBounds = YES;
    [reset setTitle:@"重选" forState:UIControlStateNormal];
    [reset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reset setBackgroundImage:[UIImage imageNamed:@"rili-chongx"] forState:UIControlStateNormal];
    [reset addTarget:self action:@selector(resetChoose:) forControlEvents:UIControlEventTouchUpInside];
    self.reset = reset;
    [cover addSubview:reset];
    
    CGFloat confirmX = CGRectGetMaxX(reset.frame) + 10;
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(confirmX, 5, 100, 40)];
    confirm.layer.cornerRadius = 2;
    confirm.layer.masksToBounds = YES;
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm setBackgroundImage:[UIImage imageNamed:@"rili-qur"] forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirmDate:) forControlEvents:UIControlEventTouchUpInside];
    self.confirm = confirm;
    [cover addSubview:confirm];
    
    self.tableView.tableFooterView = cover;
}

// 重置选择
- (void)resetChoose:(UIButton *)sender
{
    self.start = nil;
    self.end = nil;
    NSArray *tmp = @[@"最早时间",@"最晚时间"];
    self.dataSource = [NSMutableArray arrayWithArray:tmp];
    [self.tableView reloadData];
}

// 确认选择
- (void)confirmDate:(UIButton *)sender
{
    if (self.start || self.end) {
        if (!self.end) {
            self.end = self.start;
        }else if(!self.start){
            self.start = self.end;
        }
        NSArray *tmp = @[self.start,self.end];
        
        if (_delegate && [_delegate respondsToSelector:@selector(finishChoosedTimeArr:andType:)]) {
            [_delegate finishChoosedTimeArr:tmp andType:self.type];
        }
        [self.navigationController popViewControllerAnimated:YES];
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
    
    // 如果出发时间已经选过 传给日历 便于判断返回时间要小于出发时间
    if (self.start.length > 0){
        calendar.goDate = self.startDate;
    }
    
    WMNavigationController *nav = [[WMNavigationController alloc] initWithRootViewController:calendar];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - CalendarViewControllerDelegate
- (void)didSelectedDateStr:(NSString *)dateStr atIndex:(NSInteger)index date:(NSDate *)date
{
    if (dateStr.length){
        if (index == 0){
            self.start = dateStr;
        }else{
            self.end = dateStr;
        }
        self.startDate = date;
        [self.dataSource replaceObjectAtIndex:index withObject:dateStr];
        [self.tableView reloadData];
    }
}

@end
