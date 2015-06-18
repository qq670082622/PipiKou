//
//  RecentlyViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "RecentlyViewController.h"
#import "RecentlyCell.h"
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
#define pageSize @"10"

@interface RecentlyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
- (IBAction)timeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
- (IBAction)priceAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) BOOL isRefresh;

@property (nonatomic,copy) NSString *totalCount;
@property (nonatomic,strong) YYAnimationIndicator *indicator;

@end
//↓近到远，高到低 ↑远到近，低到高
@implementation RecentlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.timeBtn setSelected:YES];
    
    self.table.tableFooterView = [[UIView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.pageIndex = 1;
    
    
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
    
    
    // 第一次加载的时候显示这个hud
    //  [self showHudInView:self.view hint:@"正在加载中"];
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
    
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [_indicator setLoadText:@"拼命加载中..."];
    [self.view addSubview:_indicator];
    [self.view bringSubviewToFront:_indicator];
    
    [_indicator startAnimation];
    
    [self loadDataSource];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        [self.table reloadData];
        
    });
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.window.backgroundColor = [UIColor clearColor];
    
    // [self setupHead];
    
    
}

#pragma mark - private
- (void)loadDataSource
{
    NSDictionary *param = @{@"PageSize":pageSize,
                            @"PageIndex":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                            @"DateRangeType":@"3"};
    [HomeHttpTool getRecommendProductListWithParam:param success:^(id json) {
        [self.table headerEndRefreshing];
        [self.table footerEndRefreshing];
        // [self hideHud];
        if (json) {
            NSLog(@"aaaaaaaa  %@",json);
            self.totalCount = json[@"TotalCount"];
            if (self.isRefresh) {
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in json[@"ProductList"]) {
                recentlyModel *model = [recentlyModel modalWithDict:dic];
                [self.dataArr addObject:model];
            }
            [self.table reloadData];
          
            [_indicator stopAnimationWithLoadText:@"加载完成" withType:YES];
            
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
    if (self.pageIndex < [self getEndPage]) {
        [self loadDataSource];
    }
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




- (IBAction)timeAction:(id)sender {
    [self.priceBtn setSelected:NO];
   

    if (_timeBtn.selected == YES && [_timeBtn.titleLabel.text isEqualToString:@"时间↓"]) {
        
        [self.timeBtn setTitle:@"时间↑" forState:UIControlStateNormal];
        
    }else if( _timeBtn.selected == YES && [_timeBtn.titleLabel.text isEqualToString:@"时间↑"]){
       
        [self.timeBtn setTitle:@"时间↓" forState:UIControlStateNormal];
            
        }

    else if (_timeBtn.selected == NO){
      
        [self.timeBtn setSelected:YES];
        
    }
   }
//@"时间↓" @"价格↓" @"时间↑" @"价格↑"
- (IBAction)priceAction:(id)sender {
    
    [_timeBtn setSelected:NO];
    
    if (_priceBtn.selected == YES && [_priceBtn.titleLabel.text isEqualToString:@"价格↓"]) {
        
                   [self.priceBtn setTitle:@"价格↑" forState:UIControlStateNormal];
    }else if(_priceBtn.selected == YES && [_priceBtn.titleLabel.text isEqualToString:@"价格↑"]){
        
        [self.priceBtn setTitle:@"价格↓" forState:UIControlStateNormal];
        }
    else if (_priceBtn.selected == NO){
        
        [self.priceBtn setSelected:YES];

    }
    
  
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YesterDayCell *cell = [YesterDayCell cellWithTableView:tableView];
    cell.modal = self.dataArr[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    recentlyModel *detail = self.dataArr[indexPath.row];
    ProduceDetailViewController *web = [[ProduceDetailViewController alloc] init];
    web.produceUrl = detail.LinkUrl;
    [self.navigationController pushViewController:web animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 153;
}

@end
