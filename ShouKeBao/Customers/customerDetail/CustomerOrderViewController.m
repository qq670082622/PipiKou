//
//  CustomerOrderViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/6.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CustomerOrderViewController.h"
//#import "CustomerOrderCell.h"
#import "OrderCell.h"
#import "OrderDetailViewController.h"
#import "ButtonDetailViewController.h"
#import "Menum.h"
#import "ArrowBtn.h"
#import "MGSwipeButton.h"
#import "CantactView.h"
#import "UIScrollView+MJRefresh.h"
#import "QDMenu.h"
#import "NullContentView.h"
#import "OrderModel.h"
#import "DetailView.h"
#import "OrderTool.h"
#import "MBProgressHUD+MJ.h"
#define pageSize 10
#import "BaseClickAttribute.h"
#import "MobClick.h"

@interface CustomerOrderViewController ()<UITableViewDataSource, UITableViewDelegate, menumDelegate, QDMenuDelegate, /*QDMenumDelegate,*/ UIGestureRecognizerDelegate, MGSwipeTableCellDelegate, OrderCellDelegate>

@property (nonatomic, strong)NSMutableArray * dateSource;
@property (nonatomic,strong) UITableView *tableV;

@property (nonatomic,assign) NSInteger LeftselectedIndex;
@property (nonatomic,assign) NSInteger RightselectedIndex;
//时间 状态
@property (nonatomic, strong)Menum *meunm;
@property (nonatomic, assign)BOOL isNUll;
@property (nonatomic, strong)NullContentView *nullContentView;

@property (nonatomic, strong)QDMenu *qdmenu;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) NSMutableArray *chooseTime;// 所有时间
@property (nonatomic,strong) NSMutableArray *chooseStatus;// 所有状态
@property (nonatomic,copy) NSString *choosedTime;// 选择的时间
@property (nonatomic,copy) NSString *choosedStatus;// 选择的状态
@property (nonatomic,assign) BOOL isHeadRefresh;
@property (nonatomic,assign) int pageIndex;// 当前页
@property (nonatomic, strong) DetailView *detailView;
@property (nonatomic, assign)BOOL *dataIsNull;

@end

@implementation CustomerOrderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    [self loadDataByCondition];
    [self loadDataSuorceByCondition];
    
//    隐掉筛选
//    self.choosedTime = @"";
//    self.choosedStatus = @"0";
//    [self.view addSubview:self.meunm];
    [self.view addSubview:self.tableV];

    [self initHeader];
//    立即采购button
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickImmediateOrder:) name:@"orderCellDidClickButton" object:nil];

    // Do any additional setup after loading the view.
}

#pragma mark - 刷新～～
-(void)initHeader
{    //下拉刷新
    [self.tableV addHeaderWithTarget:self action:@selector(headRefresh) dateKey:nil];
    
    //上拉刷新
    [self.tableV addFooterWithTarget:self action:@selector(footRefresh)];
    //设置文字
    self.tableV.headerPullToRefreshText = @"下拉刷新";
    self.tableV.headerRefreshingText = @"正在刷新中";
    
    self.tableV.footerPullToRefreshText = @"上拉刷新";
    self.tableV.footerRefreshingText = @"正在刷新";
}
-(void)headRefresh
{
    if (self.isNUll) {
        self.meunm.reghtButton.text = @"全部";
        self.meunm.leftButton.text = @"不限";
        self.LeftselectedIndex = 0;
        self.RightselectedIndex = 0;
        
    }
//    self.pageIndex = 1;
    self.isHeadRefresh = YES;
    [self loadDataSuorceByCondition];
}
-(void)footRefresh
{
    self.pageIndex ++;
    self.isHeadRefresh = NO;
//    if (self.pageIndex < [self getEndPage]) {
//        [self loadDataSuorceByCondition];
//    }else{
//        [self.tableV footerEndRefreshing];
//    }
}

