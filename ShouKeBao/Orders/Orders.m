//
//  Orders.m
//  ShouKeBao
//
//  Created by Chard on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Orders.h"
#import "MJRefresh.h"
#import "OrderCell.h"
#import "OrderModel.h"
#import "OrderTool.h"
#import "DressView.h"
#import "AreaViewController.h"
#import "MBProgressHUD+MJ.h"
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
#import "MenuButton.h"
#import "QDMenu.h"
#import "ChooseDayViewController.h"
#import "UIImage+QD.h"
#import "ArrowBtn.h"
#import "NullContentView.h"

#define pageSize 10
#define searchDefaultPlaceholder @"订单号/产品名称/供应商名称"
#define historyCount 6

@interface Orders () <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,DressViewDelegate,AreaViewControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate,OrderCellDelegate,MGSwipeTableCellDelegate,MenuButtonDelegate,QDMenuDelegate,ChooseDayViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) int pageIndex;// 当前页
@property (nonatomic,assign) BOOL added;
@property (nonatomic,copy) NSString *totalCount;

@property (nonatomic,strong) MenuButton *menuButton;
@property (nonatomic,strong) QDMenu *qdmenu;
@property (nonatomic,assign) NSInteger LselectedIndex;
@property (nonatomic,assign) NSInteger RselectedIndex;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) NSMutableArray *chooseTime;// 所有时间
@property (nonatomic,strong) NSMutableArray *chooseStatus;// 所有状态

@property (nonatomic,copy) NSString *choosedTime;// 选择的时间
@property (nonatomic,copy) NSString *choosedStatus;// 选择的状态

@property (nonatomic,copy) NSString *goDateStart;
@property (nonatomic,copy) NSString *goDateEnd;

@property (nonatomic,copy) NSString *createDateStart;
@property (nonatomic,copy) NSString *createDateEnd;

@property (nonatomic,strong) NSMutableArray *firstAreaData;
@property (nonatomic,strong) NSDictionary *firstValue;// 选择大区以后获取值
@property (nonatomic,strong) NSDictionary *secondValue;// 选择二级区获取的值
@property (nonatomic,strong) NSDictionary *thirdValue;// 三级选择

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) DressView *dressView;
@property (nonatomic,weak) UIView *cover;


//@property (nonatomic,weak) UIView *sep1;// 开始搜索的边界线
@property (nonatomic,weak) UIView *sep2;

@property (nonatomic,strong) SKSearchBar *searchBar;
@property (nonatomic,strong) SKSearckDisplayController *searchDisplay;
@property (nonatomic,copy) NSString *searchKeyWord;
@property (nonatomic,assign) BOOL isSearch;// 判断是不是 搜索结果  因为列表空的话显示的文字不同

@property (nonatomic,strong) DetailView *detailView;

@property (nonatomic,weak) HistoryView *historyView;

@property (nonatomic,assign) BOOL isHeadRefresh;

@property (nonatomic,strong) NullContentView *nullContentView;

@end

@implementation Orders

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"理订单";
    [self.dataArr removeAllObjects];// 进来时清空数组 心情舒畅些
    self.pageIndex = 1;// 页码从1开始
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.choosedTime = @"";
    self.choosedStatus = @"0";
    self.searchKeyWord = @"";
    self.goDateStart = @"";
    self.goDateEnd = @"";
    self.createDateStart = @"";
    self.createDateEnd = @"";
    
    // 导航按钮
    [self customRightBarItem];
    
    // 刷新控件
    [self iniHeader];

    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.menu];
    [self.view addSubview:self.menuButton];
    [self searchDisplay];
    [self.view addSubview:self.searchBar];
    
    [self loadConditionData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBack:) name:@"DressViewClickBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickReset:) name:@"DressViewClickReset" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickConfirm:) name:@"DressViewClickConfirm" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCellDidClickButton:) name:@"orderCellDidClickButton" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historySearch:) name:@"historysearch" object:nil];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *isFirst = [def objectForKey:@"isFirst"];
    if ([isFirst integerValue] != 1) {// 是否第一次打开app
        [self Guide];
    }
    [self Guide];

    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
                            @"GoDateStart":self.goDateStart,
                            @"GoDateEnd":self.goDateEnd,
                            @"FirstLevelArea":first,
                            @"SecondLevelAreaID":second,
                            @"ThirdLevelAreaID":third,
                            @"CreatedDateStart":self.createDateStart,
                            @"CreatedDateEnd":self.createDateEnd,
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
                self.totalCount = json[@"TotalCount"];
                
                for (NSDictionary *dic in json[@"OrderList"]) {
                    OrderModel *order = [OrderModel orderModelWithDict:dic];
                    [self.dataArr addObject:order];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isSearch = self.searchKeyWord.length;
                    [self setNullImage];
                    [self.tableView reloadData];
                });
            });
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - private

