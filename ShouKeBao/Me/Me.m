//
//  Me.m
//  ShouKeBao
//
//  Created by Richard on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Me.h"
#import "MeHeader.h"
#import "MeButtonView.h"
#import "PersonSettingViewController.h"
#import "OrgSettingViewController.h"
#import "SuggestViewController.h"
#import "SosViewController.h"
#import "MyOrgViewController.h"
#import "MyListViewController.h"
#import "SafeSettingViewController.h"
#import "UserInfo.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Category.h"
#import "QuanViewController.h"
#import "MeHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "WelcomeView.h"

#import "FeedBcakViewController.h"
#import "ResizeImage.h"
#import "IWHttpTool.h"
#import "InspectionViewController.h"
#import "WMAnimations.h"
#import "MeProgressView.h"
#import "AFNetworking.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"
#import "NewVersionWebViewController.h"
#import "MoneyTreeViewController.h"
#import "TravelConsultantViewController.h"
#import "LvYouGuWenViewController.h"
#import "TravelConsultantViewControllerNoShare.h"
#import "UpDateUserPictureViewController.h"
#import "MoreLvYouGuWenInfoViewController.h"
#import "MeShareDetailViewController.h"
#import "InvoiceManageViewController.h"
#import "ExclusiveViewController.h"
#import "EstablelishedViewController.h"
#import "MeShareDetailModel.h"
#define foureSize ([UIScreen mainScreen].bounds.size.height == 480)
#define fiveSize ([UIScreen mainScreen].bounds.size.height == 568)
#define sixSize ([UIScreen mainScreen].bounds.size.height == 667)
#define sixPSize ([UIScreen mainScreen].bounds.size.height > 668)
#define kScreenSize [UIScreen mainScreen].bounds.size

@interface Me () <MeHeaderDelegate,MeButtonViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic,strong) MeHeader *meheader;

@property (nonatomic,strong) MeButtonView *buttonView;

@property (nonatomic,strong) NSArray *desArr;

@property (nonatomic,assign) BOOL isPerson;//是否个人

@property (nonatomic,assign) BOOL isFindNew;
@property (nonatomic, copy)NSString * checkVersionLinkUrl;
@property (nonatomic, strong)MeProgressView *progressView;
@property (nonatomic, strong)NSDictionary * versionInfoDic;
@property (nonatomic, copy)NSString * IOSUpdateType;

@property (nonatomic, strong)NSMutableArray *dataShareArr;
@property (nonatomic, copy)NSString *IsOpenConsultantApp;
@property (nonatomic, strong)NSMutableDictionary *ConsultanShareInfo;
@property (nonatomic, strong) UIView *guideView;
@property (nonatomic, strong) UIImageView *guideImageView;
@property (nonatomic, copy)NSString *clientMagagerTel;

@end

@implementation Me