#pragma mark - 各种初始化～～
-(UITableView *)tableV
{
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -44) style:UITableViewStyleGrouped];
        _tableV.separatorInset = UIEdgeInsetsZero;
        _tableV.dataSource = self;
        _tableV.delegate = self;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:238/255.0 alpha:1];
    }
    return _tableV;
}
//筛选button
- (Menum *)meunm
{
    if (!_meunm) {
        _meunm = [[Menum alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
        _meunm.dalegate = self;
    }
    return _meunm;
}
//弹出框
- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];

        UITapGestureRecognizer *tapGestion = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMenum:)];
        
        tapGestion.delegate = self;
//        [self.view addGestureRecognizer:tapGestion];
        [self.coverView addGestureRecognizer:tapGestion];
    }
    return _coverView;
}
//初始化客户详情信息的弹出框
- (DetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[DetailView alloc] init];
        _detailView.center = self.view.window.center;
        _detailView.bounds = CGRectMake(0, 0, self.view.frame.size.width * 0.8, 272);
    }
    return _detailView;
}
#pragma mark - getter
- (NullContentView *)nullContentView
{
    if (!_nullContentView) {
        _nullContentView = [[NullContentView alloc] init];
        CGFloat viewW = self.view.frame.size.width;
        CGFloat viewH = self.tableV.frame.size.height - 54 - 50;
        CGFloat viewY = 50;
        _nullContentView.frame = CGRectMake(0, viewY, viewW, viewH);
        _nullContentView.hidden = YES;
        [self.tableV addSubview:_nullContentView];
    }
    return _nullContentView;
}
- (NSMutableArray *)dateSource{
    if (!_dateSource) {
        _dateSource = [NSMutableArray array];
    }
    return _dateSource;
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


#pragma mark - 手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.coverView) {
        return YES;
    }
    return NO;
    
}
#pragma mark - MenumDelegate
/**
 *  点击选择左菜单
 */
- (void)menumLiftButton:(UIButton *)LiftButton
{
    CGFloat menuX = self.view.frame.size.width * 0.25 - 30;
    CGRect frame = CGRectMake(menuX, 113, 135, 45 * 6);
    [self createMenuWithSelectedIndex:self.LeftselectedIndex frame:frame dataSource:self.chooseTime direct:0];
}

/**
 *  点击选择右菜单
 */
- (void)menumRightButton:(UIButton *)rightButton
{
    CGFloat menuX = self.view.frame.size.width * 0.75 + 30;
    CGRect frame = CGRectMake(menuX, 113, 135, 45 * 7);
    [self createMenuWithSelectedIndex:self.RightselectedIndex frame:frame dataSource:self.chooseStatus direct:1];
}

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
    }
    [self.coverView addSubview:self.qdmenu];
    
    [self.view.window addSubview:self.coverView];
}
/**
 *  选择弹出狂上的tableView的方法
 */
- (void)menu:(QDMenu *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isNUll = NO;
    if (menu.direct == 0) {// 时间筛选
        NSLog(@"vvvvv");
        NSString *title = menu.dataSource[indexPath.row][@"Text"];
        self.meunm.leftButton.text = title;
        
        self.choosedTime = menu.dataSource[indexPath.row][@"Value"];
        [self remove];
        self.LeftselectedIndex = indexPath.row;
        [self.tableV headerBeginRefreshing];
        
        
    }else{// 状态筛选
        NSString *title = menu.dataSource[indexPath.row][@"Text"];
        self.meunm.reghtButton.text = title;
        
        self.choosedStatus = menu.dataSource[indexPath.row][@"Value"];
        [self remove];
        self.RightselectedIndex = indexPath.row;
        
        [self.tableV headerBeginRefreshing];
    }
}

/**
 *  点击其他地方弹出框消失效果
 */
- (void)removeMenum:(UITapGestureRecognizer *)ges
{
    [self remove];
}
- (void)remove
{
    [_qdmenu removeFromSuperview];
    self.qdmenu = nil;
    self.qdmenu.delegate = nil;
    // 等待渐变动画执行完
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_coverView removeFromSuperview];
    });
}

//滑动cell走的方法
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

#pragma mark - tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dateSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderCell *cell = [OrderCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.orderDelegate = self;
    cell.indexPath = indexPath;
    
    OrderModel *order = self.dateSource[indexPath.section];
    cell.model = order;
    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    cell.rightButtons = [self createRightButtons: order];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
    OrderModel *model = self.dateSource[indexPath.section];
    orderDetailVC.url = model.DetailLinkUrl;
    NSLog(@"uel = %@", model.DetailLinkUrl);
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"CustomerOrderDetailProductClick" attributes:dict];


    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.mainNav pushViewController:orderDetailVC animated:YES];
