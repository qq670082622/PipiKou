//
//  RecommendViewController.m
//  ShouKeBao
//
//  Created by Richard on 15/4/10.
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
#import "ProduceDetailViewController.h"
#import "UIViewController+HUD.h"
#import "YYAnimationIndicator.h"
#import "WMAnimations.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"
#import "StrToDic.h"
#define pageSize @"11"

@interface RecommendViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate,UIScrollViewDelegate>

@property(nonatomic, assign)NSInteger number;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) BOOL isRefresh;

@property (nonatomic,copy) NSString *totalCount;
@property (nonatomic,strong) YYAnimationIndicator *indicator;
@property (nonatomic,strong) NSMutableDictionary *tagDic;
@property (nonatomic,assign) BOOL flag;
//@property (nonatomic,assign) BOOL change;
@end

@implementation RecommendViewController
-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"yincang" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    if (!self.isFromEmpty) {
//        [self.tagDic setObject:@"1" forKey:[def objectForKey:@"num"]];
//    }
    
    self.flag = YES;
    [self loadDataSource];
    NSString *st = [def objectForKey:@"markStr"];
    self.markUrl  = [def objectForKey:@"markStr"];
    
//    self.change = [def objectForKey:@"change"];
    
    NSLog(@"-----st is %@---markUrl is %@--------------",st,_markUrl);
    
//移除掉
    [def setObject:@"" forKey:@"markStr"];

//    [def setBool:NO forKey:@"change"];

    [def synchronize];
    
    
    
    self.title = @"今日推荐";
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pageIndex = 1;
    
    
    
    //下啦刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headRefresh) dateKey:nil];
    
    // 上啦加载更多
    [self.tableView addFooterWithTarget:self action:@selector(footRefresh)];
    
    //设置文字
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerRefreshingText = @"正在刷新中";
    self.tableView.footerPullToRefreshText = @"加载更多";
    self.tableView.footerRefreshingText = @"加载中";
    
    //  [self setNav];
    
    
    // 第一次加载的时候显示这个hud
    //  [self showHudInView:self.view hint:@"正在加载中"];
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
    
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [_indicator setLoadText:@"拼命加载中..."];
    [self.view addSubview:_indicator];
    [self.view bringSubviewToFront:_indicator];
    
    [_indicator startAnimation];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        
        [self.tableView reloadData];
        
    });
    
    //
    
}