#pragma mark - lifecircle
- (void)viewDidLoad {
    [super viewDidLoad];
     [self loadIsOpenAppData];
    self.title = @"我";
    self.tableView.rowHeight = 50;
    //self.desArr = @[@[@"我的分享"],@[/*@"专属App",*/@"我的旅行社",@"圈付宝",@"摇钱树",@"发票管理"],@[@"账号安全设置"],@[@"勿扰模式",@"意见反馈",@"关于旅游圈",/*@"评价旅游圈",*/@"检查更新"]];
    self.desArr = @[@[@"我的分享"],@[/*@"专属App",*/@"我的旅行社",@"圈付宝",@"摇钱树", @"专属APP",@"发票管理"],/*@[@"账号安全设置"],*/@[/*@"勿扰模式"*/@"设置",@"意见反馈",@"关于旅游圈",/*@"评价旅游圈",*/@"检查更新"]];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *loginType = [def objectForKey:@"LoginType"];
    self.isPerson = [loginType integerValue] != 1;

    
    // 知道登录类型以后 设置头部
    [self setHeader];
//    MeProgressView * pro = [MeProgressView creatProgressViewWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 60)];
//    pro.backgroundColor = [UIColor clearColor];
//    pro.progressValue = 0.3;
//    [self.view addSubview:pro];
    [[[UIApplication sharedApplication].delegate window]addSubview:self.progressView];
    
    NSString *SKBMeGuide = [def objectForKey:@"NewMeGuide"];
    if ([SKBMeGuide integerValue] != 1) {// 是否第一次打开app
        [self Guide];
    }
    
    //获取版本信息
    NSDictionary * dic = @{};
    [MeHttpTool inspectionWithParam:dic success:^(id json) {
        self.versionInfoDic = json[@"NewVersion"];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
//第一次开机引导
-(void)Guide
{
    self.guideView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _guideView.backgroundColor = [UIColor blackColor];
    _guideView.alpha = 0.5;
    self.guideImageView = [[UIImageView alloc] init];
    [_guideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)]];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLYGWIsOpenVIP] isEqualToString:@"0"]){//没有开通旅游顾问
        if (foureSize) {
            self.guideImageView.frame =CGRectMake(20,kScreenSize.height/6 , kScreenSize.width-40, kScreenSize.height/2);
            self.guideImageView.image = [UIImage imageNamed:@"NewMeGuide4no"];//NewMeGuide
        }else{
            self.guideImageView.image = [UIImage imageNamed:@"NewMeGuide5no"];//NewMeGuide
            if (fiveSize) {
                self.guideImageView.frame =CGRectMake(20,kScreenSize.height/3+20 , kScreenSize.width-40, kScreenSize.height/2);
            }else if(sixSize){
                self.guideImageView.frame =CGRectMake(20,kScreenSize.height/4-5 , kScreenSize.width-40, kScreenSize.height/2);
            }else{
                self.guideImageView.frame =CGRectMake(20,kScreenSize.height/6 , kScreenSize.width-40, kScreenSize.height/2);
            }
        }

    }else{
    if (foureSize) {
        self.guideImageView.frame =CGRectMake(20,kScreenSize.height/6 , kScreenSize.width-40, kScreenSize.height/2);
        self.guideImageView.image = [UIImage imageNamed:@"NewMeGuide4"];//NewMeGuide
    }else{
        self.guideImageView.image = [UIImage imageNamed:@"NewMeGuide5"];//NewMeGuide
        if (fiveSize) {
           self.guideImageView.frame =CGRectMake(20,kScreenSize.height/3+20 , kScreenSize.width-40, kScreenSize.height/2);
        }else if(sixSize){
            self.guideImageView.frame =CGRectMake(20,kScreenSize.height/4-5 , kScreenSize.width-40, kScreenSize.height/2);
        }else{
            self.guideImageView.frame =CGRectMake(20,kScreenSize.height/6 , kScreenSize.width-40, kScreenSize.height/2);
        }
    }
    }

    NSUserDefaults *guideDefault = [NSUserDefaults standardUserDefaults];
    [guideDefault setObject:@"1" forKey:@"NewMeGuide"];
    [guideDefault synchronize];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:_guideView];
    [[[UIApplication sharedApplication].delegate window] addSubview:_guideImageView];
}
-(void)click
{
    CATransition *an1 = [CATransition animation];
    an1.type = @"rippleEffect";
    an1.subtype = kCATransitionFromRight;//用kcatransition的类别确定cube翻转方向
    an1.duration = 0.2;
    [self.guideImageView.layer addAnimation:an1 forKey:nil];
    [self.guideImageView removeFromSuperview];
    [self.guideView removeFromSuperview];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Me"];
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"MeNum" attributes:dict];
    if (self.tableView) {
        [self.tableView reloadData];
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstFindMoneyTree"]&&[[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstFindInvoiceManage"]) {
            for (UIView * subView in self.tabBarController.tabBar.subviews) {
                if (subView.tag == 888) {
                    [subView removeFromSuperview];
                }
            }
        }
