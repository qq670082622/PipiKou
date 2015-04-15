//
//  BindPhoneViewController.m
//  ShouKeBao
//
//  Created by Chard on 15/3/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "WriteFileManager.h"
#import "LoginTool.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "ChildAccountViewController.h"
#import "MBProgressHUD+MJ.h"
#import "Business.h"

@interface BindPhoneViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;// 手机号

@property (weak, nonatomic) IBOutlet UITextField *code;// 验证码

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;// 下一步按钮

@property (nonatomic,copy) NSString *getCode;

@property (nonatomic,strong) NSMutableArray *businessList;// 旅行社列表


@property (nonatomic,assign) NSInteger count;
@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    self.nextBtn.layer.cornerRadius = 25;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.enabled = NO;
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"red-bg"] forState:UIControlStateNormal];
    
    // 设置头部图标
    [self setupHeader];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beijing"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - getter
- (NSMutableArray *)businessList
{
    if (!_businessList) {
        _businessList = [NSMutableArray array];
    }
    return _businessList;
}

#pragma mark - private
/**
 *  设置头部图标
 */
- (void)setupHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    cover.backgroundColor = [UIColor clearColor];
    
    CGFloat iconX = (self.view.frame.size.width - 100) * 0.5;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 25, 100, 100)];
    iconView.backgroundColor = [UIColor clearColor];
    iconView.image = [UIImage imageNamed:@"bigIcon"];
    iconView.layer.shadowColor = [UIColor blackColor].CGColor;
    iconView.layer.shadowOpacity = 0.3;
    iconView.layer.shadowOffset = CGSizeMake(5, 5);
    [cover addSubview:iconView];
    
    self.tableView.tableHeaderView = cover;
}

/**
 *  获取验证码
 */
- (IBAction)getCode:(id)sender
{
    if (self.phoneNum.text.length) {
        
        NSDictionary *param = @{@"Mobile" :self.phoneNum.text};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LoginTool getCodeWithParam:param success:^(id json) {
            NSLog(@"---%@",json);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([json[@"IsSuccess"] integerValue] == 1) {
                
                self.count = 60;
                self.codeBtn.enabled = NO;
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                
                self.nextBtn.enabled = YES;
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}

- (void)countDown:(NSTimer *)timer
{
    if (self.count > 0) {
        self.count --;
        self.codeBtn.titleLabel.text = [NSString stringWithFormat:@"重新发送%ld",(long)self.count];
        [self.codeBtn setTitle:[NSString stringWithFormat:@"重新发送%ld",(long)self.count] forState:UIControlStateNormal];
    }else{
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [timer invalidate];
    }
}

/**
 *  下一步
 */
- (IBAction)bindAccount:(id)sender
{
//    if ([self.code.text integerValue] == [self.getCode integerValue]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *param = @{@"Mobile":self.phoneNum.text,
                                @"VerificationCode":self.code.text};
        [LoginTool checkCodeWithParam:param success:^(id json) {
            NSLog(@"---%@",json);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            if ([json[@"IsSuccess"] integerValue] == 1) {
                
                [UserInfo userInfoWithDict:json];
                [def setObject:json[@"BusinessID"] forKey:@"BusinessID"];
                [def setObject:json[@"DistributionID"] forKey:@"DistributionID"];
                [def setObject:json[@"LoginType"] forKey:@"LoginType"];
                
                if (![json[@"ShowName"] isKindOfClass:[NSNull class]]) {
                    [def setObject:json[@"ShowName"] forKey:@"ShowName"];
                }
                if (![json[@"LoginAvatar"] isKindOfClass:[NSNull class]]) {
                    [def setObject:json[@"LoginAvatar"] forKey:@"loginavatar"];
                }
                
                if (![json[@"BusinessList"] isKindOfClass:[NSNull class]]) {
                    
                    // 整理旅行社列表
                    [self.businessList removeAllObjects];
                    for (NSDictionary *dic in json[@"BusinessList"]) {
                        Business *business = [Business businessWithDict:dic];
                        [self.businessList addObject:business];
                    }
                    
                    // 储存手机号 证明已经绑定过手机
                    
                    [def setObject:self.phoneNum.text forKey:@"phonenumber"];
                    [def synchronize];
                    
                    // 去选择旅行社
                    ChildAccountViewController *child = [[ChildAccountViewController alloc] init];
                    child.dataSource = self.businessList;
                    [self.navigationController pushViewController:child animated:YES];
                }
            }
        } failure:^(NSError *error) {
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    
//    }else{
//        [MBProgressHUD showError:@"验证码错误" toView:self.view.window];
//    }
}

#pragma mark - tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 20)];
    title.text = @"输入手机号码绑定您的个人收客宝账号";
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = [UIColor blackColor];
    [cover addSubview:title];
    
    return cover;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
