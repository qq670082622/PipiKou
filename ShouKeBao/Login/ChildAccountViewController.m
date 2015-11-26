//
//  ChildAccountViewController.m
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ChildAccountViewController.h"
#import "LoginTool.h"
#import "UserInfo.h"
#import "Distribution.h"
#import "AppDelegate.h"
#import "Business.h"
#import "Login.h"
#import "UIImageView+WebCache.h"
#import "NSMutableDictionary+QD.h"
#import "MBProgressHUD+MJ.h"
#import "CreatePersonController.h"
#import "WMNavigationController.h"
#import "ChildCell.h"
#import "AppDelegate.h"
#import "MobClick.h"
#import "UMessage.h"
#import "EaseMob.h"
@interface ChildAccountViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,CreatePersonControllerDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) BOOL isOpenSkb;// 是否开通收客宝
@property (nonatomic, assign)BOOL isCreat;
@property (nonatomic, assign)BOOL isSKB;
@end

@implementation ChildAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"选择收客宝";
    
//    UIImage *image = [UIImage imageNamed:@"beijing"];
//    self.view.layer.contents = (id) image.CGImage;
    
    // 请求数据
    [self loadDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LogibChildAccountView"];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LogibChildAccountView"];

}
#pragma mark - loadDataSource
- (void)loadDataSource
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [LoginTool getUserListWithParam:@{} success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([json[@"IsSuccess"] integerValue] == 1) {
            
            // 先清空 免除干扰
            [self.dataSource removeAllObjects];
            
            if (![json[@"SkbList"] isKindOfClass:[NSNull class]]) {
                
                for (NSDictionary *dic in json[@"SkbList"]) {
                    NSLog(@"%@", dic);
                    Distribution *dis = [Distribution distributionWithDict:dic];
                    [self.dataSource addObject:dis];
                }
                if (self.isCreat && !self.isSKB) {
                    
                    /*  此处跳转节点，慎重！会崩的哦  */
                    NSLog(@"%@", ((Distribution *)self.dataSource[0]).SkbType);
                    if ([((Distribution *)self.dataSource[0]).SkbType isEqualToString:@"1"]) {
                        [self bangdingWith:self.dataSource[1]];
                    }else{
                    [self bangdingWith:self.dataSource[0]];
                    }
                    
                    
                    
                }
                self.isCreat = NO;
                // 如果没有开通收客宝
                self.isOpenSkb = [json[@"IsOpenSkb"] integerValue];
                NSLog(@"%@", json[@"IsOpenSkb"]);
                // 刷新
                [self.tableView reloadData];
            }
        }else{
            [MBProgressHUD showError:json[@"ErrorMsg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - private


#pragma mark - getter
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataSource.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildCell *cell = [ChildCell cellWithTableView:tableView];
    
    if (indexPath.section == 0) {
        Distribution *dis = self.dataSource[indexPath.row];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:dis.icon] placeholderImage:[UIImage imageNamed:@"bigIcon"]];
        cell.nameLab.text = dis.name;
        NSLog(@"$$$$%@", dis.IsOpenConsultantApp);
        if (indexPath.row != 0) {
            cell.VIPIsOpen.hidden = ![dis.IsOpenConsultantApp integerValue];
        }
        cell.textLabel.textColor = [UIColor blackColor];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"jia"];
        if (self.isOpenSkb){
            cell.textLabel.text = @"添加收客宝";
        }else{
            cell.textLabel.text = @"申请开通";
            cell.textLabel.textColor = [UIColor blueColor];
        }
    }
    
    return cell;
}
- (void)bangdingWith:(Distribution *)dis{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    // 绑定收客宝 选择分销人或者旅行社
    NSDictionary *param = @{@"AppUserID":[def objectForKey:UserInfoKeyAppUserID],
                            @"DistributionID":dis.distributionId,
                            @"LoginType":dis.SkbType};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [LoginTool chooseUserWithParam:param success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"---- ＃＃＃＃＃＃＃＃＃＃＃＃ %@",json);
        
        if ([json[@"IsSuccess"] integerValue] == 1) {
            [def setObject:@"1" forKey:@"isLogoutYet"];
            // 保存必要的参数
            [def setObject:json[@"LoginType"] forKey:UserInfoKeyLoginType];
            [def setObject:json[@"DistributionID"] forKey:UserInfoKeyDistributionID];

            [def setObject:json[@"AppUserID"] forKey:UserInfoKeyAppUserID];
            [def setObject:json[@"EasemobPwd"] forKey:UserInfoKeyEasemobPassWord];

            
#warning 保存旅游顾问等级和链接 //旅游顾问
            NSDictionary * ConsultantInfoDic = json[@"ConsultantInfo"];
            [def setObject:ConsultantInfoDic[@"Level"] forKey:UserInfoKeyLYGWLevel];//等级
            [def setObject:ConsultantInfoDic[@"LinkUrl"] forKey:UserInfoKeyLYGWLinkUrl];//链接
            [def setObject:ConsultantInfoDic[@"Position"] forKey:UserInfoKeyLYGWPosition];//职位
            [def setObject:ConsultantInfoDic[@"SkbMobile"] forKey:UserInfoKeyLYGWPhoneNum];//电话
            NSString *IsLYGWStr = json[@"IsOpenConsultantApp"];
            NSLog(@"%@",IsLYGWStr);
            [def setObject:IsLYGWStr forKey:UserInfoKeyLYGWIsOpenVIP];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:UserInfoKeyIsShowQuanTouTiao];

            [def synchronize];
            
            if (![json[@"LoginAvatar"]isEqual:[NSNull null]]) {
                [def setObject:json[@"LoginAvatar"] forKey:UserInfoKeyLoginAvatar];
            }
            NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
            [accountDefaults setObject:[NSString stringWithFormat:@"%@", json[@"SubstationId"]] forKey:UserInfoKeySubstation];
            [accountDefaults setObject:json[@"SubstationName"] forKey:@"SubstationName"];
            [accountDefaults setObject:@"yes" forKey:@"stationSelect"];//改变分站时通知Findproduct刷新列表
            [accountDefaults setObject:@"yes" forKey:@"stationSelect2"];//改变分站时通知首页刷新列表
            [accountDefaults synchronize];

            // 保存用户模型
            [UserInfo userInfoWithDict:json];
            
            // 保存分站
            if (![def objectForKey:UserInfoKeySubstation]) {
                [def setObject:[NSString stringWithFormat:@"%ld",(long)[json[@"SubstationId"] integerValue]] forKey:UserInfoKeySubstation];
            }
            [def synchronize];

            //环信登录
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:json[@"AppUserID"] password:json[@"EasemobPwd"] completion:^(NSDictionary *loginInfo, EMError *error) {
                if (!error && loginInfo) {
                    [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                    NSLog(@"绑定登陆成功");
                }
            } onQueue:nil];

            
            [UMessage removeAllTags:^(id responseObject, NSInteger remain, NSError *error) {
            }];
            NSString *tag = [NSString stringWithFormat:@"substation_%ld",(long)[json[@"SubstationId"] integerValue]];
            
            //给用户打上友盟标签
            [UMessage addTag:tag
                    response:^(id responseObject, NSInteger remain, NSError *error) {
                        //add your codes
                    }];
            NSString * string = [NSString stringWithFormat:@"business_%@", [def objectForKey:UserInfoKeyBusinessID]];
//            [UMessage addTag:string response:nil];
            [UMessage addTag:string response:^(id responseObject, NSInteger remain, NSError *error) {
                NSLog(@"%@%ld", responseObject,remain);

            }];

            [UMessage addAlias:[NSString stringWithFormat:@"appuser_%@", [def valueForKey:@"AppUserID"]] type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
            }];