//        self.tabBarItem.badgeValue = nil;
    }

    [self refrashHeader];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isPush = 1;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *loginType = [def objectForKey:@"ThreeDTouch"];
    if ([loginType isEqualToString:@"UITouchText.TodaySignIn"]) {

        MoneyTreeViewController * moneyTreeVC = [[MoneyTreeViewController alloc]init];
        moneyTreeVC.webTitle = @"摇钱树";
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstFindMoneyTree"];
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"MeMoenyTreeClick" attributes:dict];
        [def removeObjectForKey:@"ThreeDTouch"];
        [self.navigationController pushViewController:moneyTreeVC animated:YES];
    }
}
-(void)thirdTouchPushYaoQianShu:(NSNotification *)notiP{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:@"ThreeDTouch"];
    if (self.isPush == 1) {
        self.isPush = 0;
        MoneyTreeViewController * moneyTreeVC = [[MoneyTreeViewController alloc]init];
        moneyTreeVC.webTitle = @"摇钱树";
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstFindMoneyTree"];
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"MeMoenyTreeClick" attributes:dict];
        [self.navigationController pushViewController:moneyTreeVC animated:YES];
    }
}
- (void)refrashHeader{
    _meheader.nickName.text = [UserInfo shareUser].userName;
    [MeHttpTool getDistributionWithsuccess:^(id json) {
        if (![json[@"Busienss"] isKindOfClass:[NSNull class]]) {
            NSLog(@"-----%@",json);
            NSDictionary *dic = json[@"Distribution"];
            NSMutableDictionary *muta = dic.mutableCopy;
            NSArray *array = [dic allKeys];
            for (NSString *key in array) {
                if ([[muta objectForKey:key] isKindOfClass:[NSNull class]]) {
                    [muta setValue:@"" forKey:key];
                }
            }
            [self setHeaderWith:muta[@"ConsultantLevel"]];
            _meheader.personType.text =[[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKeyLYGWPhoneNum];
            _meheader.positionLab.text = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKeyLYGWPosition];
            [[NSUserDefaults standardUserDefaults]setObject:muta[@"ConsultantLevel"] forKey:UserInfoKeyLYGWLevel];
            
            [[NSUserDefaults standardUserDefaults]setObject:muta[@"ConsultantUrl"] forKey:UserInfoKeyLYGWLinkUrl];
            [[NSUserDefaults standardUserDefaults]setObject:muta[@"Position"] forKey:UserInfoKeyLYGWPosition];
            [[NSUserDefaults standardUserDefaults]setObject:muta[@"Mobile"] forKey:UserInfoKeyLYGWPhoneNum];
            
//            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)setHeaderWith:(NSString *)leavel{
    switch ([leavel integerValue]) {
        case 1000:
            self.meheader.levelIcon.image = [UIImage imageNamed:@"jianxi"];
            self.meheader.levelName.text = @"见习顾问";
            break;
        case 2000:
            self.meheader.levelIcon.image = [UIImage imageNamed:@"tongpai"];
            self.meheader.levelName.text = @"铜牌顾问";
            break;
        case 3000:
            self.meheader.levelIcon.image = [UIImage imageNamed:@"yinpai"];
            self.meheader.levelName.text = @"银牌顾问";
            break;
        case 4000:
            self.meheader.levelIcon.image = [UIImage imageNamed:@"huangjin"];
            self.meheader.levelName.text = @"黄金顾问";
            break;
        case 5000:
            self.meheader.levelIcon.image = [UIImage imageNamed:@"baijin"];
            self.meheader.levelName.text = @"白金顾问";
            break;
        case 6000:
            self.meheader.levelIcon.image = [UIImage imageNamed:@"zuanshi"];
            self.meheader.levelName.text = @"钻石顾问";
            break;
        default:
            break;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Me"];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - private
// 设置头部
- (void)setHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
    // 设置头像
    NSString *head = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginAvatar];
    NSString *level = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLYGWLevel];
    [self setHeaderWith:level];
    NSLog(@"%@",head);
    if (head) {
        [self.meheader.headIcon sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"bigIcon"]];
    }

    [cover addSubview:self.meheader];
    [cover addSubview:self.buttonView];
    
    self.tableView.tableHeaderView = cover;
}

// 设置固定时间段免打扰
- (void)changePushMode:(UISwitch *)modeSwitch
{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"MeDonotDisturbMe" attributes:dict];

    NSDictionary *param = @{@"DisturbSwitch":[NSString stringWithFormat:@"%d",modeSwitch.on]};
    [MeHttpTool setDisturbSwitchWithParam:param success:^(id json) {
        NSLog(@"json   %@",json);
        if ([json[@"IsSuccess"] integerValue] == 0) {
            [modeSwitch setOn:!modeSwitch.on animated:YES];
            [MBProgressHUD showError:@"设置失败"];
        }
    } failure:^(NSError *error) {
    }];
}
#pragma mark - getter
- (NSMutableDictionary *)ConsultanShareInfo{
    if (!_ConsultanShareInfo) {
        _ConsultanShareInfo = [NSMutableDictionary dictionary];
    }
    return _ConsultanShareInfo;
}
- (NSMutableArray *)dataShareArr{
    if (!_dataShareArr) {
        _dataShareArr = [NSMutableArray array];
    }
    return _dataShareArr;
}
- (MeHeader *)meheader
{
    if (!_meheader) {
        NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
        NSString * phoneNum = [NSString stringWithFormat:@"联系方式：%@", [def objectForKey:UserInfoKeyLYGWPhoneNum]];
        NSString * positionName = [def objectForKey:UserInfoKeyLYGWPosition];
        NSString * level = [def objectForKey:UserInfoKeyLYGWLevel];
        _meheader = [[MeHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _meheader.delegate = self;
        _meheader.nickName.text = [UserInfo shareUser].userName;
        _meheader.isPerson = self.isPerson;
        _meheader.headIcon.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
        _meheader.positionLab.text = positionName;
        _meheader.levelIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%@", level]];
        _meheader.headIcon.clipsToBounds = YES;
        _meheader.headIcon.contentMode = UIViewContentModeScaleAspectFill;
        _meheader.personType.text = phoneNum;
    }
    return _meheader;
}

- (MeButtonView *)buttonView
{
    if (!_buttonView) {
        CGFloat buttonViewY = 200;
        _buttonView = [[MeButtonView alloc] initWithFrame:CGRectMake(0, buttonViewY, self.view.frame.size.width,60)];
        _buttonView.delegate = self;
    }
    return _buttonView;
}
- (MeProgressView *)progressView
{
    if (!_progressView) {
        self.progressView = [MeProgressView creatProgressViewWithFrame:[UIScreen mainScreen].bounds];
        self.progressView.hidden = YES;
    }
    return _progressView;
}
#pragma mark - MeHeaderDelegate
// 点击设置 基本信息
- (void)didClickSetting
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    if (self.isPerson) {
        PersonSettingViewController *ps = [sb instantiateViewControllerWithIdentifier:@"PersonSetting"];
        [self.navigationController pushViewController:ps animated:YES];
    }else{
        OrgSettingViewController *org = [sb instantiateViewControllerWithIdentifier:@"OrgSetting"];
        [self.navigationController pushViewController:org animated:YES];
    }
  
}

// 点击头像上传照片
- (void)didClickHeadIcon
{
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册照片",@"拍照", nil];
        [sheet showInView:self.view.window];

}
//点击更多旅游顾问明细
- (void)didClickMoreLYGW{
    MoreLvYouGuWenInfoViewController * morelvyouguwen = [[MoreLvYouGuWenInfoViewController alloc]init];
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"MeTravelConsultantClick" attributes:dict];

    morelvyouguwen.webTitle = @"旅游顾问";
    [self.navigationController pushViewController:morelvyouguwen animated:YES];
}

