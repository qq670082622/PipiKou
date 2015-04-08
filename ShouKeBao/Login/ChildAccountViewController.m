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
#import "Business.h"
#import "TravelCell.h"
#import "Login.h"
#import "UIImageView+WebCache.h"

@interface ChildAccountViewController ()<UITableViewDataSource,UITableViewDelegate,TravelCellDelegate>

@property (nonatomic,weak) UIButton *nameBtn;

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
    
    // 设置头部图标
    [self setupHeader];
    
    // 设置用户名称
    [self setWithName:[UserInfo shareUser].userName];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    
    [backBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"clearNavi"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"clearNavi"]];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 215, self.view.frame.size.width, self.view.frame.size.height - 215) style:UITableViewStylePlain];
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

/**
 *  设置头部图标
 */
- (void)setupHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 215)];
    cover.backgroundColor = [UIColor clearColor];
    
    CGFloat iconX = (self.view.frame.size.width - 100) * 0.5;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 64, 100, 100)];
    iconView.backgroundColor = [UIColor orangeColor];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.backgroundColor = [UIColor clearColor];
    [iconView sd_setImageWithURL:[NSURL URLWithString:[UserInfo shareUser].LoginAvatar] placeholderImage:nil];
    iconView.layer.shadowColor = [UIColor blackColor].CGColor;
    iconView.layer.shadowOpacity = 0.3;
    iconView.layer.shadowOffset = CGSizeMake(5, 5);
    [cover addSubview:iconView];
    
    CGFloat nameY = CGRectGetMaxY(iconView.frame) + 10;
    UIButton *nameBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150) * 0.5, nameY, 100, 20)];
    [nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nameBtn setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.3]];
    nameBtn.layer.cornerRadius = 5;
    nameBtn.layer.masksToBounds = YES;
    nameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cover addSubview:nameBtn];
    nameBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    self.nameBtn = nameBtn;
    
    [self.view addSubview:cover];
}

// 设置用户名称
- (void)setWithName:(NSString *)name
{
    [self.nameBtn setTitle:name forState:UIControlStateNormal];
    [self.nameBtn sizeToFit];
    CGRect rect = self.nameBtn.frame;
    rect.origin.x = (self.view.frame.size.width - rect.size.width) * 0.5;
    self.nameBtn.frame = rect;
}

- (void)doBack:(UIBarButtonItem *)baritem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TravelCell *cell = [TravelCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
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

#pragma mark - TravelCellDelegate
- (void)didSelectedTravelWithIndextPath:(NSIndexPath *)indexPath
{
    Business *travel = self.dataSource[indexPath.row];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
    Login *lg = [sb instantiateViewControllerWithIdentifier:@"Login"];
    lg.aa = [NSString stringWithFormat:@"%@  %d",travel.name,indexPath.row];
    [self.navigationController pushViewController:lg animated:YES];
}

@end
