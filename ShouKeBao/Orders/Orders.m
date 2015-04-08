//
//  Orders.m
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Orders.h"
#import "MJRefresh.h"
#import "OrderCell.h"
#import "OrderModel.h"
#import "DOPDropDownMenu.h"
#import "OrderTool.h"
#import "DressView.h"
#import "AreaViewController.h"
#import "MBProgressHUD+MJ.h"
#import "CalendarViewController.h"
#import "ButtonDetailViewController.h"
#import "OrderDetailViewController.h"
#import "DetailView.h"
#import "SKSearchBar.h"
#import "SKSearckDisplayController.h"
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "CantactView.h"
#import "WriteFileManager.h"
#import "HistoryView.h"

#define pageSize 10

@interface Orders () <DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,DressViewDelegate,AreaViewControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate,OrderCellDelegate,MGSwipeTableCellDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) int pageIndex;// 当前页

@property (nonatomic,strong) DOPDropDownMenu *menu;
@property (nonatomic,strong) NSMutableArray *chooseTime;// 所有时间
@property (nonatomic,strong) NSMutableArray *chooseStatus;// 所有状态

@property (nonatomic,copy) NSString *choosedTime;// 选择的时间
@property (nonatomic,copy) NSString *choosedStatus;// 选择的状态

@property (nonatomic,strong) NSMutableArray *firstAreaData;
@property (nonatomic,strong) NSDictionary *firstValue;// 选择大区以后获取值
@property (nonatomic,strong) NSDictionary *secondValue;// 选择二级区获取的值
@property (nonatomic,strong) NSDictionary *thirdValue;// 三级选择

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) DressView *dressView;
@property (nonatomic,weak) UIView *cover;

@property (nonatomic,strong) SKSearchBar *searchBar;
@property (nonatomic,strong) SKSearckDisplayController *searchDisplay;
@property (nonatomic,copy) NSString *searchKeyWord;

@property (nonatomic,strong) DetailView *detailView;

@property (nonatomic,weak) HistoryView *historyView;

@property (nonatomic,assign) BOOL isHeadRefresh;

@end

@implementation Orders

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"理订单";
    self.view.window.windowLevel = UIWindowLevelAlert;
    [self.dataArr removeAllObjects];// 进来时清空数组 心情舒畅些
    self.pageIndex = 1;// 页码从1开始
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.choosedTime = @"";
    self.choosedStatus = @"0";
    self.searchKeyWord = @"";
    
    // 导航按钮
    [self customRightBarItem];
    
    // 刷新控件
    [self iniHeader];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.menu];
    [self searchDisplay];
    [self.view addSubview:self.searchBar];
    
    [self loadConditionData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBack:) name:@"DressViewClickBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickReset:) name:@"DressViewClickReset" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickConfirm:) name:@"DressViewClickConfirm" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCellDidClickButton:) name:@"orderCellDidClickButton" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historySearch:) name:@"historysearch" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - loadDatasource