#pragma mark - MeButtonViewDelegate
- (void)buttonViewSelectedWithIndex:(NSInteger)index
{
       switch (index) {// 我的收藏
        case 0:{
            MyListViewController *col = [[MyListViewController alloc] init];
            col.listType = collectionType;
           
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"CustomStore" attributes:dict];
            
            [self.navigationController pushViewController:col animated:YES];
            break;
        }
        case 1:{ // 我的浏览
            MyListViewController *pre = [[MyListViewController alloc] init];
            pre.listType = previewType;
            
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"CustomScanHistory" attributes:dict];
            
            [self.navigationController pushViewController:pre animated:YES];
            break;
        }
        case 2:{ // 搬救兵
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"MeSOSClickNum" attributes:dict];

            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            SosViewController *sos = [sb instantiateViewControllerWithIdentifier:@"Sos"];
            sos.isFromMe = YES;
            [self.navigationController pushViewController:sos animated:YES];
            break;
        }
        default:
            break;
    }
}

// 长按打电话
- (void)buttonViewLongPressToCall
{
    NSString *mobile = [UserInfo shareUser].sosMobile;
    if (!mobile) {
        return;
    }
    
    NSString *phone = [NSString stringWithFormat:@"tel://%@",mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

#pragma mark - RefreshNickNameDelegate
- (void)refreshNickName:(NSString *)name{
    _meheader.nickName.text = [UserInfo shareUser].userName;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.desArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    if (section == 1) {
//        NSString *isShowInvoiceManage = [[NSUserDefaults standardUserDefaults] objectForKey:IsShowInvoiceManage];
//        if ([isShowInvoiceManage isEqualToString:@"1"]) {
//            return 4;
//        }else{
//            return 3;
//
//        }
//    }
    return [self.desArr[section] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * string = [NSString stringWithFormat:@"%d", arc4random()];
//    static NSString *ID = @"mecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:string];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.desArr[indexPath.section][indexPath.row];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    switch (indexPath.section) {
        case 0://第一个分区
            cell.imageView.image = [UIImage imageNamed:@"iconfont-fenxiang"];
            break;
        case 1://第二个分区
            /*if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"lygw"];
            }else */if(indexPath.row == 0){
                if (self.isPerson) {
                    cell.imageView.image = [UIImage imageNamed:@"wodelvxingshe"];
                }else{
                    cell.textLabel.text = nil;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }

            }else if(indexPath.row == 1){
                cell.imageView.image = [UIImage imageNamed:@"money"];

            }else if(indexPath.row == 2){
                /**
                 * *摇钱树图片设置
                 **/
                cell.imageView.image = [UIImage imageNamed:@"ip600003"];
                //第一次加载
                if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstFindMoneyTree"]) {
                    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 12.5, 55, 23)];
                    imgView.image = [UIImage imageNamed:@"yaoqianshu"];
                    [cell.contentView addSubview:imgView];
                }
            }else if(indexPath.row == 3){
                cell.imageView.image = [UIImage imageNamed:@"vip"];
                UILabel *shouKeBaoL = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, 0, 100, 50)];
                shouKeBaoL.text = @"收客宝2.0";
                shouKeBaoL.textColor = [UIColor grayColor];
                shouKeBaoL.textAlignment = NSTextAlignmentCenter;
                shouKeBaoL.font = [UIFont systemFontOfSize:11.0f];
                [cell.contentView addSubview:shouKeBaoL];
                
                
                if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstOpenExclusiveVC"]) {
                    
                    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 12.5, 55, 23)];
                    imgView.image = [UIImage imageNamed:@"yaoqianshu"];
                    [cell.contentView addSubview:imgView];
                }
                
            }else if (indexPath.row == 4){
                cell.imageView.image = [UIImage imageNamed:@"Mebill"];
                if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstFindInvoiceManage"]) {
                    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 12.5, 55, 23)];
                    imgView.image = [UIImage imageNamed:@"yaoqianshu"];
                    [cell.contentView addSubview:imgView];
                }

            }
            break;
        case 2://第三个分区
            //cell.imageView.image = [UIImage imageNamed:@"zhanghu-anquan"];
            break;
        case 3://第四个分区
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = @"23时至次日8时将不会有消息";
                // 添加一个开关
                UISwitch *btn = [[UISwitch alloc] init];
                [btn addTarget:self action:@selector(changePushMode:) forControlEvents:UIControlEventValueChanged];
                btn.on = [[UserInfo shareUser].pushMode integerValue];
                cell.accessoryView = btn;
            }else if(indexPath.row == 2){
                [WMAnimations  WMNewTableViewCellWithCell:cell withRightStr:[NSString stringWithFormat:@"当前V%@", currentVersion] withImage:nil];
            }else if(indexPath.row == 3){
                if (self.versionInfoDic) {
                    if (![self.versionInfoDic[@"VersionCode"] isEqualToString:currentVersion]) {
                        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 12.5, 55, 23)];
                        imgView.image = [UIImage imageNamed:@"yaoqianshu"];
                        [cell.contentView addSubview:imgView];
                    }else{
                        [WMAnimations WMNewTableViewCellWithCell:cell withRightStr:@"已是最新版本" withImage:nil
                         ];
                    }
                }
            }
            break;
 
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    switch (indexPath.section) {
        case 0:{
            //h5界面
//            LvYouGuWenViewController * LYGW = [[LvYouGuWenViewController alloc]init];
//                           [self.navigationController pushViewController:LYGW animated:YES];
            MeShareDetailViewController *meShareDetailVC = [[MeShareDetailViewController alloc]init];
            [self.navigationController pushViewController:meShareDetailVC animated:YES];
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"MeMyShareClick" attributes:dict];

            
            break;
        }
        case 1:
            // 第一组的三个
           /*if (indexPath.row == 0) {
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"MeTravelConsultantVCClick" attributes:dict];
               //原生界面
//               TravelConsultantViewController * TCVC = [sb instantiateViewControllerWithIdentifier:@"TravelConsultantVC"];
//                [self.navigationController pushViewController:TCVC animated:YES];
               TravelConsultantViewControllerNoShare * TCTVC = [sb instantiateViewControllerWithIdentifier:@"TravelConsultantVCNS"];
               [self.navigationController pushViewController:TCTVC animated:YES];
           }else */if(indexPath.row == 0){
                MyOrgViewController *myOrg = [sb instantiateViewControllerWithIdentifier:@"MyOrg"];
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"MeOrgViewClick" attributes:dict];
                
                [self.navigationController pushViewController:myOrg animated:YES];

            }else if(indexPath.row == 1){
                // 圈付宝
                QuanViewController *quan = [[QuanViewController alloc] init];
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"MeQFBClick" attributes:dict];
                
                [self.navigationController pushViewController:quan animated:YES];

            }else if(indexPath.row == 2){
                MoneyTreeViewController * moneyTreeVC = [[MoneyTreeViewController alloc]init];
                moneyTreeVC.webTitle = @"摇钱树";
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstFindMoneyTree"];
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"MeMoenyTreeClick" attributes:dict];
                [self.navigationController pushViewController:moneyTreeVC animated:YES];
            
            }else if(indexPath.row == 3){

                NSString *level = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLYGWLevel];
                
