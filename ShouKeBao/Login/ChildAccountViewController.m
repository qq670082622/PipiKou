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

@interface ChildAccountViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,CreatePersonControllerDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) BOOL isOpenSkb;// 是否开通收客宝

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
                    Distribution *dis = [Distribution distributionWithDict:dic];
                    [self.dataSource addObject:dis];
                }
                // 如果没有开通收客宝
                self.isOpenSkb = [json[@"IsOpenSkb"] integerValue];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 取出参数
        Distribution *dis = self.dataSource[indexPath.row];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        // 绑定收客宝 选择分销人或者旅行社
        NSDictionary *param = @{@"AppUserID":[def objectForKey:UserInfoKeyAppUserID],
                                @"DistributionID":dis.distributionId,
                                @"LoginType":dis.SkbType};
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LoginTool chooseUserWithParam:param success:^(id json) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"----  %@",json);
            
            if ([json[@"IsSuccess"] integerValue] == 1) {
                
                // 保存必要的参数
                [def setObject:json[@"LoginType"] forKey:UserInfoKeyLoginType];
                [def setObject:json[@"DistributionID"] forKey:UserInfoKeyDistributionID];
                [def setObject:json[@"LoginAvatar"] forKey:UserInfoKeyLoginAvatar];
                
                // 保存用户模型
                [UserInfo userInfoWithDict:json];
                
                // 保存分站
                if (![def objectForKey:UserInfoKeySubstation]) {
                    [def setObject:[NSString stringWithFormat:@"%ld",(long)[json[@"SubstationId"] integerValue]] forKey:UserInfoKeySubstation];
                }
                [def synchronize];
                
                // 给用户打上jpush标签
                [APService setAlias:[def objectForKey:@"BusinessID"] callbackSelector:nil object:nil];
                NSString *tag = [NSString stringWithFormat:@"substation_%ld",(long)[json[@"SubstationId"] integerValue]];
                [APService setTags:[NSSet setWithObject:tag] callbackSelector:nil object:nil];
                
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
        
    }else{
        // 去创建分销人 或者 开通收客宝
        CreatePersonController *create = [[CreatePersonController alloc] initWithStyle:UITableViewStyleGrouped];
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
    
    // 刷新数据
    [self loadDataSource];
}

@end
