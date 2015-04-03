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

@interface ChildAccountViewController ()

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ChildAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择账号";
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self loadDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - private
- (void)loadDataSource
{
    [self.dataSource removeAllObjects];
    [LoginTool getDistributionListWithSuccess:^(id json) {
        NSLog(@"--------%@",json);
        if ([json[@"IsSuccess"] integerValue] == 1) {
            
            dispatch_queue_t q = dispatch_queue_create("distribution_q", DISPATCH_QUEUE_SERIAL);
            dispatch_async(q, ^{
                
                [self.dataSource addObject:json[@"BusinessInfo"][@"Text"]];
                for (NSDictionary *dic in json[@"DistributionList"]) {
                    Distribution *dis = [Distribution distributionWithDict:dic];
                    [self.dataSource addObject:dis];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
        }
    } failure:^(NSError *error){
        
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
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"childaccountcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"iconfont-dianpu"];
        cell.textLabel.text = self.dataSource[indexPath.row];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"iconfont-wo"];
        Distribution *dis = self.dataSource[indexPath.row];
        cell.textLabel.text = dis.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row == 0) {
        Distribution *dis = self.dataSource[indexPath.row];
        
        // 去绑定手机
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
        BindPhoneViewController *bind = [sb instantiateViewControllerWithIdentifier:@"BindPhone"];
        bind.distributionId = dis.distributionId;
        [self.navigationController pushViewController:bind animated:YES];
    }else{
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app setTabbarRoot];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
