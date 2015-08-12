//
//  YesterdayViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "YesterdayViewController.h"
#import "YesterDayCell.h"
#import "HomeHttpTool.h"
#import "RecommendViewController.h"
#import "MJRefresh.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "ProduceDetailViewController.h"
#import "UIViewController+HUD.h"
#import "YYAnimationIndicator.h"
#import "WMAnimations.h"
#import "MobClick.h"
#import "StationSelect.h"
#import "BaseClickAttribute.h"

#import "DayDetailCell.h"
#import "DetailView.h"
#import "DayDetail.h"
#define pageSize @"12"
@interface YesterdayViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger t;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) BOOL isRefresh;
@property (nonatomic,copy) NSString *totalCount;
@property (nonatomic,strong) YYAnimationIndicator *indicator;

@property (nonatomic, strong)NSIndexPath *index;
@property (nonatomic, assign)BOOL flag;
@property (nonatomic,strong) NSMutableDictionary *tagDiction;


@end

@implementation YesterdayViewController
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"yincang" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.flag = YES;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (!self.isFromEmpty) {
        [self.tagDic setObject:@"1" forKey:[def objectForKey:@"num"]];
    }
    
    NSString *st = [def objectForKey:@"markYesterday"];
    self.markUrl  = [def objectForKey:@"markYesterday"];
    NSLog(@"-----st is %@---markUrl is %@--------------",st,_markUrl);    
    [def setObject:@"" forKey:@"markYesterday"];
    [def synchronize];
    
    self.table.tableFooterView = [[UIView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.table.delegate = self;
    self.pageIndex = 1;
    t = 0;
    
    //下啦刷新
    [self.table addHeaderWithTarget:self action:@selector(headRefresh) dateKey:nil];
    
    // 上啦加载更多
    [self.table addFooterWithTarget:self action:@selector(footRefresh)];
    
    //设置文字
    self.table.headerPullToRefreshText = @"下拉刷新";
    self.table.headerRefreshingText = @"正在刷新中";
    self.table.footerPullToRefreshText = @"加载更多";
    self.table.footerRefreshingText = @"加载中";
    
    //  [self setNav];
    
    [self loadDataSource];
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
        [self.table reloadData];

    });

    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShouKeBaoYesterdayView"];
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBaoYesterdayRecommend" attributes:dict];

    self.view.window.backgroundColor = [UIColor clearColor];
    [self headRefresh];
    // [self setupHead];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaoYesterdayView"];

}
#pragma mark - private
- (void)loadDataSource
{
    NSDictionary *param = @{@"PageSize":pageSize,
                            @"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                            @"DateRangeType":@"2"};
    [HomeHttpTool getRecommendProductListWithParam:param success:^(id json) {
        
        [self.table headerEndRefreshing];
        [self.table footerEndRefreshing];
        // [self hideHud];
//        NSLog(@"jjjjj  json = %@", json);
        if (json) {
            NSLog(@"....aaaaaaaa  %@",json);
            self.totalCount = json[@"TotalCount"];
            if (self.isRefresh) {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in json[@"ProductList"]) {
                DayDetail *detail = [DayDetail dayDetailWithDict:dic];
       
                [self.dataArr addObject:detail];
                
            }
            [self.table reloadData];
            [_indicator stopAnimationWithLoadText:@"加载完成" withType:YES];
            NSLog(@"self.dataArr aaaaaaaa  %@",self.dataArr);
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
 [[NSNotificationCenter defaultCenter] postNotificationName:@"yincang" object:self];
    
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

- (void)scrollTableView
{
    NSUserDefaults *mark = [NSUserDefaults standardUserDefaults];
    NSString *num = [mark objectForKey:@"num"];
    NSInteger number = [num integerValue];
    self.index = [NSIndexPath indexPathForRow:number inSection:0];
 
    [self.table scrollToRowAtIndexPath:self.index atScrollPosition:UITableViewScrollPositionTop animated:NO];
    self.table.scrollEnabled = YES;
    [mark setObject:@"" forKey:@"num"];
    [mark synchronize];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableDictionary *)tagDic
{
    if (_tagDiction == nil) {
        self.tagDiction = [NSMutableDictionary dictionary];
    }
    return _tagDiction;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

//    YesterDayCell *cell = [YesterDayCell cellWithTableView:tableView];
//    cell.modal = self.dataArr[indexPath.row];
//
//    NSLog(@"---- push = %@, mark = %@", cell.modal.PushId, _markUrl);

    DayDetailCell *cell = [DayDetailCell cellWithTableView:tableView withTag:indexPath.row];
    DayDetail *detail = (DayDetail *)self.dataArr[indexPath.row];
    cell.detail = detail;
    
    [cell.descripBtn setTag:indexPath.row];
    [cell.descripBtn addTarget:self action:@selector(changeHeight:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([detail.PushId isEqualToString:_markUrl]) {
        cell.isPlain = YES;
        [self.tagDiction setObject:@"1" forKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
        [WMAnimations WMAnimationMakeBoarderNoCornerRadiosWithLayer:cell.contentView.layer andBorderColor:[UIColor colorWithRed:41/255.f green:147/255.f blue:250/255.f alpha:1] andBorderWidth:1 andNeedShadow:YES];
        NSLog(@"indexPath.row iii = %ld", indexPath.row);
        
        
    }
//
    
    
//    if ([cell.modal.PushId isEqualToString: _markUrl]) {
//    
//        [WMAnimations WMAnimationMakeBoarderNoCornerRadiosWithLayer:cell.contentView.layer andBorderColor:[UIColor colorWithRed:41/255.f green:147/255.f blue:250/255.f alpha:1] andBorderWidth:1 andNeedShadow:YES];
//        
//        NSLog(@"++++ push = %@, mark = %@", cell.modal.PushId, _markUrl);
//    }
    
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
    
    if ([[self.tagDic objectForKey:tag ] isEqualToString:@"1"]) {
        [self.tagDic setObject:@"0" forKey:tag];
    }else{
        [self.tagDic setObject:@"1" forKey:tag];}
    [_table beginUpdates];
    [_table endUpdates];
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.row);
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBaoYesterdayRecommendProductDetailClick" attributes:dict];
    
    yesterDayModel *detail = self.dataArr[indexPath.row];
    ProduceDetailViewController *web = [[ProduceDetailViewController alloc] init];
    web.detail2  = detail;
    web.m = t;
    NSLog(@"+++%ld",web.m);
    web.fromType = FromRecommend;
    web.produceUrl = detail.LinkUrl;
    [self.navigationController pushViewController:web animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *tag = [self.tagDiction objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row] ];
    if ([tag isEqualToString:@"1"]){
        return 330;
    }else{
        return 220;
    }
}

@end