- (void)scrollTableView
{
//    NSUserDefaults *mark = [NSUserDefaults standardUserDefaults];
//    NSString *num = [mark objectForKey:@"num"];
//    NSInteger number = [num integerValue];
//
//    NSLog(@"iii = %ld", number);
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.number inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
// 记得移除掉
//    [mark setObject:@"" forKey:@"num"];
//    [mark synchronize];
  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.tableView.scrollEnabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"yincang" object:self];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShouKeBaoRecommendView"];
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBaoTodayRecommend" attributes:dict];
    
    
    //
    
    
    
    self.view.window.backgroundColor = [UIColor clearColor];
    [self headRefresh];
    // [self setupHead];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaoRecommendView"];
    
}
#pragma mark - private
- (void)loadDataSource
{
    NSDictionary *param = @{@"PageSize":pageSize,
                            @"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                            @"DateRangeType":@"1"};
    //    NSDictionary *param = @{@"PageSize":pageSize,
    //                            @"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
    //                            @"DateRangeType":@"1"};
    
    [HomeHttpTool getRecommendProductListWithParam:param success:^(id json) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        // [self hideHud];
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
          
//根据id判断在前一页面点击进入的时候的产品 对应 这个界面数组里面的具体哪一个。来置顶
            for (NSInteger i = 0; i < self.dataSource.count; i++) {
                if ([((DayDetail *)self.dataSource[i]).PushId isEqualToString: _markUrl] && !self.isFromEmpty) {
                    [self.tagDic setObject:@"1" forKey:[NSString stringWithFormat:@"%ld", i]];
                    self.number = i;
                }}
    
            [self.tableView reloadData];
            [_indicator stopAnimationWithLoadText:@"加载完成" withType:YES];
            
        }
         NSLog(@"self.dataSource  %@",self.dataSource);
        //          [self scrollTableView];
        [self.tableView reloadData];
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

//- (void)setNav
//{
//    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//
//    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 40, 40)];
//    back.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
//    [back setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
//    [back addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
//    [cover addSubview:back];
//
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cover];
//}
//
//- (void)backToHome
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

//- (void)setupHead
//{
//    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    cover.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
//
//    // 选择分站按钮
//    UIButton *station = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 75, 30)];
//    station.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
//    [station setBackgroundImage:[UIImage imageNamed:@"dizhi"] forState:UIControlStateNormal];
//    [station addTarget:self action:@selector(selectStation:) forControlEvents:UIControlEventTouchUpInside];
//
//    // 取出储存的分站
//    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
//    NSString *subStationName = [udf stringForKey:@"SubstationName"];
//    [station setTitle:subStationName forState:UIControlStateNormal];
//    if (![subStationName isKindOfClass:[NSNull class]]) {
//        [station setTitle:@"上海" forState:UIControlStateNormal];
//    }
//
//    [station setTitleColor:[UIColor colorWithRed:91/255.0 green:155/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
//    station.titleLabel.font = [UIFont systemFontOfSize:12];
//    [cover addSubview:station];
//
//    // 搜索按钮
//    CGFloat searchX = CGRectGetMaxX(station.frame) + 5;
//    CGFloat searchW = self.view.frame.size.width - station.frame.size.width - 25;
//    UIButton *search = [[UIButton alloc] initWithFrame:CGRectMake(searchX, 5, searchW, 30)];
//    [search setBackgroundImage:[UIImage imageNamed:@"shousuochanpin"] forState:UIControlStateNormal];
//    [search setImage:[UIImage imageNamed:@"fdjBtn"] forState:UIControlStateNormal];
//    [search setTitle:@"查找产品" forState:UIControlStateNormal];
//    [search setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    search.titleLabel.font = [UIFont systemFontOfSize:12];
//    search.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    [search addTarget:self action:@selector(goSearch:) forControlEvents:UIControlEventTouchUpInside];
//    [cover addSubview:search];
//
//    [self.view addSubview:cover];
//}

//// 选择分站
//- (void)selectStation:(UIButton *)sender
//{
//    [self.navigationController pushViewController:[[StationSelect alloc] init] animated:YES];
//}
//
//// 搜索
//- (void)goSearch:(UIButton *)sender
//{
//    SearchProductViewController *searchVC = [[SearchProductViewController alloc] init];
//
//    [self.navigationController pushViewController:searchVC animated:YES];
//}

// 刷新列表
- (void)headRefresh
{
    self.isRefresh = YES;
    self.pageIndex = 1;
    [self loadDataSource];
}

// 加载更多
- (void)footRefresh
{
    self.isRefresh = NO;
    self.pageIndex ++;
    // if (self.pageIndex < [self getEndPage]) {
    [self loadDataSource];
    //}
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

-(NSMutableDictionary *)tagDic
{
    if (_tagDic == nil) {
        self.tagDic = [NSMutableDictionary dictionary];
    }
    return _tagDic;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 107)];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        //_tableView.rowHeight = 80;
        // _tableView.separatorInset = UIEdgeInsetsZero;
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
    
    DayDetailCell *cell = [DayDetailCell cellWithTableView:tableView withTag:indexPath.row];
    DayDetail *detail = self.dataSource[indexPath.row];
    cell.detail = detail;
    
    [cell.descripBtn setTag:indexPath.row];
    [cell.descripBtn addTarget:self action:@selector(changeHeight:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"_markUrl = %@", _markUrl);
    if ([detail.PushId isEqualToString:_markUrl]) {
        cell.isPlain = YES;
        [self.tagDic setObject:@"1" forKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
        [WMAnimations WMAnimationMakeBoarderNoCornerRadiosWithLayer:cell.contentView.layer andBorderColor:[UIColor colorWithRed:41/255.f green:147/255.f blue:250/255.f alpha:1] andBorderWidth:1 andNeedShadow:YES];
    NSLog(@"indexPath.row iii = %ld", indexPath.row);
        
        
    }
    
    //    if (indexPath.row == 2) {
    //        [WMAnimations WMAnimationMakeBoarderNoCornerRadiosWithLayer:cell.contentView.layer andBorderColor:[UIColor colorWithRed:13/255.f green:153/255.f blue:252/255.f alpha:1]  andBorderWidth:3 andNeedShadow:normal];
    //           }

    if (self.flag) {
        [self scrollTableView];
        self.flag = NO;
    }
    

    
    return cell;
}

-(void)changeHeight:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    NSString  *tag = [NSString stringWithFormat:@"%ld",(long)btn.tag];
            NSLog(@" ****  dddd  %@", tag);
    if ([[self.tagDic objectForKey:tag ] isEqualToString:@"1"]) {
        [self.tagDic setObject:@"0" forKey:tag];
    }else{
        [self.tagDic setObject:@"1" forKey:tag];
    }
    NSLog(@"666  %@", self.tagDic);
    [_tableView beginUpdates];
    [_tableView endUpdates];
    
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBaoTodayRecommendProductDetailClick" attributes:dict];
    
    DayDetail *detail = self.dataSource[indexPath.row];
    ProduceDetailViewController *web = [[ProduceDetailViewController alloc] init];
    web.shareInfo = detail.ShareInfo;
    web.detail = detail;
    web.fromType = FromRecommend;
    web.produceUrl = detail.LinkUrl;
    [self.navigationController pushViewController:web animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tag = [self.tagDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//        NSLog(@"222111111  %@", tag);
    if ([tag isEqualToString:@"1"]){
        return 330;
    }else{
        return 220;
    }
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
    NSDictionary *tmp2 = detail.shareInfo;
    NSMutableDictionary *tmp = [StrToDic dicCleanSpaceWithDict:tmp2];
    
    NSLog(@"------分享内容为%@-------------",tmp);
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:tmp[@"Desc"]
                                       defaultContent:tmp[@"Desc"]
                                                image:[ShareSDK imageWithUrl:tmp[@"Pic"]]
                                                title:tmp[@"Title"]
                                                  url:tmp[@"Url"]                                          description:tmp[@"Desc"]
                                            mediaType:SSPublishContentMediaTypeNews];
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", tmp[@"Url"]]];

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
                                    
                                    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                                    [MobClick event:@"RecommendShareSuccess" attributes:dict];
                                    [MobClick event:@"ShareSuccessAll" attributes:dict];
                                    [MobClick event:@"ShareSuccessAllJS" attributes:dict counter:3];

                                    [MobClick event:@"RecommendShareSuccessAll" attributes:dict];
                                    
                                    //近期推荐
                                    if (type == ShareTypeCopy) {
                                        [MBProgressHUD showSuccess:@"复制成功"];
                                    }else{
                                        [MBProgressHUD showSuccess:@"分享成功"];
                                    }
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                                        [MBProgressHUD hideHUD];
                                    });
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    
    [self addAlert];
    
    return YES;
}
-(void)addAlert
{
    
    
    // 获取到现在应用中存在几个window，ios是可以多窗口的
    
    NSArray *windowArray = [UIApplication sharedApplication].windows;
    
    // 取出最后一个，因为你点击分享时这个actionsheet（其实是一个window）才会添加
    
    UIWindow *actionWindow = (UIWindow *)[windowArray lastObject];
    
    // 以下就是不停的寻找子视图，修改要修改的
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat labY = 180;
    if (screenH == 667) {
        labY = 260;
    }else if (screenH == 568){
        labY = 160;
    }else if (screenH == 480){
        labY = 180;
    }else if (screenH == 736){
        labY = 440;
    }
    
    CGFloat labW = self.view.bounds.size.width;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, labY, labW, 30)];
    lab.text = @"您分享出去的内容对外只显示门市价";
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [actionWindow addSubview:lab];
    });
    
}


@end