-(void)Guide
{
    UIView *guideView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    guideView.backgroundColor = [UIColor clearColor];
    UIImageView *img = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    img.image = [UIImage imageNamed:@"orderSwipLeftGuide"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        [guideView removeFromSuperview];
    });
    
    [guideView addSubview:img];
    [[[UIApplication sharedApplication].delegate window] addSubview:guideView];
}
- (void)setNullImage
{
    self.nullContentView.hidden = self.dataArr.count;
    if (!self.nullContentView.hidden) {
        [self.nullContentView setNullContentIsSearch:self.isSearch];
    }
}

- (NSInteger)getEndPage
{
    NSInteger cos = [self.totalCount integerValue] % pageSize;
    if (cos == 0) {
        return [self.totalCount integerValue] / pageSize;
    }else{
        return [self.totalCount integerValue] / pageSize + 1;
    }
}

// 自定义导航按钮
-(void)customRightBarItem
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [button setImage:[UIImage imageNamed:@"APPsaixuan"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(selectAction)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barItem;
}

// 点击筛选
- (void)selectAction
{
    UIView *cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dressTapHandle:)];
    tap.delegate = self;
    [cover addGestureRecognizer:tap];
    self.cover = cover;
    
    // 筛选视图
    [cover addSubview:self.dressView];
    [self.view.window addSubview:cover];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dressView.transform = CGAffineTransformMakeTranslation(- self.dressView.frame.size.width, 0);
    }];
}

// 去除筛选界面
- (void)dressTapHandle:(UITapGestureRecognizer *)ges
{
    [UIView animateWithDuration:0.3 animations:^{
        self.dressView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [ges.view removeFromSuperview];
        [_dressView removeFromSuperview];
    }];
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
    if (self.pageIndex < [self getEndPage]) {
        [self loadDataSuorceByCondition];
    }else{
        [self.tableView footerEndRefreshing];
    }
}

// 右边滑动的按钮
- (NSArray *)createRightButtons:(OrderModel *)model
{
    NSMutableArray * result = [NSMutableArray array];
    UIColor * color = [UIColor whiteColor];
    
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:nil icon:nil backgroundColor:color callback:^BOOL(MGSwipeTableCell * sender){
        NSLog(@"Convenience callback received (right).");
        return YES;
    }];
    CGRect frame = button.frame;
    frame.size.width = 230;
    button.frame = frame;
    [result addObject:button];
    button.enabled = YES;
    
    CantactView *contact = [[CantactView alloc] initWithFrame:button.frame];
    contact.userInteractionEnabled = YES;
    contact.model = model;
    
    [button addSubview:contact];
    
    return result;
}

/**
 *  创建菜单
 */
- (void)createMenuWithSelectedIndex:(NSInteger)SelectedIndex frame:(CGRect)frame dataSource:(NSMutableArray *)dataSource direct:(NSInteger)direct
{
    self.qdmenu = [[QDMenu alloc] init];
    self.qdmenu.direct = direct;
    self.qdmenu.currentIndex = SelectedIndex;
    self.qdmenu.delegate = self;
    self.qdmenu.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    self.qdmenu.frame = frame;
    self.qdmenu.dataSource = dataSource;
    if (direct == 1) {
        self.qdmenu.layer.anchorPoint = CGPointMake(1, 0);
        UIImage *image = [UIImage imageNamed:@"bubble"];
        CGFloat w = image.size.width;
        CGFloat h = image.size.height;
        self.qdmenu.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(h * 0.5, w * 0.2, h * 0.5, w * 0.8)];
//        self.qdmenu.image = [UIImage resizedImageWithName:@"bubble" left:0.2 top:0.5];
    }
    [self.coverView addSubview:self.qdmenu];
    
    [self.view.window addSubview:self.coverView];
}

/**
 *  删除出现的列表
 */
- (void)removeMenu:(UITapGestureRecognizer *)ges
{
    [self removeMenuFunc];
}

- (void)removeMenuFunc
{
    [_qdmenu removeFromSuperview];
    self.qdmenu = nil;
    self.qdmenu.delegate = nil;
    
    // 等待渐变动画执行完
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_coverView removeFromSuperview];
    });
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.cover || touch.view == self.coverView) {
        return YES;
    }
    return NO;
}

#pragma mark - getter
- (NullContentView *)nullContentView
{
    if (!_nullContentView) {
        _nullContentView = [[NullContentView alloc] init];
        CGFloat viewW = self.view.frame.size.width;
        CGFloat viewH = self.tableView.frame.size.height - 54 - 50;
        CGFloat viewY = 25;
        _nullContentView.frame = CGRectMake(0, viewY, viewW, viewH);
        _nullContentView.hidden = YES;
        [self.tableView addSubview:_nullContentView];
    }
    return _nullContentView;
}