//    [self presentViewController:orderDetailVC animated:YES completion:^{
//    }];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *order = self.dateSource[indexPath.section];
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - OrderCellDelegate 弹出框信息
- (void)checkDetailAtIndex:(NSInteger)index
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIView *cover = [[UIView alloc] initWithFrame:window.bounds];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [window addSubview:cover];
    [cover addSubview:self.detailView];
    // 取出模型
    OrderModel *order = self.dateSource[index];
    self.detailView.orderId = order.OrderId;
}

#pragma mark-立即采购页面跳转
- (void)clickImmediateOrder:(NSNotification *)noty
{
    NSString *url = noty.userInfo[@"linkUrl"];
    NSString *title = noty.userInfo[@"title"];
    ButtonDetailViewController *detail = [[ButtonDetailViewController alloc] init];
    detail.linkUrl = url;
    detail.title = title;
    [self.mainNav pushViewController:detail animated:YES];
}


#pragma mark-swipTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction
{
    if (direction == MGSwipeDirectionRightToLeft) {
        return YES;
    }
    return NO;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    return YES;
}

- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    return [NSArray array];
}


- (void)setNullImage
{
    self.nullContentView.hidden = self.dateSource.count;
    if (!self.nullContentView.hidden) {
        self.isNUll = YES;
        NSLog(@"rrrrrrrrrr  ");
        [self.nullContentView setNullContentIsSearch:self.dataIsNull];
    }
}


#pragma mark - 数据加载

//筛选数据加载
- (void)loadDataByCondition
{
    self.isNUll = NO;
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    NSDictionary *param = @{};
    [OrderTool getOrderConditionWithParam:param success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].delegate.window animated:YES];
        [self.chooseTime removeAllObjects];
        [self.chooseStatus removeAllObjects];
        if (json) {
            NSLog(@"json----%@",json);
            if ([json[@"IsSuccess"] integerValue] == 1) {
                
                for (NSDictionary *timeDic in json[@"DateRangList"]) {
                    [self.chooseTime addObject:timeDic];
                }
                NSLog(@"self.chooseTime = %@", self.chooseTime);
                
                for (NSDictionary *statusDic in json[@"StateList"]) {
                    [self.chooseStatus addObject:statusDic];
                }
                
                // 获取筛选条件后加载默认的列表
                [self.tableV headerBeginRefreshing];
            }
        }
    } failure:^(NSError *error) {
    }];
}

//tableview上数据的加载
- (void)loadDataSuorceByCondition
{   self.isNUll = NO;

    NSDictionary *param = @{@"CustomerID":self.customerId};
    NSLog(@"self.customer = %@", self.customerId);
//    NSDictionary *param = @{@"CustomerID":self.customerId,
//                            @"CreatedDateRang":self.choosedTime,
//                            @"State":self.choosedStatus};
    
    [OrderTool CustomgetOrderListWithParam:param success:^(id json) {
        [self.tableV headerEndRefreshing];
        [self.tableV footerEndRefreshing];
        if (json) {
            NSLog(@"aa------%@",json);
            //            dispatch_queue_t q = dispatch_queue_create("lidingd", DISPATCH_QUEUE_SERIAL);
            //            dispatch_async(q, ^{
            if (self.isHeadRefresh) {
                [self.dateSource removeAllObjects];
            }
            
            for (NSDictionary *dic in json[@"OrderList"]) {
                OrderModel *order = [OrderModel orderModelWithDict:dic];
                [self.dateSource addObject:order];
                //                      NSLog(@"self.dataSourse = %@", self.dateSource);
            }
            //                dispatch_async(dispatch_get_main_queue(), ^{
            if (self.dateSource.count == 0) {
                [self setNullImage];
                //                        NSLog(@"////////////////// %ld", self.dateSource.count);
            }
            
            [self.tableV reloadData];
            //                });
            //            });
        }
    } failure:^(NSError *error) {
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