#pragma mark---等级为2000以上 && 不是第一次打开 &&已经开通专属App－－》 走数据界面

                if ([level intValue] > 2000 && [[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstOpenExclusiveVC"]&&[self.IsOpenConsultantApp isEqualToString:@"1"]){
                    
                    ExclusiveViewController *exclusiveAPPVC = [[ExclusiveViewController alloc]init];
                    
                    exclusiveAPPVC.title = @"专属APP";
                    exclusiveAPPVC.ConsultanShareInfo = self.ConsultanShareInfo;
                    
                    NSLog(@"111 ConsultanShareInfo = %@ %@", _ConsultanShareInfo, exclusiveAPPVC.ConsultanShareInfo);
                    
                    [self.navigationController pushViewController:exclusiveAPPVC animated:YES];
                    
#pragma mark-  ｛(等级为2000以上&&第一次打开 )|| 等级不够 ||未开通专属App｝ －－－》 走专属或非专属介绍界面
                }else{
                    EstablelishedViewController *establelishedVC = [[EstablelishedViewController alloc]init];
//                    establelishedVC.clientManagerTel = self.clientMagagerTel;
                    establelishedVC.isExclusiveCustomer = self.IsOpenConsultantApp;
                    establelishedVC.ConsultanShareInfo = self.ConsultanShareInfo;
                    establelishedVC.naVC = self.navigationController;
                    
                    [self.navigationController pushViewController:establelishedVC animated:YES];
                }
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstOpenExclusiveVC"];
                
            }else if(indexPath.row == 4){
                InvoiceManageViewController * IMVC = [[InvoiceManageViewController alloc]init];
                IMVC.webTitle = @"发票管理";
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"MeInvoiceManageClick" attributes:dict];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstFindInvoiceManage"];
                [self.navigationController pushViewController:IMVC animated:YES];

            }
            break;
        case 2:
            // 第二组 单个 账号安全
