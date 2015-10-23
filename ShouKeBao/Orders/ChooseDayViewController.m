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
#import "WMAnimations.h"
#import "MobClick.h"
@interface ChooseDayViewController ()<CalendarViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *buttonsArr;//按钮数据

@property (nonatomic,weak) UIButton *confirm;// 确认按钮

@property (nonatomic,weak) UIButton *reset;// 重置按钮

@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,copy) NSString *start;

@property (nonatomic,copy) NSString *end;

@property (nonatomic,assign) NSInteger rowHeightInSetionZero;
@end

@implementation ChooseDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[UIView alloc] init];
    self.title = @"选择日期";
    
    NSArray *tmp = @[@"最早时间",@"最晚时间"];
    self.dataSource = [NSMutableArray arrayWithArray:tmp];
    
    
    [self setFoot];
    self.navigationItem.leftBarButtonItem = leftItem;
   // [self setNav];
    if ([_needMonth isEqualToString:@"1"]) {
        [self getMonths];
    }
}


-(void)getMonths
{
    NSArray *keys = [self.buttons allKeys];
    
    NSString *firstKey = [keys objectAtIndex:0];
    
    NSMutableArray *arr = [NSMutableArray array];
    for(NSDictionary *dic in self.buttons[firstKey]){
        [arr addObject:dic];
    }
    self.buttonsArr = arr;
    [self setHeader];

    NSLog(@"---------------arr is %@------------",arr);
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OrdersChooseDayView"];

}

-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    [MobClick beginLogPageView:@"OrdersChooseDayView"];
}
#pragma mark - getter
-(NSMutableArray *)buttonsArr
{
    if (_buttons == nil) {
        self.buttonsArr = [NSMutableArray array];
    }
    return _buttonsArr;
}


#pragma mark - private
//- (void)setNav
//{
//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
//    
//    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    
//    self.navigationItem.leftBarButtonItem= leftItem;
//}


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
    if (_start) {
        self.start = nil;
        self.end = nil;
        NSArray *tmp = @[@"最早时间",@"最晚时间"];
        self.dataSource = [NSMutableArray arrayWithArray:tmp];
        [self.tableView reloadData];
    }else if (!_start) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉,您还没选择时间" message:@"请您选择时间" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
    }
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
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"isConformDic"];
        [dic setValue:@"1" forKey:@"startData"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}



#pragma mark - tableviewdatasource
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return _rowHeightInSetionZero ;
//}

-(void)setHeader
{
    
    CGFloat screenWid = [[UIScreen mainScreen] bounds].size.width;
    CGFloat btnW = (screenWid-120)/3;
    CGFloat btnH = 35;
    CGFloat   marginX = (screenWid - 3*btnW)/4;
    CGFloat marginY = 15;
    
    NSLog(@"self.buttonsArrclount is %lu , buttonsArr is %@",(unsigned long)self.buttonsArr.count,_buttonsArr);
    UIView *sectionView = [[UIView alloc] init];
    for (int i = 0 ; i<self.buttonsArr.count;i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.backgroundColor = [UIColor whiteColor];
        [WMAnimations WMAnimationMakeBoarderNoCornerRadiosWithLayer:btn.layer andBorderColor:[UIColor colorWithRed:210/255.f green:210/255.f blue:210/255.f alpha:1] andBorderWidth:1 andNeedShadow:NO];
        [btn setTitle:[NSString stringWithFormat:@"%@",self.buttonsArr[i][@"Text"]] forState:UIControlStateNormal];
        int row = i/3;
        int col = i%3;
        CGFloat btnX = marginX + col*(marginX + btnW);
        CGFloat btnY = marginY + row*(marginY + btnH);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      //  [sectionView addSubview:btn];
        
        [btn addTarget:self action:@selector(monthSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [sectionView addSubview:btn];
        if (i == self.buttonsArr.count - 1) {
            CGFloat maxY = btn.frame.origin.y+50;
            self.rowHeightInSetionZero = maxY;
            NSLog(@"------------------rowHeight is %ld-------------",(long)_rowHeightInSetionZero);
          sectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, _rowHeightInSetionZero);
            sectionView.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
            
            self.tableView.tableHeaderView = sectionView;
            [self.tableView reloadData];
        }
       
        
      }
   

}

-(void)monthSelectAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *selectName = self.buttonsArr[btn.tag][@"Text"];
    NSString *selectValue = self.buttonsArr[btn.tag][@"Value"];
    NSLog(@"selectname is %@ value is %@",selectName,selectValue);
    [self.delegate passTheButtonValue:selectValue andName:selectName];
    
    [self back];
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//   // if([self.needMonth isEqualToString:@"1"]){
//        UIView *sectionView = [[UIView alloc] init];
//        sectionView.backgroundColor = [UIColor lightGrayColor];
//    
//    CGFloat screenWid = [[UIScreen mainScreen] bounds].size.width;
//    CGFloat btnW = (screenWid-120)/3;
//    CGFloat btnH = 35;
//    CGFloat   marginX = 3*btnW/4;
//    CGFloat marginY = 15;
//    
//    NSLog(@"self.buttonsArrclount is %lu , buttonsArr is %@",(unsigned long)self.buttonsArr.count,_buttonsArr);
//    
//        for (int i = 0 ; i<self.buttonsArr.count;i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [btn setTitle:[NSString stringWithFormat:@"%@",self.buttonsArr[i][@"Text"]] forState:UIControlStateNormal];
//        int row = i/3;
//        int col = i%3;
//        CGFloat btnX = marginX + col*(marginX + btnW);
//        CGFloat btnY = marginY + row*(marginY + btnH);
//        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [sectionView addSubview:btn];
//        
//        [btn addTarget:self action:@selector(monthSelectAction:) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTag:i];
//        if (i == self.buttonsArr.count - 1) {
//            CGFloat maxY = btn.frame.origin.y+50;
//            self.rowHeightInSetionZero = maxY;
//            NSLog(@"------------------rowHeight is %ld-------------",(long)_rowHeightInSetionZero);
//        }
//            sectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, _rowHeightInSetionZero);
//     //   WithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _rowHeightInSetionZero)];
//
//        
//   }
//        return sectionView;
//   // }
//   // return 0;
//
//}
//
//





-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
           return 1;
}



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
    if (self.type == datePick) {
        calendar.isOrdersTime = YES;
    }else{
        calendar.isOrdersTime = NO;
    }
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
