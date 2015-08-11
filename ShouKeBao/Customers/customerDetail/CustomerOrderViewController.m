//
//  CustomerOrderViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/6.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CustomerOrderViewController.h"
#import "OrderCell.h"

#import "Menum.h"
#import "ArrowBtn.h"
#import "MGSwipeButton.h"
#import "CantactView.h"
#import "UIScrollView+MJRefresh.h"
#import "QDMenu.h"
#import "NullContentView.h"

@interface CustomerOrderViewController ()<UITableViewDataSource, UITableViewDelegate, menumDelegate, QDMenuDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong)NSMutableArray * dateSource;
@property (nonatomic,strong) UITableView *tableV;

@property (nonatomic,assign) NSInteger LselectedIndex;
@property (nonatomic,assign) NSInteger RselectedIndex;
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


@end

@implementation CustomerOrderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:self.meunm];
    [self.view addSubview:self.tableV];

    self.tableView.sectionHeaderHeight = 0;
    self.view.backgroundColor = [UIColor whiteColor ];
    
    [self iniHeader];
    
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 刷新～～
-(void)iniHeader
{    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headRefresh) dateKey:nil];
    
    //上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(footRefresh)];
    //设置文字
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerRefreshingText = @"正在刷新中";
    
    self.tableView.footerPullToRefreshText = @"上拉刷新";
    self.tableView.footerRefreshingText = @"正在刷新";
}

-(void)headRefresh
{
    if (self.isNUll) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DressViewClickReset" object:nil];

        self.meunm.reghtButton.text = @"全部";
        self.meunm.leftButton.text = @"不限";
//        self.LselectedIndex = 0;
//        self.RselectedIndex = 0;
        
    }
//    self.pageIndex = 1;
//    self.isHeadRefresh = YES;
//    [self loadDataSuorceByCondition];
}
-(void)footRefresh
{
//    self.pageIndex ++;
//    self.isHeadRefresh = NO;
//    if (self.pageIndex < [self getEndPage]) {
//        [self loadDataSuorceByCondition];
//    }else{
//        [self.tableView footerEndRefreshing];
//    }
}

#pragma mark - 各种初始化～～
-(UITableView *)tableV
{
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height - 45-44) style:UITableViewStyleGrouped];
        _tableV.separatorInset = UIEdgeInsetsZero;
        _tableV.dataSource = self;
        _tableV.delegate = self;
//        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:238/255.0 alpha:1];
    }
    return _tableV;

}

- (Menum *)meunm
{
    if (!_meunm) {
        _meunm = [[Menum alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
        _meunm.dalegate = self;
    }
    return _meunm;
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


#pragma mark - MenumDelegate
/**
 *  点击选择左菜单
 */
- (void)menumLiftButton:(UIButton *)LiftButton
{
    CGFloat menuX = self.view.frame.size.width * 0.25 - 30;
    CGRect frame = CGRectMake(menuX, 153, 135, 45 * 6);
    [self createMenuWithSelectedIndex:self.LselectedIndex frame:frame dataSource:self.chooseTime direct:0];
}

/**
 *  点击选择右菜单
 */
- (void)menumRightButton:(UIButton *)rightButton
{
    CGFloat menuX = self.view.frame.size.width * 0.75 + 30;
    CGRect frame = CGRectMake(menuX, 153, 135, 45 * 7);
    [self createMenuWithSelectedIndex:self.RselectedIndex frame:frame dataSource:self.chooseStatus direct:1];
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
- (void)menu:(QDMenu *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.isNUll = NO;
    if (menu.direct == 0) {// 时间筛选
        NSLog(@"vvvvv");
//        NSString *title = menu.dataSource[indexPath.row][@"Text"];
//        self.meunm.leftButton.text = title;
//        
//        self.choosedTime = menu.dataSource[indexPath.row][@"Value"];
//        [self remove];
//        self.LselectedIndex = indexPath.row;
        [self.tableView headerBeginRefreshing];
        
        
    }else{// 状态筛选
//        NSString *title = menu.dataSource[indexPath.row][@"Text"];
//        self.meunm.reghtButton.text = title;
//        
//        self.choosedStatus = menu.dataSource[indexPath.row][@"Value"];
//        [self remove];
//        self.RselectedIndex = indexPath.row;
        
        [self.tableView headerBeginRefreshing];
    }
    
    
    
}


- (void)removeMenu:(UITapGestureRecognizer *)ges
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString * cellID = @"CustomerOrdercell";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
    
    OrderCell *cell = [OrderCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.orderDelegate = self;
    cell.indexPath = indexPath;
    

//    OrderModel *order = self.dateSource[indexPath.section];
//    cell.model = order;
//    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
//    cell.rightButtons = [self createRightButtons:order];
    

    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 172;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}


- (void)setNullImage
{
    
    self.nullContentView.hidden = self.dateSource.count;
    if (!self.nullContentView.hidden) {
        self.isNUll = YES;
//        [self.nullContentView setNullContentIsSearch:self.isSearch];
    }
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
