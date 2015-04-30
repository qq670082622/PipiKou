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
#import "NSMutableDictionary+QD.h"
#import "StepView.h"
#import "LoginCell.h"
#import "MBProgressHUD+MJ.h"

@interface ChildAccountViewController ()<UITableViewDataSource,UITableViewDelegate,TravelCellDelegate,UIScrollViewDelegate>

@property (nonatomic,weak) UIButton *nameBtn;

@property (nonatomic,strong) UITableView *tableView;// 这是旅游社列表

@property (nonatomic,strong) UITableView *loginTableView;// 登录列表

@property (weak, nonatomic) UITextField *accountField;// 账号输入框

@property (weak, nonatomic) UITextField *passwordField;// 密码输入框

@property (copy, nonatomic) NSString *account;// 账号输入框

@property (copy, nonatomic) NSString *password;// 密码输入框

@property (nonatomic,weak) UILabel *nameLab;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,weak) UIImageView *iconView;

@property (nonatomic,copy) NSString *businessId;

@property (nonatomic,copy) NSString *distributeId;

@property (nonatomic,copy) NSString *chooseId;

@property (nonatomic,weak) UIScrollView *scrollView;

@end

@implementation ChildAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = nil;
    
    UIImage *image = [UIImage imageNamed:@"beijing"];
    self.view.layer.contents = (id) image.CGImage;
    
    // 设置头部图标
    [self setupHeader];
    
    // 设置登录按钮
    [self setupLoginFoot];
    
    // 设置scrollview
    [self setupScrollView];
    
    // 请求数据
    [self loadDataSource];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stepBtnClick:) name:@"stepBtnClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - loadDataSource
- (void)loadDataSource
{
    NSDictionary *param = @{@"Mobile":self.mobile};
    [LoginTool getBusinessListWithParam:param success:^(id json) {
        if (json) {
            NSLog(@"-----  %@",json);
            NSMutableDictionary *muta = [NSMutableDictionary cleanNullResult:json];
            [UserInfo userInfoWithDict:muta];
            
            self.businessId = muta[@"BusinessID"];
            self.distributeId = muta[@"DistributionID"];

            if (![muta[@"BusinessList"] isKindOfClass:[NSNull class]]){
                // 整理旅行社列表
                [self.dataSource removeAllObjects];
                for (NSDictionary *dic in muta[@"BusinessList"]) {
                    Business *business = [Business businessWithDict:dic];
                    [self.dataSource addObject:business];
                }
            }
            
            // 设置用户名称以及头像
            [self setWithName:json[@"Position"]];
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:[UserInfo shareUser].LoginAvatar] placeholderImage:nil];
            self.nameLab.text = [UserInfo shareUser].userName;
            
            // 刷新列表
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 250) style:UITableViewStylePlain];
        _tableView.rowHeight = 80;
        _tableView.tag = 1;
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

- (UITableView *)loginTableView
{
    if (!_loginTableView) {
        _loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - 250)];
        _loginTableView.rowHeight = 65;
        _loginTableView.tag = 2;
        _loginTableView.backgroundColor = [UIColor clearColor];
        _loginTableView.dataSource = self;
        _loginTableView.delegate = self;
        _loginTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _loginTableView;
}

#pragma mark - private
/**
 *  设置登录按钮
 */
- (void)setupLoginFoot
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 7.0, self.view.frame.size.width - 30, 50)];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"red-bg"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 3;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.reversesTitleShadowWhenHighlighted = NO;
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [cover addSubview:loginBtn];
    
    self.loginTableView.tableFooterView = cover;
}

/**
 *  设置头部图标
 */
- (void)setupHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    cover.backgroundColor = [UIColor clearColor];
    
    // 头像
    CGFloat iconX = (self.view.frame.size.width - 100) * 0.5;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 64, 100, 100)];
    iconView.backgroundColor = [UIColor orangeColor];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.backgroundColor = [UIColor clearColor];
    iconView.layer.cornerRadius = 50;
    iconView.layer.masksToBounds = YES;
    [cover addSubview:iconView];
    self.iconView = iconView;
    
    // 头像阴影
    UIImageView *shadow = [[UIImageView alloc] init];
    shadow.center = iconView.center;
    shadow.bounds = CGRectMake(0, 0, 120, 120);
    shadow.image = [UIImage imageNamed:@"yiny1"];
    [cover insertSubview:shadow atIndex:0];
    
    // 名字
    CGFloat labW = self.view.frame.size.width * 0.5;
    CGFloat labX = labW * 0.5;
    CGFloat labY = CGRectGetMaxY(iconView.frame) + 5;
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(labX, labY, labW, 20)];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:15];
    [cover addSubview:nameLab];
    self.nameLab = nameLab;
    
    // 心情
    CGFloat nameY = CGRectGetMaxY(nameLab.frame) + 5;
    UIButton *nameBtn = [[UIButton alloc] init];
    nameBtn.center = CGPointMake(self.view.frame.size.width * 0.5, nameY + 10);
    nameBtn.bounds = CGRectMake(0, 0, 100, 20);
    [nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nameBtn setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.3]];
    nameBtn.layer.cornerRadius = 5;
    nameBtn.layer.masksToBounds = YES;
    nameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cover addSubview:nameBtn];
    nameBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    self.nameBtn = nameBtn;
    
    // 步骤
    CGFloat stepY = cover.frame.size.height - 20;
    StepView *stepView = [[StepView alloc] initWithFrame:CGRectMake(15, stepY, self.view.frame.size.width - 30, 20)];
    [stepView setStepAtIndex:1];
    [cover addSubview:stepView];
    
    [self.view addSubview:cover];
}