//            {
//            UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Safe" bundle:nil];
//            SafeSettingViewController *safe = [sb2 instantiateViewControllerWithIdentifier:@"SafeSetting"];
//            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
//            [MobClick event:@"MeAccountSafety" attributes:dict];
//            safe.isPerson = self.isPerson;
//            [self.navigationController pushViewController:safe animated:YES];
//            }
            switch (indexPath.row) {
                case 0:{
                    NSLog(@"---%ld",indexPath.row);
                    UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Safe" bundle:nil];
                    SafeSettingViewController *safe = [sb2 instantiateViewControllerWithIdentifier:@"SafeSetting"];
                    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                    [MobClick event:@"MeAccountSafety" attributes:dict];
                    safe.isPerson = self.isPerson;
                    [self.navigationController pushViewController:safe animated:YES];
                    break;
                }
                case 1:{
                    NSLog(@"---%ld",indexPath.row);
                    FeedBcakViewController *feedBackVC = [sb instantiateViewControllerWithIdentifier:@"FeedBack"];
                    [self.navigationController pushViewController:feedBackVC animated:YES];

                    
                    break;
                }
                case 2:{
                    UIWindow *window = [UIApplication sharedApplication].delegate.window;
                    WelcomeView *welceome = [[WelcomeView alloc] initWithFrame:window.bounds];
                    welceome.alpha = 0;
                    [window addSubview:welceome];
                    // 为了看起来不突兀一些
                    [UIView animateWithDuration:0.3 animations:^{
                        welceome.alpha = 1;
                    }];

                    break;
                }
                case 3:{
                    [self checkNewVerSion];
                    /*
                     UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"需要发布之后, 才能到appstore评分" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alertView show];
                     */
                    //                NSString *str = [NSString stringWithFormat:
                    //                                 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                    //                                 587767923];
                    //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    
                    //[self checkNewVerSion];
                    break;
                }
                case 4:{
                      [self checkNewVerSion];
                      break;
                }
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 1:{
                    FeedBcakViewController *feedBackVC = [sb instantiateViewControllerWithIdentifier:@"FeedBack"];
                    [self.navigationController pushViewController:feedBackVC animated:YES];
                    break;
                }
                case 2:{
                    UIWindow *window = [UIApplication sharedApplication].delegate.window;
                    WelcomeView *welceome = [[WelcomeView alloc] initWithFrame:window.bounds];
                    welceome.alpha = 0;
                    [window addSubview:welceome];
                    // 为了看起来不突兀一些
                    [UIView animateWithDuration:0.3 animations:^{
                        welceome.alpha = 1;
                    }];
                    break;
                }
                case 3:{
                    [self checkNewVerSion];
                    /*
                     UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"需要发布之后, 才能到appstore评分" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alertView show];
                     */
                    //                NSString *str = [NSString stringWithFormat:
                    //                                 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                    //                                 587767923];
                    //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    break;
                }
                case 4:{
                    [self checkNewVerSion];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        case 4:
            
            break;
 
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isPerson && indexPath.section == 1 && indexPath.row == 0) {
        return 0.5;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
#pragma mark - 加载数据
- (void)loadIsOpenAppData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [IWHttpTool WMpostWithURL:@"/Business/GetMeIndex" params:dic success:^(id json) {
        NSLog(@"------是否专属的json is %@-------",json);
        
        [self.ConsultanShareInfo addEntriesFromDictionary:json[@"ConsultanShareInfo"]];
        self.IsOpenConsultantApp = json[@"IsOpenConsultantApp"];
//        self.clientMagagerTel = json[@""];

    } failure:^(NSError *error) {
        NSLog(@"接口请求失败 error is %@------",error);
    }];
}

#pragma mark - CheckNewVersion
- (void)checkNewVerSion{
    /*
        NSString * versionCode = self.versionInfoDic[@"VersionCode"];
        NSArray * versionInfo = self.versionInfoDic[@"VersionInfo"];
        NSMutableString * str = [NSMutableString string];
        for (int i = 0; i < versionInfo.count; i++) {
            [str appendFormat:@"%d. %@  ", i+1, versionInfo[i]];
        }
        self.checkVersionLinkUrl = self.versionInfoDic[@"LinkUrl"];
        NSString * isMust = @"不再询问";
        if ([self.versionInfoDic[@"IsMustUpdate"]isEqualToString:@"1"]) {
            isMust = @"退出程序";
        }
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
        if (![versionCode isEqualToString:currentVersion]) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:str delegate:self cancelButtonTitle:isMust otherButtonTitles:@"立即更新", nil];
            [alertView show];
        }else{
            UIAlertView * alertV = [[UIAlertView alloc]initWithTitle:@"已是最新版本" message:[NSString stringWithFormat:@"版本号：%@", versionCode] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
        }
     */
    self.checkVersionLinkUrl = self.versionInfoDic[@"LinkUrl"];
    self.IOSUpdateType = [NSString stringWithFormat:@"%@", self.versionInfoDic[@"IOSUpdateType"]];
    NSString * isMust = @"残忍拒绝";
    if ([self.versionInfoDic[@"IsMustUpdate"] integerValue] == 1) {
        isMust = @"退出程序";
    }
    NSArray * infoArray = self.versionInfoDic[@"VersionInfo"];
    NSMutableString * infoString = [NSMutableString stringWithCapacity:1];
    for (int i = 0; i < infoArray.count; i++) {
        [infoString appendFormat:@"%d.%@  ",i + 1, [infoArray objectAtIndex:i]];
    }
    if ([self.versionInfoDic[@"IsHaveNewVersion"]integerValue] == 1) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:infoString delegate:self cancelButtonTitle:isMust otherButtonTitles:@"立即更新", nil];
        [alertView show];
    }else{
        UIAlertView * alertViewNOVersion = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已是最新版" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertViewNOVersion show];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //进入更新页面
        if ([self.IOSUpdateType isEqualToString:@"0"]) {
            NewVersionWebViewController * NVWVC = [[NewVersionWebViewController alloc]init];
            NVWVC.LinkUrl = self.checkVersionLinkUrl;
            [self.navigationController pushViewController:NVWVC animated:YES];
        }else{
            //             NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8", @"797395756"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.checkVersionLinkUrl]];
        }
    }else{
        if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"退出程序"]) {
            exit(0);
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = 0;
    switch (buttonIndex) {
        case 0:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 1:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        default:
            break;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    NSLog(@"----%@",info);
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    UIImage * newImage = [ResizeImage reSizeImage:image toSize:CGSizeMake(120, 120)];
    self.meheader.headIcon.image = newImage;
    NSData *data = UIImageJPEGRepresentation(newImage, 1.0);
    NSString *imageStr = [data base64EncodedStringWithOptions:0];
    
    [IWHttpTool postWithURL:@"Business/UploadBusinessHeader" params:@{@"FileStreamData":imageStr,@"PictureType":self.isPerson?@"5":@"6"} success:^(id json) {
        NSLog(@"%@*******", json);
        if (![json[@"PicUrl"]isEqualToString:@""]) {
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"MeChangeHeaderIconClick" attributes:dict];

            [[NSUserDefaults standardUserDefaults]setObject:json[@"PicUrl"] forKey:UserInfoKeyLoginAvatar];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
    } failure:^(NSError * error) {
        
    }];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:UIImageJPEGRepresentation(image, 0.3) forKey:@"userhead"];
    [def synchronize];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < 0){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}
