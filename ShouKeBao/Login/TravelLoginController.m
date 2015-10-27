//
//  TravelLoginController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/5/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "TravelLoginController.h"
#import "BindPhoneViewController.h"
#import "UIImage+QD.h"
#import "ChildAccountViewController.h"
#import "LoginTool.h"
#import "MBProgressHUD+MJ.h"
#import "UserInfo.h"
#import "RegisterViewController.h"
#import "WMNavigationController.h"
#import "ScanningViewController.h"
#import "MobClick.h"
#import "UMessage.h"
@interface TravelLoginController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageBg1;

@property (weak, nonatomic) IBOutlet UIImageView *imageBg2;

@property (weak, nonatomic) IBOutlet UITextField *accountField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

//@property (weak, nonatomic) IBOutlet UIButton *getNewUser;
//
//@property (weak, nonatomic) IBOutlet UIButton *cardBtn;


//-(IBAction)Card;
//-(IBAction)registerUser;
@end

@implementation TravelLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setOtherBtn];
  

    self.title = @"登录旅游圈平台";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.enabled = YES;
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"red-bg"] forState:UIControlStateNormal];
    
    self.imageBg1.image = self.imageBg2.image = [UIImage resizedImageWithName:@"bg_white"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self.view addGestureRecognizer:tap];
    
    // 如果是切换用户进来的 就设置个取消
    if (self.isChangeUser) {
        [self setNavCancel];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountFieldTextChange:) name:UITextFieldTextDidChangeNotification object:self.accountField];
    
   

    //    self.accountField.text = @"huangfuyuhan@pipikou.com";
//    self.passwordField.text = @"123456";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LoginTravelLogin"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LoginTravelLogin"];
}

- (void)setOtherBtn
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 注册用户按钮
  //*********
    CGFloat newW = 25;
    CGFloat newH = 25;
    CGFloat newX = 50;
    
    
//        CGFloat newW = 25;
//    CGFloat newH = 25;
//    CGFloat newX = screenRect.size.width/2 - 12.5;
CGFloat newY = screenRect.size.height - newH - 35 - 64;
    
    UIButton *new = [[UIButton alloc] initWithFrame:CGRectMake(newX, newY, newW, newH)];
    [new addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    
    [new setBackgroundColor:[UIColor clearColor]];
    [new setBackgroundImage:[UIImage imageNamed:@"newUserImage"] forState:UIControlStateNormal];
    new.contentMode = UIViewContentModeScaleAspectFill;
    
    CGFloat newBtnCenterX = new.center.x;
    UILabel *labNew = [[UILabel alloc] initWithFrame:CGRectMake(newBtnCenterX-20, CGRectGetMaxY(new.frame), 40, 20)];
    labNew.text = @"新用户";
    labNew.font = [UIFont systemFontOfSize:11];
    labNew.textColor = [UIColor grayColor];
    labNew.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labNew];
    [self.view addSubview:new];
    
    //分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(screenRect.size.width/2, newY, 0.5, 35)];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    //******
//    line.hidden = YES;
    //证照神器
    CGFloat cardX = self.view.frame.size.width - 50 - newW - 5;
    UIButton *card = [[UIButton alloc] initWithFrame:CGRectMake(cardX, newY-18, newW+5, newH+18)];
    [card addTarget:self action:@selector(Card) forControlEvents:UIControlEventTouchUpInside];
    [card setBackgroundColor:[UIColor clearColor]];
    [card setBackgroundImage:[UIImage imageNamed:@"cardDigital"] forState:UIControlStateNormal];
    card.contentMode = UIViewContentModeScaleAspectFill;
    
    CGFloat cardCenterX = card.center.x;
    UILabel *labCard = [[UILabel alloc] initWithFrame:CGRectMake(cardCenterX-25, CGRectGetMaxY(card.frame), 50, 20)];
        labCard.text = @"证照神器";
    labCard.font = [UIFont systemFontOfSize:11];
    labCard.textColor = [UIColor blueColor];
    labCard.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labCard];
    
    [self.view addSubview:card];
    
    //********
//   labCard.hidden = YES;
//   card.hidden = YES;
    
}

/**
 *  跳转注册页面
 */
- (void)registerUser
{
    //self.isModal = YES;
    
    RegisterViewController *reg = [[RegisterViewController alloc] init];
    WMNavigationController *nav = [[WMNavigationController alloc] initWithRootViewController:reg];
    [self presentViewController:nav animated:YES completion:nil];
}
//跳转证件页面
-(void)Card
{
    
    ScanningViewController *scan = [[ScanningViewController alloc] init];
    scan.isLogin = NO;
    [self.navigationController pushViewController:scan animated:YES];
    [MobClick event:@"ScanClickNumUnlogin"];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private
// 监听输入
- (void)accountFieldTextChange:(NSNotification *)noty
{
//    UITextField *field = (UITextField *)noty.object;
    
//    self.loginBtn.enabled = field.text.length;
}

// 登录旅行社账号
- (IBAction)loginAction:(UIButton *)sender
{
    if ([self.accountField.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"账号不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
    NSDictionary *param = @{@"LoginName":self.accountField.text,
                            @"LoginPassword":self.passwordField.text};
    [UMessage removeAllTags:^(id responseObject, NSInteger remain, NSError *error) {
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // 请求登录
    [LoginTool travelLoginWithParam:param success:^(id json) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"-----  %@",json);
        
        if ([json[@"IsSuccess"] integerValue] == 1) {
            
            // 保存businessid
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:json[@"BusinessID"] forKey:UserInfoKeyBusinessID];
            [def setObject:self.accountField.text forKey:UserInfoKeyAccount];
            [def setObject:self.passwordField.text forKey:UserInfoKeyPassword];
            [def setObject:self.passwordField.text forKey:UserInfoKeyAccountPassword];

            [def synchronize];
            
            if (self.isChangeUser) {
                
                ChildAccountViewController *child = [[ChildAccountViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [self.navigationController pushViewController:child animated:YES];
            }else{
                
                // 成功后 继续绑定手机
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Auth" bundle:nil];
                BindPhoneViewController *bind = [sb instantiateViewControllerWithIdentifier:@"BindPhone"];
                bind.isForget = NO;
                [self.navigationController pushViewController:bind animated:YES];
            }
        }else{
            [MBProgressHUD showError:json[@"ErrorMsg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        
    }];
    }
}

// 退出编辑
- (void)tapHandle:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
}

// 设置取消按钮
- (void)setNavCancel
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
}

// 取消
- (void)cancel:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