- (MenuButton *)menuButton
{
    if (!_menuButton) {
        _menuButton = [[MenuButton alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 45)];
        _menuButton.delegate = self;
    }
    return _menuButton;
}

- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMenu:)];
        tap.delegate = self;
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

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

- (DressView *)dressView
{
    if (!_dressView) {
        CGFloat W = self.view.frame.size.width * 0.8;
        _dressView = [[DressView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, W, self.view.window.bounds.size.height)];
        _dressView.delegate = self;
    }
    return _dressView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 89, self.view.frame.size.width, self.view.frame.size.height - 202) style:UITableViewStyleGrouped];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:238/255.0 alpha:1];
    }
    return _tableView;
}

- (SKSearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[SKSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
        _searchBar.delegate = self;
        _searchBar.barStyle = UISearchBarStyleDefault;
        _searchBar.translucent = NO;
        _searchBar.placeholder = searchDefaultPlaceholder;
        _searchBar.barTintColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeSentences;
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

#pragma mark - MenuButtonDelegate
/**
 *  点击选择左菜单
 */
- (void)menuDidSelectLeftBtn:(UIButton *)leftBtn
{
    CGFloat menuX = self.view.frame.size.width * 0.25 - 30;
    CGRect frame = CGRectMake(menuX, 153, 135, 45 * 6);
    [self createMenuWithSelectedIndex:self.LselectedIndex frame:frame dataSource:self.chooseTime direct:0];
}

/**
 *  点击选择右菜单
 */
- (void)menuDidSelectRightBtn:(UIButton *)RightBtn
{
    CGFloat menuX = self.view.frame.size.width * 0.75 + 30;
    CGRect frame = CGRectMake(menuX, 153, 135, 45 * 7);
    [self createMenuWithSelectedIndex:self.RselectedIndex frame:frame dataSource:self.chooseStatus direct:1];
}

#pragma mark - QDMenuDelegate
- (void)menu:(QDMenu *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (menu.direct == 0) {// 时间筛选
        NSString *title = menu.dataSource[indexPath.row][@"Text"];
        self.menuButton.leftBtn.text = title;
        
        self.choosedTime = menu.dataSource[indexPath.row][@"Value"];
        [self removeMenuFunc];
        self.LselectedIndex = indexPath.row;
        [self.tableView headerBeginRefreshing];
    }else{// 状态筛选
         NSString *title = menu.dataSource[indexPath.row][@"Text"];
        self.menuButton.rightBtn.text = title;
        
        self.choosedStatus = menu.dataSource[indexPath.row][@"Value"];
        [self removeMenuFunc];
        self.RselectedIndex = indexPath.row;
        [self.tableView headerBeginRefreshing];
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
    detail.title = @"订单详情";
    [self.navigationController pushViewController:detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *order = self.dataArr[indexPath.section];
    if (order.buttonList.count) {
        return 202;
    }else{
        return 172;
    }
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
    if (direction == MGSwipeDirectionRightToLeft) {
        return YES;
    }
    return NO;
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
        area.title = @"大区";
        [self.navigationController pushViewController:area animated:YES];
    }else if (type == secondArea){
        if (self.firstValue && ![self.firstValue[@"Value"] isEqualToString:@"0"]) {
            // 获取二级列表
            NSDictionary *param = @{@"FirstLevelArea":self.firstValue[@"Value"]};
            self.cover.hidden = YES;
            area.type = secondArea;
            area.param = param;
            area.title = @"线路区域";
            [self.navigationController pushViewController:area animated:YES];
        }
    }else{// 点击三级区域
        if (self.secondValue) {
            // 获取三级级列表
            NSDictionary *param = @{@"SecondLevelAreaID":self.secondValue[@"Value"]};
            self.cover.hidden = YES;
            area.type = thirdArea;
            area.param = param;
            area.title = @"国家/省份";
            [self.navigationController pushViewController:area animated:YES];
        }
    }
}

- (void)didSelectedTimeWithType:(timeType)type
{
    ChooseDayViewController *choose = [[ChooseDayViewController alloc] init];
    choose.type = type;
    choose.delegate = self;
    self.cover.hidden = YES;
    [self.navigationController pushViewController:choose animated:YES];
}

#pragma mark - ChooseDayViewControllerDelegate
- (void)finishChoosedTimeArr:(NSArray *)timeArr andType:(timeType)type
{
    self.cover.hidden = NO;
    if (type == timePick) {
        self.goDateStart = timeArr[0];
        self.goDateEnd = timeArr[1];
        self.dressView.goDateText = [NSString stringWithFormat:@"%@~%@",self.goDateStart,self.goDateEnd];
    }else{
        self.createDateStart = timeArr[0];
        self.createDateEnd = timeArr[1];
        self.dressView.createDateText = [NSString stringWithFormat:@"%@~%@",self.createDateStart,self.createDateEnd];
    }
    [self.dressView.tableView reloadData];
}

- (void)backToDress
{
    self.cover.hidden = NO;
    
}

#pragma mark - Notification
- (void)clickBack:(NSNotification *)noty
{
    [UIView animateWithDuration:0.3 animations:^{
        self.dressView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_dressView removeFromSuperview];
        [self.cover removeFromSuperview];
    }];
    
}

- (void)clickReset:(NSNotification *)noty
{
//    [self.firstAreaData removeAllObjects];
    self.firstValue = nil;
    self.secondValue = nil;
    self.thirdValue = nil;
    self.goDateStart = @"";
    self.goDateEnd = @"";
    self.createDateStart = @"";
    self.createDateEnd = @"";
    
    self.dressView.firstText = nil;
    self.dressView.secondText = nil;
    self.dressView.thirdText = nil;
    self.dressView.goDateText = @"不限";
    self.dressView.createDateText = @"不限";
    [self.dressView.IsRefund setOn:NO animated:YES];
    [self.dressView.tableView reloadData];
}

- (void)clickConfirm:(NSNotification *)noty
{
    [UIView animateWithDuration:0.3 animations:^{
        self.dressView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_dressView removeFromSuperview];
        [self.cover removeFromSuperview];
        [self.tableView headerBeginRefreshing];
    }];
}

- (void)orderCellDidClickButton:(NSNotification *)noty
{
    NSString *url = noty.userInfo[@"linkUrl"];
    NSString *title = noty.userInfo[@"title"];
    ButtonDetailViewController *detail = [[ButtonDetailViewController alloc] init];
    detail.linkUrl = url;
    detail.title = title;
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
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.hidden = NO;
    }];
    
    [self.dressView.tableView reloadData];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