#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 1) {
//        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//        
//        //CFShow((__bridge CFTypeRef)(infoDic));
//        
//        NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
//        NSLog(@"!!!%@", currentVersion);
//        NSLog(@"立即更新");
//    }else{
//        if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"退出程序"]) {
//            exit(0);
//        }
//    }
//}
#pragma mark - FindNew
- (void)findnew:(id)sender {
    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    if (isAllow != nil) {
        SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
        sKStoreProductViewController.delegate = self;
        [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: @"594467299"}
                                                completionBlock:^(BOOL result, NSError *error) {
                                                    if (result) {
                                                        [self presentViewController:sKStoreProductViewController
                                                                           animated:YES
                                                                         completion:nil];
                                                    }
                                                    else{
                                                        NSLog(@"%@",error);
                                                    }
                                                }];
    }
    else{
        //低于iOS6没有这个类
        NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",@"594467299"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
    //    SKStoreProductViewController * storeProductViewController = [[SKStoreProductViewController alloc] init];
    //    [storeProductViewController setDelegate:self];
    //    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"594467299"} completionBlock:^(BOOL result, NSError *error) {
    //        if(error)
    //        {
    //            NSLog(@"Error %@ with user info %@",error,[error userInfo]);
    //        }
    //        else
    //        {
    //            [self presentViewController:storeProductViewController animated:YES completion:nil];
    //        }
    //    }];
    
    
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    
    
    [viewController dismissViewControllerAnimated:YES
                                       completion:nil];
    
    
}
@end