//            if ([UserInfo isOnlineUserWithBusinessID:@"1"]) {
//                [MobClick startWithAppkey:@"55895cfa67e58eb615000ad8" reportPolicy:BATCH   channelId:@"Web"];
//                NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//                [MobClick setAppVersion:version];
//            }

            
            
            
            
            // 保存是否第一次做登录流程
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:@"1" forKey:@"isFirst"];
            [def synchronize];
            
            // 跳转主界面
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            [app setTabbarRoot];
            
        }else{
            [MBProgressHUD showError:json[@"ErrorMsg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 取出参数
        Distribution *dis = self.dataSource[indexPath.row];
        [self bangdingWith:dis];
        
    }else{
        // 去创建分销人 或者 开通收客宝
        CreatePersonController *create = [[CreatePersonController alloc] initWithStyle:UITableViewStyleGrouped];
        NSLog(@"%d", self.isOpenSkb);
        create.delegate = self;
        create.createType = self.isOpenSkb ? CreatePersonType : CreateSKBType;
        WMNavigationController *nav = [[WMNavigationController alloc] initWithRootViewController:create];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (!self.isOpenSkb) {
            
            UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
            
            UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, self.view.frame.size.width - 40, 20)];
            tip.font = [UIFont systemFontOfSize:17];
            tip.text = @"您还没有开通收客宝哦!";
            [cover addSubview:tip];
            
            return cover;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.isOpenSkb) {
            return 10.0f;
        }else{
            return 35.0f;
        }
    }else{
        return 0.01f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

#pragma mark - CreatePersonControllerDelegate
- (void)didFinishCreateSkb:(CreatePersonController *)createVc
{
    [createVc dismissViewControllerAnimated:YES completion:nil];
    self.isSKB = (createVc.createType == CreateSKBType) ? YES : NO;
    self.isCreat = YES;
    // 刷新数据
    [self loadDataSource];
    
}

@end
