//
//  ProductRecommendViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ProductRecommendViewController.h"
#import "StationSelect.h"
#import "SearchProductViewController.h"
#import "ProduceDetailViewController.h"
#import "WMAnimations.h"
#import "MobClick.h"
#import "HomeHttpTool.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "MJRefresh.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "DayDetail.h"
#import "DayDetailCell.h"
#import "YesterDayCell.h"
#import "RecentlyCell.h"
#define pageSize @"11"
#define  K_TableWidth [UIScreen mainScreen].bounds.size.width
//整个屏幕的高度减去导航栏和按钮的高度
#define K_TableHeight [UIScreen mainScreen].bounds.size.height - 107
@interface ProductRecommendViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,notifi>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *LineWeith;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (strong, nonatomic) IBOutlet UIView *topLine;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;//承载三个tableView的主scrollview
@property (nonatomic, strong)UIView * recentlyHeaderView;
//今日推荐
@property (strong, nonatomic) IBOutlet UIButton *todayBtn;
- (IBAction)todayBtnAction:(id)sender;
//昨日推荐
@property (strong, nonatomic) IBOutlet UIButton *yestodayBtn;
- (IBAction)yestodayBtnAction:(id)sender;
//近期推荐
@property (strong, nonatomic) IBOutlet UIButton *recentlyBtn;
- (IBAction)recentlyBtnAction:(id)sender;
@property (nonatomic, strong)UITableView * todayTableView;
@property (nonatomic, strong)UITableView * yestdayTableView;
@property (nonatomic, strong)UITableView * recentlyTableView;
@property (nonatomic, assign)NSInteger TPageNum;
@property (nonatomic, assign)NSInteger YPageNum;
@property (nonatomic, assign)NSInteger RPageNum;
@property (nonatomic, strong)NSMutableArray * todayDataArray;
@property (nonatomic, strong)NSMutableArray * yestdayDataArray;
@property (nonatomic, strong)NSMutableArray * recentlyDataArray;
@property (nonatomic, assign)NSString * totalCount;
@property (nonatomic, strong)NSMutableDictionary * todayTagDic;
@property (nonatomic, strong)NSMutableDictionary * yestdayTagDic;
@property (nonatomic, assign)BOOL justDoOnce;
@property (nonatomic, copy)NSString * selectIndex;
@property (nonatomic, strong)UIButton * timeOrderBtn;
@property (nonatomic, strong)UIButton * priceOrderBtn;
@property (nonatomic, strong)UIView * moreBtnShowView;
@property (nonatomic,copy)NSString *stationName;//分站名字
@property (nonatomic)UIButton *stationBtn;//分站按钮
@end

@implementation ProductRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日推荐";
    self.justDoOnce = YES;
    self.selectIndex = @"2";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setScrollView];
    [self setRightItemBtn];
    self.LineWeith.constant = K_TableWidth / 3;
    self.scrollHeight.constant = K_TableHeight;
    [self loadNewData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShouKeBaoRecomView"];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    self.stationName = [def objectForKey:@"SubstationName"];
    [self.stationBtn setTitle:[NSString stringWithFormat:@"切换分站(%@)",self.stationName]  forState:UIControlStateNormal];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaoRecomView"];
}

