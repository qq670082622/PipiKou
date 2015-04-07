//
//  ChildAccountViewController.m
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ChildAccountViewController.h"
#import "BindPhoneViewController.h"
#import "LoginTool.h"
#import "UserInfo.h"
#import "Distribution.h"
#import "AppDelegate.h"
#import "Travel.h"
#import "TravelCell.h"
#import "Login.h"

@interface ChildAccountViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,weak) UILabel *nameLab;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ChildAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = nil;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];
    [self.view addSubview:self.tableView];
    
    self.nameLab.text = @"hehehehe";
    [self.nameLab sizeToFit];
    
    // 设置头部图标
    [self setupHeader];

    [self loadDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"clearNavi"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"clearNavi"]];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 190, self.view.frame.size.width, self.view.frame.size.height - 190) style:UITableViewStylePlain];
        _tableView.rowHeight = 80;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.tableHeaderView = nil;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsZero;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - private
- (void)loadDataSource
{
//    [self.dataSource removeAllObjects];
//    [LoginTool getDistributionListWithSuccess:^(id json) {
//        NSLog(@"--------%@",json);
//        if ([json[@"IsSuccess"] integerValue] == 1) {
//            
//            dispatch_queue_t q = dispatch_queue_create("distribution_q", DISPATCH_QUEUE_SERIAL);
//            dispatch_async(q, ^{
//                
//                [self.dataSource addObject:json[@"BusinessInfo"][@"Text"]];
//                for (NSDictionary *dic in json[@"DistributionList"]) {
//                    Distribution *dis = [Distribution distributionWithDict:dic];
//                    [self.dataSource addObject:dis];
//                }
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.tableView reloadData];
//                });
//            });
//        }
//    } failure:^(NSError *error){
//        
//    }];
    Travel *model = [[Travel alloc] init];
    model.icon = @"aa";
    model.title = @"浙江光大国际旅游有限公司";
    for (int i = 0; i < 10; i ++) {
        [self.dataSource addObject:model];
    }
    
    [self.tableView reloadData];
}

/**
 *  设置头部图标
 */
- (void)setupHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 190)];
    cover.backgroundColor = [UIColor clearColor];
    
    CGFloat iconX = (self.view.frame.size.width - 150) * 0.5;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 0, 150, 150)];
    iconView.backgroundColor = [UIColor orangeColor];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.backgroundColor = [UIColor clearColor];
    iconView.image = [UIImage imageNamed:@"bigIcon"];
    [cover addSubview:iconView];
    
    CGFloat nameY = CGRectGetMaxY(iconView.frame);
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150) * 0.5, nameY, 150, 20)];
    nameLab.textColor = [UIColor whiteColor];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    nameLab.layer.cornerRadius = 5;
    nameLab.layer.masksToBounds = YES;
    nameLab.font = [UIFont systemFontOfSize:13];
    [cover addSubview:nameLab];
    self.nameLab = nameLab;
    
    [self.view addSubview:cover];
}

#pragma mark - getter
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *ID = @"childaccountcell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    
//    if (indexPath.row == 0) {
//        cell.imageView.image = [UIImage imageNamed:@"iconfont-dianpu"];
//        cell.textLabel.text = self.dataSource[indexPath.row];
//    }else{
//        cell.imageView.image = [UIImage imageNamed:@"iconfont-wo"];
//        Distribution *dis = self.dataSource[indexPath.row];
//        cell.textLabel.text = dis.name;
//    }
    TravelCell *cell = [TravelCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (!indexPath.row == 0) {
//        Distribution *dis = self.dataSource[indexPath.row];
//        
//        // 去绑定手机
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
//        BindPhoneViewController *bind = [sb instantiateViewControllerWithIdentifier:@"BindPhone"];
//        bind.distributionId = dis.distributionId;
//        [self.navigationController pushViewController:bind animated:YES];
//    }else{
//        AppDelegate *app = [UIApplication sharedApplication].delegate;
//        [app setTabbarRoot];
//    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
    Login *lg = [sb instantiateViewControllerWithIdentifier:@"Login"];
    [self.navigationController pushViewController:lg animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, self.view.frame.size.width - 50, 20)];
    title.text = @"选择以下你所属的旅行社";
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = [UIColor whiteColor];
    [cover addSubview:title];
    
    return cover;
}

@end
