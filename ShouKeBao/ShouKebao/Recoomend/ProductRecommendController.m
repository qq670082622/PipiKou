//
//  ProductRecommendController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/14.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ProductRecommendController.h"
#import "StationSelect.h"
#import "SearchProductViewController.h"
#import "WMAnimations.h"
#import "MobClick.h"
#import "HomeHttpTool.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "MJRefresh.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"

#define  K_TableWidth [UIScreen mainScreen].bounds.size.width
@interface ProductRecommendController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;//承载三个tableView的主scrollview
//今日推荐
@property (strong, nonatomic) IBOutlet UIButton *todayBtn;
- (IBAction)todayBtnAction:(id)sender;
//昨日推荐
@property (strong, nonatomic) IBOutlet UIButton *yestodayBtn;
- (IBAction)yestodayBtnAction:(id)sender;
//近期推荐
@property (strong, nonatomic) IBOutlet UIButton *recentlyBtn;
- (IBAction)recentlyBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *topLine;

@property (nonatomic, strong)UITableView * todayTableView;
@property (nonatomic, strong)UITableView * yestdayTableView;
@property (nonatomic, strong)UITableView * recentlyTableView;

@end

@implementation ProductRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];







}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - LazyLoading
-(UITableView *)todayTableView{
    if (!_todayTableView) {
        _todayTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, K_TableWidth, self.mainScrollView.frame.size.height)];
    }
    return _todayTableView;
}
-(UITableView *)yestdayTableView{
    if (!_yestdayTableView) {
        _yestdayTableView = [[UITableView alloc]initWithFrame:CGRectMake(K_TableWidth, 0, K_TableWidth, self.mainScrollView.frame.size.height)];
    }
    return _yestdayTableView;
}
-(UITableView *)recentlyTableView{
    if (_recentlyTableView) {
        _recentlyTableView = [[UITableView alloc]initWithFrame:CGRectMake(K_TableWidth * 2, 0, K_TableWidth, self.mainScrollView.frame.size.height)];
    }
    return _recentlyTableView;
}
- (void)setTableView{
    self.mainScrollView.contentSize = CGSizeMake(K_TableWidth * 3, self.mainScrollView.frame.size.height);
    self.mainScrollView.delegate = self;
    self.mainScrollView.backgroundColor = [UIColor brownColor];
    self.todayTableView.delegate = self;
    self.todayTableView.dataSource = self;
    self.yestdayTableView.delegate = self;
    self.yestdayTableView.dataSource = self;
    self.recentlyTableView.delegate = self;
    self.recentlyTableView.delegate = self;
    [self.mainScrollView addSubview:self.todayTableView];
    [self.mainScrollView addSubview:self.yestdayTableView];
    [self.mainScrollView addSubview:self.recentlyTableView];
}
#pragma mark - TopBtnActon
- (IBAction)todayBtnAction:(id)sender {
}
- (IBAction)yestodayBtnAction:(id)sender {
}
- (IBAction)recentlyBtnAction:(id)sender {
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f", scrollView.contentOffset.x);
}                                             // any offset changes



























/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
