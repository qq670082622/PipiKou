//
//  ShouKeBao.m
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ShouKeBao.h"
#import "MJRefresh.h"
#import "OrderCell.h"
#import "OrderModel.h"
#import "SearchProductViewController.h"
#import "ShouKeBaoCell.h"
#import "StationSelect.h"
#import "StoreViewController.h"
#import "QRCodeViewController.h"
#import "ResizeImage.h"
#import "BBBadgeBarButtonItem.h"
#import "messageCenterViewController.h"


@interface ShouKeBao ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
- (IBAction)changeStation:(id)sender;
- (IBAction)phoneToService:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *yesterDayOrderCount;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayVisitors;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UIButton *stationName;

- (IBAction)search:(id)sender;

- (IBAction)add:(id)sender;
@end

@implementation ShouKeBao

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
    
    
    [self customLeftBarItem];
    [self customRightBarItem];
    self.searchBtn.layer.cornerRadius = 4;
    self.searchBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.searchBtn.layer.borderWidth = 0.5f;
    self.searchBtn.layer.masksToBounds = YES;
   
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToStore)];
    [self.upView addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    NSString *subStationName = [udf stringForKey:@"SubstationName"];
    if (subStationName) {
        [self.stationName setTitle:subStationName forState:UIControlStateNormal];
    }else if (!subStationName){
        [self.stationName setTitle:@"上海" forState:UIControlStateNormal];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 116, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 180)];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableView.rowHeight = 120;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - private
-(void)pushToStore
{
    StoreViewController *store =  [[StoreViewController alloc] init];
    store.PushUrl = @"http://skb.lvyouquan.cn/mc/kaifaceshi/";
    [self.navigationController pushViewController:store animated:YES];
}

- (IBAction)changeStation:(id)sender {
    
    [self.navigationController pushViewController:[[StationSelect alloc] init] animated:YES];
}

- (IBAction)phoneToService:(id)sender {
    
}

- (IBAction)search:(id)sender {
    
    SearchProductViewController *searchVC = [[SearchProductViewController alloc] init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

- (IBAction)add:(id)sender {
    
}


-(void)customLeftBarItem
{
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [customButton addTarget:self action:@selector(ringAction) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"lingdang1"] forState:UIControlStateNormal];
    
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    
    barButton.badgeValue = @"12";
    barButton.shouldHideBadgeAtZero = YES;
    
    self.navigationItem.leftBarButtonItem = barButton;
    
    //改变badgeValue的值
    //    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;
    //    barButton.badgeValue = [NSString stringWithFormat:@"%d", [barButton.badgeValue intValue] + 1];
}

-(void)customRightBarItem
{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];;
    [btn addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"erweima"] forState:UIControlStateNormal];
   UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
}

-(void)ringAction
{

    messageCenterViewController *messgeCenter = [[messageCenterViewController alloc] init];
    [self.navigationController pushViewController:messgeCenter animated:YES];
    
}
-(void)codeAction
{
    [self.navigationController pushViewController:[[QRCodeViewController alloc] init] animated:YES];
    
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShouKeBaoCell *cell = [ShouKeBaoCell cellWithTableView:tableView];
    
    return cell;
}


@end
