//
//  RecommendViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "RecommendViewController.h"
#import "DayDetailCell.h"
#import "HomeHttpTool.h"
#import "SearchProductViewController.h"
#import "StationSelect.h"

@interface RecommendViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    [self setupHead];
    
    [self setupFoot];
    
    [self loadDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.window.backgroundColor = [UIColor clearColor];
}

#pragma mark - private
- (void)loadDataSource
{
    NSDictionary *param = @{};
    [HomeHttpTool getRecommendProductListWithParam:param success:^(id json) {
        if (json) {
            NSLog(@"aaaaaaaa  %@",json);
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setupHead
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    cover.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    
    // 选择分站按钮
    UIButton *station = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 50, 30)];
    [station setBackgroundImage:[UIImage imageNamed:@"fenzhan"] forState:UIControlStateNormal];
    [station addTarget:self action:@selector(selectStation:) forControlEvents:UIControlEventTouchUpInside];
    [station setTitle:@"    上海" forState:UIControlStateNormal];
    [station setTitleColor:[UIColor colorWithRed:91/255.0 green:155/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    station.titleLabel.font = [UIFont systemFontOfSize:12];
    [cover addSubview:station];
    
    // 搜索按钮
    CGFloat searchX = CGRectGetMaxX(station.frame) + 5;
    CGFloat searchW = self.view.frame.size.width - station.frame.size.width - 5 * 3;
    UIButton *search = [[UIButton alloc] initWithFrame:CGRectMake(searchX, 5, searchW, 30)];
    [search setBackgroundImage:[UIImage imageNamed:@"shousuochanpin"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(goSearch:) forControlEvents:UIControlEventTouchUpInside];
    [cover addSubview:search];
    
    [self.view addSubview:cover];
}

- (void)setupFoot
{
    // 加载更多
    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [more setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [more addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = more;
}

// 选择分站
- (void)selectStation:(UIButton *)sender
{
    [self.navigationController pushViewController:[[StationSelect alloc] init] animated:YES];
}

// 搜索
- (void)goSearch:(UIButton *)sender
{
    SearchProductViewController *searchVC = [[SearchProductViewController alloc] init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

// 加载更多
- (void)loadMore:(UIButton *)sender
{
    
}

#pragma mark - getter
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 70;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DayDetailCell *cell = [DayDetailCell cellWithTableView:tableView];
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end
