//
//  Me.m
//  ShouKeBao
//
//  Created by David on 15/3/12.
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

@interface Me () <MeHeaderDelegate,MeButtonViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) MeHeader *meheader;

@property (nonatomic,strong) MeButtonView *buttonView;

@property (nonatomic,strong) NSArray *desArr;

@property (nonatomic,assign) BOOL isPerson;//是否个人

@end

@implementation Me

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
    self.tableView.tableHeaderView = self.buttonView;
    self.tableView.rowHeight = 50;
    
    self.desArr = @[@[@"我的旅行社"],@[@"账号安全设置"],@[@"勿扰模式",@"意见反馈",@"关于收客宝",@"评价收客宝"]];
    
    self.isPerson = [[UserInfo shareUser].loginType integerValue] != 1;
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSData *head = [def objectForKey:@"userhead"];
    if (head) {
        [self.meheader.headIcon setImage:[UIImage imageWithData:head] forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setNav];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.meheader removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - private
- (void)setNav
{
    self.title = nil;
  
    [self.navigationController.view addSubview:self.meheader];
}

#pragma mark - getter
- (MeHeader *)meheader
{
    if (!_meheader) {
        _meheader = [[MeHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _meheader.delegate = self;
        _meheader.nickName.text = [UserInfo shareUser].userName;
        _meheader.personType.text = self.isPerson ? @"个人分销商" : @"旅行社";
    }
    return _meheader;
}

- (MeButtonView *)buttonView
{
    if (!_buttonView) {
        _buttonView = [[MeButtonView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,60)];
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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册照片",@"拍照", nil];
    [sheet showInView:self.view];
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
    
    // 前两个单独的行
    if (indexPath.section != 2) {
        if (indexPath.section == 0) {
            if (self.isPerson) {
                cell.imageView.image = [UIImage imageNamed:@"wodelvxingshe"];
            }else{
                cell.textLabel.text = nil;
                cell.accessoryType = UITableViewCellAccessoryNone;
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
            MyOrgViewController *myOrg = [sb instantiateViewControllerWithIdentifier:@"MyOrg"];
            [self.navigationController pushViewController:myOrg animated:YES];
        }else{
            UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Safe" bundle:nil];
            SafeSettingViewController *safe = [sb2 instantiateViewControllerWithIdentifier:@"SafeSetting"];
            [self.navigationController pushViewController:safe animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isPerson && indexPath.section == 0) {
        return 0;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.isPerson && section == 0) {
        return 0.01f;
    }
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
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    [self.meheader.headIcon setImage:image forState:UIControlStateNormal];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:UIImageJPEGRepresentation(image, 0.3) forKey:@"userhead"];
    [def synchronize];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
