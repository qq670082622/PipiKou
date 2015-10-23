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
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "MLPhotoBrowserSignleViewController.h"
#import "UIImage+MLBrowserPhotoImageForBundle.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"
@interface SosViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) Server *server;

@property (weak, nonatomic) IBOutlet UILabel *emailLab;

@property (weak, nonatomic) IBOutlet UILabel *phoneLav;

@property (weak, nonatomic) IBOutlet UILabel *QQLab;

@property (weak, nonatomic) UILabel *nameLab;

@property (weak,nonatomic) UIImageView *iconView;

@end

@implementation SosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搬救兵";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addGest];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    [self setHead];
    [self setNav2];
    [self loadDataSource];
    
    
    // 点击联系电话lab也可以直接打电话
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneLabTap:)];
    [self.phoneLav addGestureRecognizer:tap];
    
    // 点击邮件地址 发送邮件
    UITapGestureRecognizer *emailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendEmail:)];
    [self.emailLab addGestureRecognizer:emailTap];
}
- (void)addGest{
    UIScreenEdgePanGestureRecognizer *screenEdge = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreen:)];
    screenEdge.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdge];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleScreen:(UIScreenEdgePanGestureRecognizer *)sender{
    CGPoint sliderdistance = [sender translationInView:self.view];
    if (sliderdistance.x>self.view.bounds.size.width/3) {
        [self back];
    }
    //NSLog(@"%f",sliderdistance.x);
}
- (void)setNav2{
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,15)];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateHighlighted];
    
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(-1, -10, 0, 50);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MeSosViewController"];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"clearNavi"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"clearNavi"]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MeSosViewController"];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jianbian"] forBarMetrics:UIBarMetricsDefault];
}

- (void)loadDataSource
{
    [MeHttpTool getReinforcementsWithsuccess:^(id json) {
        NSLog(@"---------%@",json);
        if (![json[@"Reinforcements"] isKindOfClass:[NSNull class]]) {
            
            NSDictionary *dic = json[@"Reinforcements"];
            self.server = [Server serverWithDict:dic];
            
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.server.Avatar] placeholderImage:[UIImage imageNamed:@"kefutouxiang"]];
            self.emailLab.text = self.server.Email;
            self.phoneLav.text = self.server.Mobile;
            self.QQLab.text = self.server.QQCode;
            self.nameLab.text = self.server.Name;
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - private
- (void)setHead
{
    CGFloat gap = self.view.frame.size.width * 0.0625;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plusbanjiubingbg"]];
    
    // 头像
    UIImageView *headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(gap, 64, 100, 100)];
    headIcon.userInteractionEnabled = YES;
    headIcon.contentMode = UIViewContentModeScaleAspectFill;
    headIcon.layer.cornerRadius = 5;
    headIcon.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkHeadIcon:)];
    [headIcon addGestureRecognizer:tap];
    [view addSubview:headIcon];
    self.iconView = headIcon;
    
    CGFloat aX = CGRectGetMaxX(headIcon.frame) + gap;
    UILabel *a = [[UILabel alloc] initWithFrame:CGRectMake(aX, headIcon.frame.origin.y, 150, gap)];
    a.text = @"您的专属客户经理";
    a.font = [UIFont systemFontOfSize:13];
    [view addSubview:a];
    
    CGFloat nameY = CGRectGetMaxY(a.frame) + gap;
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(aX, nameY, self.view.frame.size.width - 100 + gap * 3, 60)];
    nameLab.font = [UIFont boldSystemFontOfSize:45];
    [view addSubview:nameLab];
    self.nameLab = nameLab;
    
    self.tableView.tableHeaderView = view;
}

/**
 *  显示头像
 */
- (void)checkHeadIcon:(UITapGestureRecognizer *)ges
{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//    [FSPhotoView showImageWithSenderView:self.iconView completion:^{
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//    }];
    MLPhotoBrowserSignleViewController *browserVc = [[MLPhotoBrowserSignleViewController alloc] init];
    [browserVc showHeadPortrait:self.iconView originUrl:nil];
}

#pragma mark - qq联系
// qq联系客服
- (IBAction)callByQq:(UIButton *)sender
{
    if (self.isFromMe) {
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"MeSOSQQClick" attributes:dict];

    }else{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBaoSOSQQClick" attributes:dict];
    }
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

#pragma mark - 拨打电话
// 打电话联系客服
- (IBAction)callServer:(UIButton *)sender
{
    if (self.isFromMe) {
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"MeSOSCallPheoneClick" attributes:dict];
    }else{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBaoCallPheoneClick" attributes:dict];
    }
    [self phoneCall];
}

/**
 *  点击lab打电话
 */
- (void)phoneLabTap:(UITapGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateEnded) {
        
        if (self.phoneLav.text.length) {
            [self phoneCall];
        }
    }
}

/**
 *  拨打电话
 */
- (void)phoneCall
{
    if (!self.server.Mobile) {
        return;
    }
    NSString *phone = [NSString stringWithFormat:@"tel://%@",self.server.Mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

#pragma mark - 发送邮件
/**
 *  点击邮箱地址触发事件
 */
- (void)sendEmail:(UITapGestureRecognizer *)ges
{
    NSString *url = [NSString stringWithFormat:@"mailto:%@",self.emailLab.text];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
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
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < 0){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

@end
