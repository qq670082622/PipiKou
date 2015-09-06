//
//  PersonSettingViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "PersonSettingViewController.h"
#import "MeHttpTool.h"
#import "Trader.h"
#import "CityViewController.h"
#import "MBProgressHUD+MJ.h"
#import "UserInfo.h"
#import "MobClick.h"
@interface PersonSettingViewController ()<CityViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nickName;

@property (weak, nonatomic) IBOutlet UITextField *address;

@property (weak, nonatomic) IBOutlet UITextField *sign;

@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UITextField *wechat;

@property (weak, nonatomic) IBOutlet UITextView *remark;

@property (nonatomic,strong) Trader *trader;

@property (weak, nonatomic) IBOutlet UIButton *maleBtn;

@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@property (strong, nonatomic) IBOutlet UIButton *place;
@end

@implementation PersonSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改资料";
    self.tableView.tableHeaderView.hidden = YES;
  //  [self setNav];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(submit)];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
        
    [self.maleBtn setBackgroundImage:[UIImage imageNamed:@"nan0"] forState:UIControlStateNormal];
    [self.maleBtn setBackgroundImage:[UIImage imageNamed:@"nan1"] forState:UIControlStateSelected];
    
    [self.femaleBtn setBackgroundImage:[UIImage imageNamed:@"nv0"] forState:UIControlStateNormal];
    [self.femaleBtn setBackgroundImage:[UIImage imageNamed:@"nv1"] forState:UIControlStateSelected];
    
    [self loadDataSource];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MePersonSettingViewController"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MePersonSettingViewController"];
}


- (IBAction)gender:(UIButton *)sender
{
    self.maleBtn.selected = NO;
    self.femaleBtn.selected = NO;
    
    sender.selected = !sender.selected;
}
- (IBAction)chosesCity:(UIButton *)sender {
    CityViewController * cityVC = [[CityViewController alloc]init];
    cityVC.delegate = self;
    cityVC.selectedCityName = self.place.titleLabel.text;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - loadDataSource
- (void)loadDataSource
{
    [MeHttpTool getDistributionWithsuccess:^(id json) {
        NSLog(@"-----%@",json);
        if (![json[@"Distribution"] isKindOfClass:[NSNull class]]) {
            
            self.trader = [Trader traderWithDict:json[@"Distribution"]];
            self.nickName.text = self.trader.Name;
            self.address.text = self.trader.Address;
            self.sign.text = self.trader.Signature;
            self.phone.text = self.trader.Mobile;
            self.wechat.text = self.trader.WeiXinCode;
            self.remark.text = self.trader.Desc;
//            self.place.titleLabel.text = self.trader.City;
            
            //先写死 mark一下
            if ([[NSUserDefaults standardUserDefaults]valueForKey:@"City"]) {
            self.place.titleLabel.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"City"];
            }
            if ([self.trader.Sex integerValue] == 1) {
                self.maleBtn.selected = YES;
            }else{
                self.femaleBtn.selected = YES;
            }
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - private
- (void)submit
{
    NSDictionary *param = @{@"Distribution":@{@"ID":self.trader.ID,
                                              @"Name":self.nickName.text,
                                              @"Sex":self.maleBtn.selected ? @"1" : @"2",
                                              @"Address":self.address.text,
                                              @"Signature":self.sign.text,
                                              @"Mobile":self.phone.text,
                                              @"WeiXinCode":self.wechat.text,
                                              @"Desc":self.remark.text,
//                                              @"City":self.place.titleLabel.text
                                              }
                            };
    [MeHttpTool setDistributionWithParam:param success:^(id json) {
        NSLog(@"-----%@——————————————————————",json);
        if ([json[@"IsSuccess"] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults]setValue:self.place.titleLabel.text forKey:@"City"];
            [[NSUserDefaults standardUserDefaults]synchronize];

            [[UserInfo shareUser]setValue:self.nickName.text forKey:@"userName"];
            [MBProgressHUD showSuccess:@"保存成功"];

            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - CityViewControllerDelegate
- (void)didSelectedWithCity:(NSString *)city{
    self.place.titleLabel.text = city;
}
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

@end