//重写左滑手势
- (void)addGest{
    UIScreenEdgePanGestureRecognizer *screenEdge = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreen:)];
    screenEdge.edges = UIRectEdgeLeft;
    [self.mainScrollView addGestureRecognizer:screenEdge];
}
-(void)handleScreen:(UIScreenEdgePanGestureRecognizer *)sender{
    CGPoint sliderdistance = [sender translationInView:self.view];
    if (sliderdistance.x>self.view.bounds.size.width/3) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - begaininit界面初始设置
//设置tableview
- (void)setTableViewDelegate:(UITableView*)tableView{
    //设置代理
    tableView.delegate = self;
    tableView.dataSource = self;
    //下啦刷新
    [tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    // 上啦加载更多
    [tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    //设置文字
    tableView.headerPullToRefreshText = @"下拉刷新";
    tableView.headerRefreshingText = @"正在刷新中";
    tableView.footerPullToRefreshText = @"加载更多";
    tableView.footerRefreshingText = @"加载中";
    tableView.rowHeight = 800;
}
//设置scrollview
- (void)setScrollView{
    self.mainScrollView.contentSize = CGSizeMake(K_TableWidth * 3, K_TableHeight);
    self.mainScrollView.tag = 621;
    self.mainScrollView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.mainScrollView addSubview:self.todayTableView];
    [self.mainScrollView addSubview:self.yestdayTableView];
    //添加近期推荐的button头视图
    [self.mainScrollView addSubview:self.recentlyHeaderView];
    [self.mainScrollView addSubview:self.recentlyTableView];
}
- (void)setRightItemBtn{
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    moreBtn.frame = CGRectMake(0, 0, 21, 7);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"gengduoann"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    self.navigationItem.rightBarButtonItem = moreItem;
    [self.view addSubview:self.moreBtnShowView];
}
#pragma mark - loadData
-(void)loadNewData{
    if ([self.title isEqualToString:@"今日推荐"]) {
        self.TPageNum = 1;
        [self loadDataSourceWith:self.todayTableView with:self.TPageNum with:self.todayDataArray];
    }else if([self.title isEqualToString:@"昨日推荐"]){
        self.YPageNum = 1;
        [self loadDataSourceWith:self.yestdayTableView with:self.YPageNum with:self.yestdayDataArray];
    }else{
        self.RPageNum = 1;
        [self loadDataSourceWith:self.recentlyTableView with:self.RPageNum with:self.recentlyDataArray];
    }
}
-(void)loadMoreData{
    if ([self.title isEqualToString:@"今日推荐"]) {
        self.TPageNum++;
        [self loadDataSourceWith:self.todayTableView with:self.TPageNum with:self.todayDataArray];
    }else if([self.title isEqualToString:@"昨日推荐"]){
        self.YPageNum++;
        [self loadDataSourceWith:self.yestdayTableView with:self.YPageNum with:self.yestdayDataArray];
    }else{
        self.RPageNum++;
        [self loadDataSourceWith:self.recentlyTableView with:self.RPageNum with:self.recentlyDataArray];
    }
}
- (void)loadDataSourceWith:(UITableView *)tableView
                      with:(NSInteger)pageNum
                      with:(NSMutableArray *)dataArray
{
    //根据不同的tableview加载不同的数据;
    NSDictionary *param = @{};
    NSMutableDictionary * currentTagDic;
    if ([tableView isEqual:self.todayTableView]) {
        param = @{@"PageSize":pageSize,
                                @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageNum],
                                @"DateRangeType":@"1"};
        currentTagDic = self.todayTagDic;
    }else if([tableView isEqual:self.yestdayTableView]){
        param = @{@"PageSize":pageSize,
                  @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageNum],
                  @"DateRangeType":@"2"};
        currentTagDic = self.yestdayTagDic;
    }else{
        param = @{@"PageSize":pageSize,
                  @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageNum],
                  @"DateRangeType":@"3",
                  @"SortType":self.selectIndex};
    }
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"加载中...";
    [hudView show:YES];
    [HomeHttpTool getRecommendProductListWithParam:param success:^(id json) {
        [tableView headerEndRefreshing];
        [tableView footerEndRefreshing];
        if (json) {
            [hudView hide:YES];
            NSLog(@"aaaaaaaa  %@",json);
            self.totalCount = json[@"TotalCount"];
            if ([json[@"ProductList"]count] == 0&&self.TPageNum == 1&&tableView.tag!=2015) {
                [self.mainScrollView setContentOffset:CGPointMake(K_TableWidth, 0) animated:NO];
                self.topLine.frame = CGRectMake(self.mainScrollView.contentOffset.x/3, self.topLine.frame.origin.y, self.topLine.frame.size.width, 3);
            }
            if (pageNum == 1) {
                [dataArray removeAllObjects];
            }
            for (NSDictionary *dic in json[@"ProductList"]) {
                    DayDetail *detail = [DayDetail dayDetailWithDict:dic];
                    [dataArray addObject:detail];
                NSLog(@"%@%@", dataArray, detail.PersonAlternateCash);
            }
            //根据id判断在前一页面点击进入的时候的产品 对应 这个界面数组里面的具体哪一个。来置顶
            for (NSInteger i = 0; i < dataArray.count; i++) {
                if ([((DayDetail *)dataArray[i]).PushId isEqualToString: self.pushId]) {
                    [currentTagDic setObject:@"1" forKey:[NSString stringWithFormat:@"%ld", (long)i]];
                    self.pushIdNum = i;
                }
            }
            [tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - LazyLoading
-(UITableView *)todayTableView{
    if (!_todayTableView) {
        _todayTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_TableWidth, K_TableHeight)];
        _todayTableView.tag = 2013;
        [self setTableViewDelegate:_todayTableView];
    }
    return _todayTableView;
}
-(UITableView *)yestdayTableView{
    if (!_yestdayTableView) {
        _yestdayTableView = [[UITableView alloc]initWithFrame:CGRectMake(K_TableWidth, 0, K_TableWidth, K_TableHeight)];
        _yestdayTableView.tag = 2014;
        [self setTableViewDelegate:_yestdayTableView];

    }
    return _yestdayTableView;
}
-(UITableView *)recentlyTableView{
    if (!_recentlyTableView) {
        _recentlyTableView = [[UITableView alloc]initWithFrame:CGRectMake(K_TableWidth * 2, 40, K_TableWidth, K_TableHeight - 40)];
        _recentlyTableView.tag = 2015;
        [self setTableViewDelegate:_recentlyTableView];
    }
    return _recentlyTableView;
}
-(NSMutableArray *)todayDataArray{
    if (!_todayDataArray) {
        _todayDataArray = [NSMutableArray array];
    }
    return _todayDataArray;
}
-(NSMutableArray *)yestdayDataArray{
    if (!_yestdayDataArray) {
        _yestdayDataArray = [NSMutableArray array];
    }
    return _yestdayDataArray;
}
-(NSMutableArray *)recentlyDataArray{
    if (!_recentlyDataArray) {
        _recentlyDataArray = [NSMutableArray array];
    }
    return _recentlyDataArray;
}
-(NSMutableDictionary *)todayTagDic{
    if (!_todayTagDic) {
        _todayTagDic = [NSMutableDictionary dictionary];
    }
    return _todayTagDic;
}
-(NSMutableDictionary *)yestdayTagDic{
    if (!_yestdayTagDic) {
        _yestdayTagDic = [NSMutableDictionary dictionary];
    }
    return _yestdayTagDic;
}
-(UIView *)recentlyHeaderView{
    if (!_recentlyHeaderView) {
        _recentlyHeaderView = [[UIView alloc]initWithFrame:CGRectMake(K_TableWidth * 2, 0, K_TableWidth, 35)];
        _recentlyHeaderView.backgroundColor = [UIColor whiteColor];
        UIView * middleLine = [[UIView alloc]initWithFrame:CGRectMake(K_TableWidth / 2 - 0.5, 4.5, 1, 26)];
        middleLine.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        [_recentlyHeaderView addSubview:middleLine];
        [_recentlyHeaderView addSubview:self.timeOrderBtn];
        [_recentlyHeaderView addSubview:self.priceOrderBtn];
    }
    return _recentlyHeaderView;
}
-(UIButton *)timeOrderBtn{
    if (!_timeOrderBtn) {
        _timeOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeOrderBtn setTitle:@"时间↓" forState:UIControlStateNormal];
        [_timeOrderBtn addTarget:self action:@selector(timeAction:) forControlEvents:UIControlEventTouchUpInside];
        _timeOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _timeOrderBtn.frame = CGRectMake(0, 0, K_TableWidth/2 - 1, 35);
        _timeOrderBtn.backgroundColor = [UIColor whiteColor];
        [_timeOrderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_timeOrderBtn  setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        //初始的时候，让button默认选中状态
        [_timeOrderBtn setSelected:YES];

    }
    return _timeOrderBtn;
}
-(UIButton *)priceOrderBtn{
    if (!_priceOrderBtn) {
        _priceOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_priceOrderBtn setTitle:@"价格↓" forState:UIControlStateNormal];
        [_priceOrderBtn addTarget:self action:@selector(priceAction:) forControlEvents:UIControlEventTouchUpInside];
        _priceOrderBtn.frame = CGRectMake(K_TableWidth/2 + 1, 0, K_TableWidth/2 - 1, 35);
        _priceOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _priceOrderBtn.backgroundColor = [UIColor whiteColor];
        [_priceOrderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_priceOrderBtn  setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    }
    return _priceOrderBtn;
}
-(UIView *)moreBtnShowView{
    if (!_moreBtnShowView) {
        self.moreBtnShowView = [[UIView alloc] initWithFrame:CGRectMake(K_TableWidth-140, 0, 130, 68)];
        self.moreBtnShowView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lansedia"]];
        self.stationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.stationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.stationBtn.frame = CGRectMake(40, 5, 100, 30);
        [self.stationBtn addTarget:self action:@selector(changeStation) forControlEvents:UIControlEventTouchUpInside];
        [self.stationBtn setImage:[UIImage imageNamed:@"qiehuana"] forState:UIControlStateNormal];
        self.stationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 10);
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        self.stationName = [def objectForKey:@"SubstationName"];
        [self.stationBtn setTitle:[NSString stringWithFormat:@"切换分站(%@)",self.stationName]  forState:UIControlStateNormal];
        self.stationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 10);
        [self.stationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame = CGRectMake(40, 40, 80, 30);
        //[searchBtn setContentMode:UIViewContentModeScaleAspectFill]fdjForNav;
        [searchBtn setImage:[UIImage imageNamed:@"bigsousuo"] forState:UIControlStateNormal];
        searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -59, 0, 10);
        [searchBtn setTitle:@"查找产品" forState:UIControlStateNormal];
        searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 10);
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [self.moreBtnShowView addSubview:searchBtn];
        [self.moreBtnShowView addSubview:self.stationBtn];
        self.moreBtnShowView.alpha = 0;
        self.moreBtnShowView.hidden = YES;
    }
    return _moreBtnShowView;
}
#pragma mark - TopBtnActon
- (IBAction)todayBtnAction:(id)sender {
    [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (IBAction)yestodayBtnAction:(id)sender {
    [self.mainScrollView setContentOffset:CGPointMake(K_TableWidth, 0) animated:YES];
}
- (IBAction)recentlyBtnAction:(id)sender {
    [self.mainScrollView setContentOffset:CGPointMake(K_TableWidth * 2, 0) animated:YES];
}
#pragma mark - recentBtnAction
- (void)timeAction:(id)sender {
    [self.recentlyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.priceOrderBtn setSelected:NO];
    if (_timeOrderBtn.selected == YES && [_timeOrderBtn.titleLabel.text isEqualToString:@"时间↓"]) {
        [self.timeOrderBtn setTitle:@"时间↑" forState:UIControlStateNormal];
        self.selectIndex = @"1";
        
    }else if( _timeOrderBtn.selected == YES && [_timeOrderBtn.titleLabel.text isEqualToString:@"时间↑"]){
        
        [self.timeOrderBtn setTitle:@"时间↓" forState:UIControlStateNormal];
        self.selectIndex = @"2";
    }
    
    else if (_timeOrderBtn.selected == NO){
        
        [self.timeOrderBtn setSelected:YES];
        if ([_timeOrderBtn.titleLabel.text isEqualToString:@"时间↑"]) {
            self.selectIndex = @"1";
        }else{
            self.selectIndex = @"2";
        }
    }
    [self loadNewData];
}
- (void)priceAction:(id)sender {
    [self.recentlyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [_timeOrderBtn setSelected:NO];
    
    if (_priceOrderBtn.selected == YES && [_priceOrderBtn.titleLabel.text isEqualToString:@"价格↓"]) {
        [self.priceOrderBtn setTitle:@"价格↑" forState:UIControlStateNormal];
        self.selectIndex = @"3";
    }else if(_priceOrderBtn.selected == YES && [_priceOrderBtn.titleLabel.text isEqualToString:@"价格↑"]){
        [self.priceOrderBtn setTitle:@"价格↓" forState:UIControlStateNormal];
        self.selectIndex = @"4";
    }
    else if (_priceOrderBtn.selected == NO){
        [self.priceOrderBtn setSelected:YES];
        if ([_priceOrderBtn.titleLabel.text isEqualToString:@"价格↑"]) {
            self.selectIndex = @"3";
        }else{
            self.selectIndex = @"4";
        }
    }
    [self loadNewData];
}
#pragma mark - rightBtnClickAction
//此处 添加 动画效果
-(void)clickMoreBtn
{
    if (self.moreBtnShowView.hidden == YES) {
        [UIView animateWithDuration:0.6 animations:^{
            self.moreBtnShowView.alpha = 1;
            self.moreBtnShowView.hidden = NO;
        }];
    }else if (self.moreBtnShowView.hidden == NO){
        [UIView animateWithDuration:0.6 animations:^{
            self.moreBtnShowView.alpha = 0;
            self.moreBtnShowView.hidden = YES;
        }];
        
    }
}
-(void)changeStation
{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"RecommendChangeStationClick" attributes:dict];
    self.moreBtnShowView.alpha = 0;
    self.moreBtnShowView.hidden = YES;
    StationSelect * station =[[StationSelect alloc] init];
    station.delegate = self;
    [self.navigationController pushViewController:station animated:YES];
}

#pragma mark - 实现切换分站刷新界面的代理
-(void)notifiToReloadData{
    //self.stationName = stationName;
    //NSLog(@"%@",stationName);
    //[self.stationBtn setTitle:[NSString stringWithFormat:@"切换分站(%@)",self.stationName]  forState:UIControlStateNormal];
    [self loadNewData];
    
}
-(void)searchAction
{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"RecommendSearchClick" attributes:dict];
    self.moreBtnShowView.alpha = 0;
    self.moreBtnShowView.hidden = YES ;
    [self.navigationController pushViewController:[[SearchProductViewController alloc] init] animated:YES];
}

#pragma mark - tavleviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 2013) {
        return self.todayDataArray.count;
    }else if(tableView.tag == 2014){
        return self.yestdayDataArray.count;
    }else if(tableView.tag == 2015){
        return self.recentlyDataArray.count;
    }else{
        return 0;
    }
}
-(void)changeHeight:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSMutableDictionary * currentTagDic;
    if ([self.title isEqualToString:@"今日推荐"]) {
        currentTagDic = self.todayTagDic;
    }else{
        currentTagDic = self.yestdayTagDic;
    }
    if ([btn.titleLabel.text isEqualToString:@"全文"]) {
        [currentTagDic setObject:@"1" forKey:[NSString stringWithFormat:@"%ld", (long)btn.tag]];
    }else{
        [currentTagDic setObject:@"0" forKey:[NSString stringWithFormat:@"%ld", (long)btn.tag]];
    }
    [_todayTableView beginUpdates];
    [_todayTableView endUpdates];
    [_yestdayTableView beginUpdates];
    [_yestdayTableView endUpdates];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray * currentArray;
    self.moreBtnShowView.alpha = 0;
    self.moreBtnShowView.hidden = YES;
    if (tableView.tag == 2013) {
        currentArray = self.todayDataArray;
    }else if(tableView.tag == 2014){
        currentArray = self.yestdayDataArray;
    }else{
        currentArray = self.recentlyDataArray;
    }
    DayDetail *detail = currentArray[indexPath.row];
    ProduceDetailViewController *web = [[ProduceDetailViewController alloc] init];
    web.produceUrl = detail.LinkUrl;
    web.shareInfo = detail.ShareInfo;
    NSLog(@"%@", web.shareInfo);
    web.fromType = FromRecommend;
    [self.navigationController pushViewController:web animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    NSString * tag;
    if (tableView.tag == 2013) {
        tag = [self.todayTagDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        DayDetail * model = self.todayDataArray[indexPath.row];
        if ([model.AdvertText isEqualToString:@""]) {
            return 160;
        }
        height = [self heihtofContensStr:model.AdvertText sysFont:13];
    }else if(tableView.tag == 2014){
        tag = [self.yestdayTagDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        DayDetail * model = self.yestdayDataArray[indexPath.row];
        if ([model.AdvertText isEqualToString:@""]) {
            return 160;
        }
        height = [self heihtofContensStr:model.AdvertText sysFont:13];
    }else{
        return 160;
    }
    if ([tag isEqualToString:@"1"]) {
        return 200 + height;
    }else{
        return 220;
    }
}

- (CGFloat)heihtofContensStr:(NSString *)str
                     sysFont:(CGFloat)font{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil];
    CGRect rect = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2013 || tableView.tag == 2014) {
        DayDetailCell *cell = [DayDetailCell cellWithTableView:tableView withTag:indexPath.row];
        DayDetail * detail;
        if (tableView.tag == 2013) {
            detail = self.todayDataArray[indexPath.row];
        }else{
            detail= self.yestdayDataArray[indexPath.row];
        }
        //当详细介绍的软文为空的时候，另一种布局
        if ([detail.AdvertText isEqualToString:@""]) {
            YesterDayCell *cell = [YesterDayCell cellWithTableView:tableView];
            cell.modal = detail;
            return cell;
        }
        [cell.descripBtn addTarget:self action:@selector(changeHeight:) forControlEvents:UIControlEventTouchUpInside];
        cell.descripBtn.tag = indexPath.row;
        cell.detail = detail;
        if ([self.pushId isEqualToString:detail.PushId]) {
            cell.isPlain = YES;
            [cell.descripBtn setTitle:@"收起" forState:UIControlStateNormal];
            [self.todayTagDic setObject:@"1" forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
            [WMAnimations WMAnimationMakeBoarderNoCornerRadiosWithLayer:cell.contentView.layer andBorderColor:[UIColor colorWithRed:41/255.f green:147/255.f blue:250/255.f alpha:1] andBorderWidth:1 andNeedShadow:YES];
        }
        if (self.justDoOnce) {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.pushIdNum inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            self.justDoOnce = NO;
        }
        return cell;
    }else{
        YesterDayCell *cell = [YesterDayCell cellWithTableView:tableView];
        cell.modal = self.recentlyDataArray[indexPath.row];
        return cell;
    }
}
#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 621) {
    //线的移动
    self.topLine.frame = CGRectMake(scrollView.contentOffset.x/3, self.topLine.frame.origin.y, self.topLine.frame.size.width, 3);
    if (scrollView.contentOffset.x > K_TableWidth / 2&&scrollView.contentOffset.x<K_TableWidth*3/2) {
        self.title = @"昨日推荐";
        if (scrollView.contentOffset.x == K_TableWidth&&self.yestdayDataArray.count == 0) {
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"ShouKeBaoYesterdayRecommend" attributes:dict];
            [self loadNewData];
        }
    }else if(scrollView.contentOffset.x< K_TableWidth/2){
        self.title = @"今日推荐";
        if (scrollView.contentOffset.x == 0) {
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"ShouKeBaoTodayRecommend" attributes:dict];
        }
    }else{
        self.title = @"近期推荐";
        if (scrollView.contentOffset.x == 2*K_TableWidth&&self.recentlyDataArray.count == 0) {
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"ShouKeBaoRecentlyRecommend" attributes:dict];
            [self loadNewData];
        }
    }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.moreBtnShowView.alpha = 0;
    self.moreBtnShowView.hidden = YES;
}
@end