- (void)loadConditionData
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    [self.chooseTime removeAllObjects];
    [self.chooseStatus removeAllObjects];
    NSDictionary *param = @{};
    [OrderTool getOrderConditionWithParam:param success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].delegate.window animated:YES];
        if (json) {
            NSLog(@"----%@",json);
            if ([json[@"IsSuccess"] integerValue] == 1) {
                
                for (NSDictionary *timeDic in json[@"DateRangList"]) {
                    [self.chooseTime addObject:timeDic];
                }
                
                for (NSDictionary *statusDic in json[@"StateList"]) {
                    [self.chooseStatus addObject:statusDic];
                }
                
                for (NSDictionary *areaDic in json[@"FirstLevelArea"]) {
                    [self.firstAreaData addObject:areaDic];
                }
                // 获取筛选条件后加载默认的列表
                [self.tableView headerBeginRefreshing];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

// 根据条件加载数据
- (void)loadDataSuorceByCondition
{
    NSString *first = self.firstValue ? self.firstValue[@"Value"] : @"0";
    NSString *second = self.secondValue ? self.secondValue[@"Value"] : @"";
    NSString *third = self.thirdValue ? self.thirdValue[@"Value"] : @"";
    NSDictionary *param = @{@"PageIndex":[NSString stringWithFormat:@"%d",self.pageIndex],
                            @"PageSize":[NSString stringWithFormat:@"%d",pageSize],
                            @"KeyWord":self.searchKeyWord,
                            @"CreatedDateRang":self.choosedTime,
                            @"State":self.choosedStatus,
                            @"GoDateStart":@"",
                            @"GoDateEnd":@"",
                            @"FirstLevelArea":first,
                            @"SecondLevelAreaID":second,
                            @"ThirdLevelAreaID":third,
                            @"CreatedDateStart":@"",
                            @"CreatedDateEnd":@"",
                            @"IsRefund":[NSString stringWithFormat:@"%d",self.dressView.IsRefund.on]};
    [OrderTool getOrderListWithParam:param success:^(id json) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (json) {
            NSLog(@"------%@",json);
            dispatch_queue_t q = dispatch_queue_create("lidingd", DISPATCH_QUEUE_SERIAL);
            dispatch_async(q, ^{
                if (self.isHeadRefresh) {
                    [self.dataArr removeAllObjects];
                }
                
                for (NSDictionary *dic in json[@"OrderList"]) {
                    OrderModel *order = [OrderModel orderModelWithDict:dic];
                    [self.dataArr addObject:order];
                }
                self.searchKeyWord = @"";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - private
// 自定义导航按钮
-(void)customRightBarItem
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [button setImage:[UIImage imageNamed:@"APPsaixuan"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(selectAction)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barItem;
}

// 点击筛选
- (void)selectAction
{
    UIView *cover = [[UIView alloc] initWithFrame:self.view.bounds];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dressTapHandle:)];
    tap.delegate = self;
    [cover addGestureRecognizer:tap];
    self.cover = cover;
    
    // 筛选视图
    [cover addSubview:self.dressView];
    [self.view.window addSubview:cover];
}

// 去除筛选界面
- (void)dressTapHandle:(UITapGestureRecognizer *)ges
{
    [ges.view removeFromSuperview];
    [_dressView removeFromSuperview];
}

-(void)iniHeader
{    //下啦刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headRefresh) dateKey:nil];
    
    //上啦刷新
    [self.tableView addFooterWithTarget:self action:@selector(footRefresh)];
    //设置文字
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerRefreshingText = @"正在刷新中";
    
    self.tableView.footerPullToRefreshText = @"上拉刷新";
    self.tableView.footerRefreshingText = @"正在刷新";
}

-(void)headRefresh
{
    self.pageIndex = 1;
    self.isHeadRefresh = YES;
    [self loadDataSuorceByCondition];
}
-(void)footRefresh
{
    self.pageIndex ++;
    self.isHeadRefresh = NO;
    [self loadDataSuorceByCondition];
}

// 右边滑动的按钮
- (NSArray *)createRightButtons:(OrderModel *)model
{
    NSString *tmp = [NSString stringWithFormat:@"平台联系人 %@",model.FollowPerson[@"Name"]];
    NSMutableArray * result = [NSMutableArray array];
    UIColor * color = [UIColor whiteColor];
    
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:tmp icon:nil backgroundColor:color callback:^BOOL(MGSwipeTableCell * sender){
        NSLog(@"Convenience callback received (right).");
        return YES;
    }];
    CGRect frame = button.frame;
    frame.size.width = 200;
    button.frame = frame;
    [result addObject:button];
    button.enabled = YES;
    
    CantactView *contact = [[CantactView alloc] initWithFrame:button.frame];
    contact.userInteractionEnabled = YES;
    contact.model = model;
    
    [button addSubview:contact];
    
    return result;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.cover) {
        return YES;
    }
    return NO;
}

#pragma mark - getter
- (DetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[DetailView alloc] init];
        _detailView.center = self.view.window.center;
        _detailView.bounds = CGRectMake(0, 0, self.view.frame.size.width * 0.8, 272);
    }
    return _detailView;
}

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)chooseTime
{
    if (!_chooseTime) {
        _chooseTime = [NSMutableArray array];
    }
    return _chooseTime;
}

- (NSMutableArray *)chooseStatus
{
    if (!_chooseStatus) {
        _chooseStatus = [NSMutableArray array];
    }
    return _chooseStatus;
}

- (NSMutableArray *)firstAreaData
{
    if (!_firstAreaData) {
        _firstAreaData = [NSMutableArray array];
    }
    return _firstAreaData;
}

- (DOPDropDownMenu *)menu
{
    if (!_menu) {
        _menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 44) andHeight:40];
        _menu.dataSource = self;
        _menu.delegate = self;
    }
    return _menu;
}