// 设置scrollview
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, self.view.frame.size.height - 250)];
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width * 2, scrollView.frame.size.height)];
    scrollView.tag = 3;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.scrollEnabled = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.directionalLockEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    [scrollView addSubview:self.tableView];
    [scrollView addSubview:self.loginTableView];
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
//    Login *lg = [sb instantiateViewControllerWithIdentifier:@"Login"];
//    lg.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height - 215);
//    [scrollView addSubview:lg.view];
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

// 登录
- (void)loginAction:(UIButton *)btn
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *param = @{@"LoginName":self.accountField.text,
                            @"LoginPassword":self.passwordField.text,
                            @"ChooseBusinessID":self.chooseId,
                            @"BusinessID":self.businessId,
                            @"DistributionID":self.distributeId};
    
    [LoginTool loginWithParam:param success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"----%@",json);
        
        if ([json[@"IsSuccess"] integerValue] == 1) {
            
            // 保存账号密码
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:self.accountField.text forKey:@"account"];
            [def setObject:self.passwordField.text forKey:@"password"];
            
            // 储存手机号 证明已经绑定过手机
            [def setObject:self.mobile forKey:@"phonenumber"];
            
            // 保存必要参数
            //    lg.chooseId = travel.bussinessId;
            //    lg.businessId = self.businessId;
            //    lg.distributeId = self.distributeId;
            //    lg.mobile = self.mobile;
            [def setObject:json[@"LoginType"] forKey:@"LoginType"];
            [def setObject:self.businessId forKey:@"BusinessID"];
            [def setObject:self.distributeId forKey:@"DistributionID"];
            [def setObject:self.chooseId forKey:@"ChooseID"];
            [def synchronize];
            
            // 给用户打上jpush标签
            [APService setAlias:self.businessId callbackSelector:nil object:nil];
            NSLog(@"------------apns 的alias是%@----------",_businessId);
            
            // 跳转主界面
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            [app setTabbarRoot];
            
        }else{
            if (![json[@"ErrorMsg"] isKindOfClass:[NSNull class]]) {
                [MBProgressHUD showError:json[@"ErrorMsg"]];
            }else{
                [MBProgressHUD showError:@"网络连接错误"];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}

- (void)tapHandle:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
}

#pragma mark - noty
- (void)stepBtnClick:(NSNotification *)noty
{
    NSDictionary *info = noty.userInfo;
    if ([info[@"step"] integerValue] == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)keyboardWillShow:(NSNotification *)noty
{
    // 1.取出键盘的frame
    CGRect keyboardF = [noty.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.取出键盘弹出的时间
    CGFloat duration = [noty.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat bottomSpace = self.scrollView.frame.size.height - 65 * 3;
    if (bottomSpace < keyboardF.size.height) {
        // 3.执行动画
        [UIView animateWithDuration:duration animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -(keyboardF.size.height - bottomSpace));
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)noty
{
    // 1.取出键盘弹出的时间
    CGFloat duration = [noty.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
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
    if (tableView.tag == 1) {
        return self.dataSource.count;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        TravelCell *cell = [TravelCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.indexPath = indexPath;
        
        Business *business = self.dataSource[indexPath.row];
        cell.model = business;
        
        return cell;
    }else{
        LoginCell *cell = [LoginCell cellWithTableView:tableView];
        
        cell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"login_icon%ld",(long)indexPath.row]];
        cell.inputField.placeholder = indexPath.row == 0 ? @"输入登录邮箱/手机" : @"输入登录密码";
        
        if (indexPath.row == 0) {
            self.accountField = cell.inputField;
//            self.accountField.text = @"lxstest";
        }else{
            self.passwordField = cell.inputField;
            [self.passwordField setSecureTextEntry:YES];
//            self.passwordField.text = @"A148A148";
        }
        
        return cell;
    }
}

#pragma mark - TravelCellDelegate
- (void)didSelectedTravelWithIndextPath:(NSIndexPath *)indexPath
{
    Business *travel = self.dataSource[indexPath.row];
    self.chooseId = travel.bussinessId;
    [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

// 选择旅行社的时候不能左右滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 3) {
        CGFloat offset = scrollView.contentOffset.x;
        if (offset == 0) {
            scrollView.scrollEnabled = NO;
        }else{
            scrollView.scrollEnabled = YES;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
}

@end
