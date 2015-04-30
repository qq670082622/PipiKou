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
#import "APService.h"
#import "NSDate+Category.h"
#import "QuanViewController.h"
#import "MeHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "WelcomeView.h"

@interface Me () <MeHeaderDelegate,MeButtonViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) MeHeader *meheader;

@property (nonatomic,strong) MeButtonView *buttonView;

@property (nonatomic,strong) NSArray *desArr;

@property (nonatomic,assign) BOOL isPerson;//是否个人

@end

@implementation Me

#pragma mark - lifecircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    
    self.tableView.rowHeight = 50;
    
    self.desArr = @[@[@"我的旅行社",@"圈付宝"],@[@"账号安全设置"],@[@"勿扰模式",@"意见反馈",@"关于旅游圈",@"评价旅游圈"]];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *loginType = [def objectForKey:@"LoginType"];
    self.isPerson = [loginType integerValue] != 1;
    
    // 知道登录类型以后 设置头部
    [self setHeader];
    
    // 设置头像
    NSString *head = [UserInfo shareUser].LoginAvatar;
    if (head) {
        [self.meheader.headIcon sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@""]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - private
// 设置头部
- (void)setHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
    
    [cover addSubview:self.meheader];
    [cover addSubview:self.buttonView];
    
    self.tableView.tableHeaderView = cover;
}

// 设置固定时间段免打扰
- (void)changePushMode:(UISwitch *)modeSwitch
{
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
- (MeHeader *)meheader
{
    if (!_meheader) {
        _meheader = [[MeHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _meheader.delegate = self;
        _meheader.nickName.text = [UserInfo shareUser].userName;
        _meheader.isPerson = self.isPerson;
        _meheader.personType.text = self.isPerson ? @"个人分销商" : @"旅行社";
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
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册照片",@"拍照", nil];
//    [sheet showInView:self.view.window];
}

#pragma mark - MeButtonViewDelegate
- (void)buttonViewSelectedWithIndex:(NSInteger)index
{
    switch (index) {// 我的收藏
        case 0:{
            MyListViewController *col = [[MyListViewController alloc] init];
            col.listType = collectionType;
            [self.navigationController pushViewController:col animated:YES];
            break;
        }
        case 1:{ // 我的浏览
            MyListViewController *pre = [[MyListViewController alloc] init];
            pre.listType = previewType;
            [self.navigationController pushViewController:pre animated:YES];
            break;
        }
        case 2:{ // 搬救兵
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            SosViewController *sos = [sb instantiateViewControllerWithIdentifier:@"Sos"];
            [self.navigationController pushViewController:sos animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.desArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.desArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"mecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.desArr[indexPath.section][indexPath.row];
    
    // 前两个section的行
    if (indexPath.section != 2) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                if (self.isPerson) {
                    cell.imageView.image = [UIImage imageNamed:@"wodelvxingshe"];
                }else{
                    cell.textLabel.text = nil;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }else{
                cell.imageView.image = [UIImage imageNamed:@"money"];
            }
        }else{
            cell.imageView.image = [UIImage imageNamed:@"zhanghu-anquan"];
        }
    }
    
    // 第三组的第一行
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.detailTextLabel.text = @"晚上11点至早上8点将不会有消息推送";
        
        // 添加一个开关
        UISwitch *btn = [[UISwitch alloc] init];
        [btn addTarget:self action:@selector(changePushMode:) forControlEvents:UIControlEventValueChanged];
        btn.on = [[UserInfo shareUser].pushMode integerValue];
        cell.accessoryView = btn;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    // 下面的四个
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:{
                
                break;
            }
            case 1:{
                SuggestViewController *suggest = [sb instantiateViewControllerWithIdentifier:@"Suggest"];
                [self.navigationController pushViewController:suggest animated:YES];
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
                
                break;
            }
            default:
                break;
        }
    }else{
        if (indexPath.section == 0) {
            // 第一组的两个
            if (indexPath.row == 0) {
                MyOrgViewController *myOrg = [sb instantiateViewControllerWithIdentifier:@"MyOrg"];
                [self.navigationController pushViewController:myOrg animated:YES];
            }else{
                // 圈付宝
                QuanViewController *quan = [[QuanViewController alloc] init];
                [self.navigationController pushViewController:quan animated:YES];
            }
        }else{
            // 第二组 单个 账号安全
            UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Safe" bundle:nil];
            SafeSettingViewController *safe = [sb2 instantiateViewControllerWithIdentifier:@"SafeSetting"];
            safe.isPerson = self.isPerson;
            [self.navigationController pushViewController:safe animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isPerson && indexPath.section == 0 && indexPath.row == 0) {
        return 0.5;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (!self.isPerson && section == 0 ) {
//        return 0.01f;
//    }
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
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
    NSLog(@"----%@",info);
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    self.meheader.headIcon.image = image;
    
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

@end