- (DressView *)dressView
{
    if (!_dressView) {
        _dressView = [[DressView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 300, 0, 300, self.view.window.bounds.size.height)];
        _dressView.delegate = self;
    }
    return _dressView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84, self.view.frame.size.width, self.view.frame.size.height - 148) style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 204;
        _tableView.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:238/255.0 alpha:1];
    }
    return _tableView;
}

- (SKSearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[SKSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundColor = [UIColor clearColor];
        
    }
    
    return _searchBar;
}

- (SKSearckDisplayController *)searchDisplay
{
    if (!_searchDisplay) {
        _searchDisplay = [[SKSearckDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchDisplay.delegate = self;
        _searchDisplay.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _searchDisplay;
}

#pragma mark - DOPDropDownMenuDataSource,DOPDropDownMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 2;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.chooseTime.count;
    }else{
        return self.chooseStatus.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    if (self.chooseTime.count || self.chooseStatus.count) {
        if (indexPath.column == 0) {
            return self.chooseTime[indexPath.row][@"Text"];
        }else{
            return self.chooseStatus[indexPath.row][@"Text"];
        }
    }else{
        if (indexPath.column == 0) {
            return @"时间";
        }else{
            return @"状态";
        }
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        self.choosedTime = self.chooseTime[indexPath.row][@"Value"];
    }else{
        self.choosedStatus = self.chooseStatus[indexPath.row][@"Value"];
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell *cell = [OrderCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.orderDelegate = self;
    cell.indexPath = indexPath;
    
    // 取出模型
    OrderModel *order = self.dataArr[indexPath.section];

    cell.model = order;
    
    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    cell.rightButtons = [self createRightButtons:order];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出模型
    OrderModel *order = self.dataArr[indexPath.section];
    
    OrderDetailViewController *detail = [[OrderDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detail.url = order.DetailLinkUrl;
    
    [self.navigationController pushViewController:detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - OrderCellDelegate
- (void)checkDetailAtIndex:(NSInteger)index
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIView *cover = [[UIView alloc] initWithFrame:window.bounds];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [window addSubview:cover];
    
    [cover addSubview:self.detailView];
    // 取出模型
    OrderModel *order = self.dataArr[index];
    self.detailView.data = order.SKBOrder;
    
}

#pragma mark - MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction
{
    return YES;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSLog(@"------");
    return YES;
}

- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    return [NSArray array];
}

#pragma mark - DressViewDelegate
- (void)wantToPushAreaWithType:(areaType)type
{
    AreaViewController *area = [[AreaViewController alloc] init];
    area.delegate = self;
    
    if (type == firstArea){
        self.cover.hidden = YES;
        area.type = firstArea;
        area.dataSource = self.firstAreaData;
        [self.navigationController pushViewController:area animated:YES];
    }else if (type == secondArea){
        if (self.firstValue) {
            // 获取二级列表
            NSDictionary *param = @{@"FirstLevelArea":self.firstValue[@"Value"]};
            [OrderTool getSecondLevelAreaWithParam:param success:^(id json) {
                if (json) {
                    NSLog(@"-----%@",json);
                    NSMutableArray *tmp = [NSMutableArray array];
                    for (NSDictionary *dic in json[@"LevelAreaList"]) {
                        [tmp addObject:dic];
                    }
                    self.cover.hidden = YES;
                    area.type = secondArea;
                    area.dataSource = tmp;
                    [self.navigationController pushViewController:area animated:YES];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }else{// 点击三级区域
        if (self.secondValue) {
            // 获取三级级列表
            NSDictionary *param = @{@"SecondLevelAreaID":self.secondValue[@"Value"]};
            [OrderTool getThirdLevelAreaWithParam:param success:^(id json) {
                if (json) {
                    NSLog(@"-----%@",json);
                    NSMutableArray *tmp = [NSMutableArray array];
                    for (NSDictionary *dic in json[@"LevelAreaList"]) {
                        [tmp addObject:dic];
                    }
                    self.cover.hidden = YES;
                    area.type = thirdArea;
                    area.dataSource = tmp;
                    [self.navigationController pushViewController:area animated:YES];
                }
            } failure:^(NSError *error) {
                
            }];

        }
    }
}

- (void)didSelectedTimeWithType:(timeType)type
{
    self.cover.hidden = YES;
    CalendarViewController *calendar = [[CalendarViewController alloc] init];
    [self.navigationController pushViewController:calendar animated:YES];
}

#pragma mark - Notification
- (void)clickBack:(NSNotification *)noty
{
    [self.cover removeFromSuperview];
}

- (void)clickReset:(NSNotification *)noty
{
    [self.firstAreaData removeAllObjects];
    self.firstValue = nil;
    self.secondValue = nil;
    self.thirdValue = nil;
    
    self.dressView.firstText = nil;
    self.dressView.secondText = nil;
    self.dressView.thirdText = nil;
    [self.dressView.tableView reloadData];
    [self loadConditionData];
}

- (void)clickConfirm:(NSNotification *)noty
{
    [self.cover removeFromSuperview];
    [self.tableView headerBeginRefreshing];
}

- (void)orderCellDidClickButton:(NSNotification *)noty
{
    NSString *url = noty.userInfo[@"linkUrl"];
    ButtonDetailViewController *detail = [[ButtonDetailViewController alloc] init];
    detail.linkUrl = url;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)historySearch:(NSNotification *)noty
{
    self.searchKeyWord = noty.userInfo[@"historykey"];
    [self.searchDisplayController setActive:NO animated:YES];
    [self.tableView headerBeginRefreshing];
}

#pragma mark - AreaViewControllerDelegate
// 选择之后把值返回过来
- (void)didSelectAreaWithValue:(NSDictionary *)value Type:(areaType)type
{
    if (type == firstArea) {
        self.firstValue = value;
        self.dressView.firstText = value[@"Text"];
    }else if(type == secondArea){
        self.secondValue = value;
        self.dressView.secondText = value[@"Text"];
    }else{
        self.thirdValue = value;
        self.dressView.thirdText = value[@"Text"];
    }
    
    self.cover.hidden = NO;
    [self.dressView.tableView reloadData];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchKeyWord = searchText;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
    
    NSMutableArray *tmp = [NSMutableArray array];
    
    // 先取出原来的记录
    NSArray *arr = [WriteFileManager readFielWithName:@"historysearch"];
    [tmp addObjectsFromArray:arr];
    
    // 再加上新的搜索记录 并保存
    [tmp addObject:self.searchKeyWord];
    [WriteFileManager saveFileWithArray:tmp Name:@"historysearch"];
    
    [self.searchDisplayController setActive:NO animated:YES];
    [self.tableView headerBeginRefreshing];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UISearchDisplayDelegate
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
//        [UIView animateWithDuration:0.25 animations:^{
//            for (UIView *subview in self.view.subviews)
//                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
//        }];
//    }
    HistoryView *historyView = [[HistoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    historyView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    [self.view.window addSubview:historyView];
    self.historyView = historyView;
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    
    [self.historyView removeFromSuperview];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformIdentity;
        }];
    }
}

@end
