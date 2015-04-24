//
//  SosViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/1.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SosViewController.h"
#import "MeHttpTool.h"
#import "Server.h"

@interface SosViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) Server *server;

@property (weak, nonatomic) IBOutlet UILabel *emailLab;

@property (weak, nonatomic) IBOutlet UILabel *phoneLav;

@property (weak, nonatomic) IBOutlet UILabel *QQLab;

@property (weak, nonatomic) UILabel *nameLab;

@end

@implementation SosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搬救兵";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    [self setHead];
    
    [self loadDataSource];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"clearNavi"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"clearNavi"]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jianbian"] forBarMetrics:UIBarMetricsDefault];
}

- (void)loadDataSource
{
    [MeHttpTool getReinforcementsWithsuccess:^(id json) {
        NSLog(@"---------%@",json);
        if (![json[@"Reinforcements"] isKindOfClass:[NSNull class]]) {
            
            NSDictionary *dic = json[@"Reinforcements"];
            self.server = [Server serverWithDict:dic];
            
            self.emailLab.text = self.server.Email;
            self.phoneLav.text = self.server.Mobile;
            self.QQLab.text = self.server.QQCode;
            self.nameLab.text = self.server.Name;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setHead
{
    CGFloat gap = self.view.frame.size.width * 0.0625;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plusbanjiubingbg"]];
    
    // 头像
    UIImageView *headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(gap, 64, 100, 100)];
    headIcon.contentMode = UIViewContentModeScaleAspectFill;
    headIcon.layer.cornerRadius = 5;
    headIcon.layer.masksToBounds = YES;
    headIcon.image = [UIImage imageNamed:@"aa"];
    [view addSubview:headIcon];
    
    CGFloat aX = CGRectGetMaxX(headIcon.frame) + gap;
    UILabel *a = [[UILabel alloc] initWithFrame:CGRectMake(aX, headIcon.frame.origin.y, 150, gap)];
    a.text = @"您的专属客服经理";
    a.font = [UIFont systemFontOfSize:13];
    [view addSubview:a];
    
    CGFloat nameY = CGRectGetMaxY(a.frame) + gap;
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(aX, nameY, self.view.frame.size.width - 100 + gap * 3, 60)];
    nameLab.font = [UIFont boldSystemFontOfSize:45];
    [view addSubview:nameLab];
    self.nameLab = nameLab;
    
    self.tableView.tableHeaderView = view;
}

// 打电话联系客服
- (IBAction)callServer:(UIButton *)sender
{
    if (!self.server.Mobile) {
        return;
    }
    NSString *phone = [NSString stringWithFormat:@"tel://%@",self.server.Mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

// qq联系客服
- (IBAction)callByQq:(UIButton *)sender
{
    if (!self.server.QQCode) {
        return;
    }
    if (![self joinGroup:nil key:nil]) {
        UIAlertView *ale=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有安装手机QQ，请安装手机QQ后重试，或用PC进行操作。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [ale show];
    }
}

- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=6481427ed9be2a6b6df78d95f2abf8a0ebaed07baefe3a2bea8bd847cb9d84ed&card_type=group&source=external"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        NSString *qqStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.server.QQCode];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qqStr]];
        return YES;
    }
    else return NO;
}

#pragma mark - UIScrollViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 避免漏出背景
    if (scrollView.contentOffset.y < 0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
}

@end