// 这个方法里面纯粹调样式
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    for (UIView *searchbuttons in [[searchBar.subviews objectAtIndex:0] subviews])
    {
        if ([searchbuttons isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton *)searchbuttons;
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"取消"];
            NSMutableDictionary *muta = [NSMutableDictionary dictionary];
            [muta setObject:[UIColor colorWithRed:68/255.0 green:122/255.0 blue:208/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
            [muta setObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
            [attr addAttributes:muta range:NSMakeRange(0, 2)];
            [cancelButton setAttributedTitle:attr forState:UIControlStateNormal];
            
            break;
        }else{
            UITextField *textField = (UITextField *)searchbuttons;
            
            // 边界线
            CGFloat sepX = CGRectGetMaxX(textField.frame);
            UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(sepX, 25, 0.5, 34)];
            sep2.backgroundColor = [UIColor lightGrayColor];
            sep2.alpha = 0.3;
            [self.view.window addSubview:sep2];
            self.sep2 = sep2;
        }
    }
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
    
    // 再加上新的搜索记录
    [tmp addObject:self.searchKeyWord];
    
    // 判断超出了6个的话把最早的去掉
    if (tmp.count > historyCount) {
        [tmp removeObjectAtIndex:0];
    }
    
    // 并保存
    [WriteFileManager saveFileWithArray:tmp Name:@"historysearch"];
    
    [self.searchDisplayController setActive:NO animated:YES];
    [self.tableView headerBeginRefreshing];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UISearchDisplayDelegate
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
//        [UIView animateWithDuration:0.25 animations:^{
//            for (UIView *subview in self.view.subviews)
//                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
//        }];
//    }
    
    // 纯粹调节样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
     self.searchBar.barTintColor = [UIColor whiteColor];
    
    // 历史记录的界面
    HistoryView *historyView = [[HistoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height + 49)];
    historyView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    [self.view.window addSubview:historyView];
    self.historyView = historyView;
    
    self.searchBar.placeholder = searchDefaultPlaceholder;
    self.searchBar.text = self.searchKeyWord;
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    //        [UIView animateWithDuration:0.25 animations:^{
    //            for (UIView *subview in self.view.subviews)
    //                subview.transform = CGAffineTransformIdentity;
    //        }];
    //    }
    [self.sep2 removeFromSuperview];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.searchBar.barTintColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    
    [self.historyView removeFromSuperview];
    
    if (self.searchKeyWord.length){
        self.searchBar.placeholder = self.searchKeyWord;
    }else{
        self.searchBar.placeholder = searchDefaultPlaceholder;
    }
}

@end
