//
//  OrgSettingViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "OrgSettingViewController.h"
#import "CityViewController.h"
#import "MeHttpTool.h"
#import "Organization.h"
#import "MobClick.h"
#import "MBProgressHUD+MJ.h"
#import "UserInfo.h"
@interface OrgSettingViewController () <UIScrollViewDelegate, CityViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *comanyName;

@property (weak, nonatomic) IBOutlet UITextField *address;

@property (weak, nonatomic) IBOutlet UITextField *touchMan;

@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *qq;

@property (weak, nonatomic) IBOutlet UITextField *wechat;

@property (weak, nonatomic) IBOutlet UITextView *remark;

@property (nonatomic,strong) Organization *org;

@end

@implementation OrgSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改资料";
   // [self setNav];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self loadDataSource];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MeOrgSettingViewController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MeOrgSettingViewController"];
}

#pragma mark - loadDataSource
- (void)loadDataSource
{
    [MeHttpTool getBusinessWithsuccess:^(id json) {
        if (![json[@"Busienss"] isKindOfClass:[NSNull class]]) {
            NSLog(@"-----%@",json);
            self.org = [Organization organizationWithDict:json[@"Busienss"]];
            self.comanyName.text = self.org.Name;
            self.address.text = self.org.Address;
            self.touchMan.text = self.org.ContactName;
            self.phone.text = self.org.ContactMobile;
            self.email.text = self.org.Email;
            self.qq.text = self.org.QQCode;
            self.wechat.text = self.org.WeiXinCode;
            self.remark.text = self.org.Desc;
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - private
//- (void)setNav
//{
//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    
//    self.navigationItem.leftBarButtonItem= leftItem;
//}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submit
{
    NSDictionary *param = @{@"Busienss" : @{@"ID":self.org.ID,
                                            @"Name":self.comanyName.text,
                                            @"Address":self.address.text,
                                            @"ContactName":self.touchMan.text,
                                            @"ContactMobile":self.phone.text,
                                            @"Email":self.email.text,
                                            @"QQCode":self.qq.text,
                                            @"WeiXinCode":self.wechat.text,
                                            @"Desc":self.remark.text}
                            };
    [MeHttpTool setBusinessWithParam:param success:^(id json) {
        if ([json[@"IsSuccess"] integerValue] == 1) {
            [[UserInfo shareUser]setValue:self.comanyName.text forKey:@"userName"];
            [MBProgressHUD showSuccess:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableviewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        NSLog(@"----");
        CityViewController *city = [[CityViewController alloc] init];
        city.delegate = self;

        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:city];
        [self presentViewController:nav animated:YES completion:nil];
//        [self.navigationController pushViewController:city animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - CityViewControllerDelegate
- (void)didSelectedWithCity:(NSString *)city
{
//    self.place.text = city;
}

@end
