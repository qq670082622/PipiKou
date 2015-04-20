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
#import "DayDetail.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "MJRefresh.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "OrderDetailViewController.h"

#define pageSize @"10"

@interface RecommendViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) BOOL isRefresh;

@property (nonatomic,copy) NSString *totalCount;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日推荐";
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pageIndex = 1;
    
    //下啦刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headRefresh) dateKey:nil];
    
    //设置文字
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerRefreshingText = @"正在刷新中";
    
    [self setNav];
    
    [self setupFoot];
    
    [self loadDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.window.backgroundColor = [UIColor clearColor];
    
    [self setupHead];
}

#pragma mark - private
- (void)loadDataSource
{
    NSDictionary *param = @{@"PageSize":pageSize,
                            @"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.pageIndex]};
    [HomeHttpTool getRecommendProductListWithParam:param success:^(id json) {
        [self.tableView headerEndRefreshing];
        if (json) {
            NSLog(@"aaaaaaaa  %@",json);
            self.totalCount = json[@"TotalCount"];
            if (self.isRefresh) {
                [self.dataSource removeAllObjects];
            }
            
            for (NSDictionary *dic in json[@"ProductList"]) {
                DayDetail *detail = [DayDetail dayDetailWithDict:dic];
                [self.dataSource addObject:detail];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)getEndPage
{
    NSInteger page = [pageSize integerValue];
    NSInteger cos = [self.totalCount integerValue] % page;
    if (cos == 0) {
        return [self.totalCount integerValue] / page;
    }else{
        return [self.totalCount integerValue] / page + 1;
    }
}

- (void)setNav
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 40, 40)];
    back.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [back setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [cover addSubview:back];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cover];
}

- (void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupHead
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    cover.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    
    // 选择分站按钮
    UIButton *station = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 75, 30)];
    station.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [station setBackgroundImage:[UIImage imageNamed:@"dizhi"] forState:UIControlStateNormal];
    [station addTarget:self action:@selector(selectStation:) forControlEvents:UIControlEventTouchUpInside];
    
    // 取出储存的分站
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    NSString *subStationName = [udf stringForKey:@"SubstationName"];
    [station setTitle:subStationName forState:UIControlStateNormal];
    if (![subStationName isKindOfClass:[NSNull class]]) {
        [station setTitle:@"上海" forState:UIControlStateNormal];
    }
    
    [station setTitleColor:[UIColor colorWithRed:91/255.0 green:155/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    station.titleLabel.font = [UIFont systemFontOfSize:12];
    [cover addSubview:station];
    
    // 搜索按钮
    CGFloat searchX = CGRectGetMaxX(station.frame) + 5;
    CGFloat searchW = self.view.frame.size.width - station.frame.size.width - 25;
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
    [more setTitle:@"查看更多产品" forState:UIControlStateNormal];
    [more setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [more addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    sep.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [more addSubview:sep];
    
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

// 刷新列表
- (void)headRefresh
{
    self.isRefresh = YES;
    self.pageIndex = 1;
    [self loadDataSource];
}

// 加载更多
- (void)loadMore:(UIButton *)sender
{
    self.isRefresh = NO;
    self.pageIndex ++;
    if (self.pageIndex < [self getEndPage]) {
        [self loadDataSource];
    }
}

// 右边滑动的按钮
- (NSArray *)createRightButtons
{
    NSMutableArray * result = [NSMutableArray array];
    UIColor * color = [UIColor whiteColor];
    
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:@"滑动隐藏<<" backgroundColor:color callback:^BOOL(MGSwipeTableCell * sender){
        NSLog(@"Convenience callback received (right).");
        return YES;
    }];
    
    CGRect frame = button.frame;
    frame.size.width = 50;
    button.frame = frame;
    
    button.enabled = YES;
    [button setImage:[UIImage imageNamed:@"fenx"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 0.5, 64)];
    sep.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [button addSubview:sep];
    [result addObject:button];
    
    return result;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 104)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 80;
        _tableView.separatorInset = UIEdgeInsetsZero;
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
    cell.delegate = self;
    
    DayDetail *detail = self.dataSource[indexPath.row];
    cell.detail = detail;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DayDetail *detail = self.dataSource[indexPath.row];
    OrderDetailViewController *web = [[OrderDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    web.url = detail.linkUrl;
    web.title = @"产品详情";
    [self.navigationController pushViewController:web animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction
{
    return YES;
}

- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionStatic;
    if (direction == MGSwipeDirectionRightToLeft) {
        return [self createRightButtons];
    }
    return [NSArray array];
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    // 取出模型
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DayDetail *detail = self.dataSource[indexPath.row];
    NSDictionary *tmp = detail.shareInfo;
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:tmp[@"Title"]
                                       defaultContent:tmp[@"Desc"]
                                                image:[ShareSDK imageWithUrl:tmp[@"Pic"]]
                                                title:tmp[@"Title"]
                                                  url:tmp[@"Url"]                                          description:tmp[@"Desc"]
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:sender  arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    
                                    [MBProgressHUD showSuccess:@"分享成功"];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                                        [MBProgressHUD hideHUD];
                                    });
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];

    
    return YES;
}

@end
