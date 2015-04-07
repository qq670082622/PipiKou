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

@interface PersonSettingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickName;

@property (weak, nonatomic) IBOutlet UITextField *address;

@property (weak, nonatomic) IBOutlet UITextField *sign;

@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UITextField *wechat;

@property (weak, nonatomic) IBOutlet UITextView *remark;

@property (nonatomic,strong) Trader *trader;

@property (weak, nonatomic) IBOutlet UIButton *maleBtn;

@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@end

@implementation PersonSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self.maleBtn setBackgroundImage:[UIImage imageNamed:@"nan0"] forState:UIControlStateNormal];
    [self.maleBtn setBackgroundImage:[UIImage imageNamed:@"nan1"] forState:UIControlStateSelected];
    
    [self.femaleBtn setBackgroundImage:[UIImage imageNamed:@"nv0"] forState:UIControlStateNormal];
    [self.femaleBtn setBackgroundImage:[UIImage imageNamed:@"nv1"] forState:UIControlStateSelected];
    
    [self loadDataSource];
}


- (IBAction)gender:(UIButton *)sender
{
    self.maleBtn.selected = NO;
    self.femaleBtn.selected = NO;
    
    sender.selected = !sender.selected;
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
    NSDictionary *param = @{@"ID":self.trader.ID,
                            @"Name":self.nickName.text,
                            @"Sex":self.maleBtn.selected ? @"1" : @"2",
                            @"Address":self.address.text,
                            @"Signature":self.sign.text,
                            @"Mobile":self.phone.text,
                            @"WeiXinCode":self.wechat.text,
                            @"Desc":self.remark.text};
    [MeHttpTool setDistributionWithParam:param success:^(id json) {
        if ([json[@"IsSuccess"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
