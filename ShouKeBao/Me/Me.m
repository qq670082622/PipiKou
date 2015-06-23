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
#import "Lotuseed.h"
#import "SubstationParttern.h"
#import "FeedBcakViewController.h"
#import "ResizeImage.h"
#import "IWHttpTool.h"
#import "InspectionViewController.h"
#import "WMAnimations.h"
#import "MeProgressView.h"
#import "AFNetworking.h"
@interface Me () <MeHeaderDelegate,MeButtonViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic,strong) MeHeader *meheader;

@property (nonatomic,strong) MeButtonView *buttonView;

@property (nonatomic,strong) NSArray *desArr;

@property (nonatomic,assign) BOOL isPerson;//是否个人

@property (nonatomic,assign) BOOL isFindNew;
@property (nonatomic, copy)NSString * checkVersionLinkUrl;
@property (nonatomic, strong)MeProgressView *progressView;
@property (nonatomic, strong)NSDictionary * versionInfoDic;
@end

@implementation Me

#pragma mark - lifecircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    
    self.tableView.rowHeight = 50;
    
    self.desArr = @[@[@"我的旅行社",@"圈付宝"],@[@"账号安全设置"],@[@"勿扰模式",@"意见反馈",@"关于旅游圈",@"评价旅游圈", @"检查更新"]];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *loginType = [def objectForKey:@"LoginType"];
    self.isPerson = [loginType integerValue] != 1;
    
    // 知道登录类型以后 设置头部
    [self setHeader];
//    MeProgressView * pro = [MeProgressView creatProgressViewWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 60)];
//    pro.backgroundColor = [UIColor clearColor];
//    pro.progressValue = 0.3;
//    [self.view addSubview:pro];
    // 设置头像
    NSString *head = [[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKeyLoginAvatar];
    if (head) {
        [self.meheader.headIcon sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"bigIcon"]];
    }
    [[[UIApplication sharedApplication].delegate window]addSubview:self.progressView];
    
    //获取版本信息
    NSDictionary * dic = @{};
    [MeHttpTool inspectionWithParam:dic success:^(id json) {
        self.versionInfoDic = json[@"ios"];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SubstationParttern *par = [SubstationParttern sharedStationName];
    [Lotuseed onEvent:@"page5Click" attributes:@{@"stationName":par.stationName}];
    _meheader.nickName.text = [UserInfo shareUser].userName;

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
    SubstationParttern *par = [SubstationParttern sharedStationName];
    [Lotuseed onEvent:@"page5DisturbSwitch" attributes:@{@"value":[NSString stringWithFormat:@"%d",modeSwitch.on],@"stationName":par.stationName}];
    
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
        if (!self.isPerson) {
            _meheader.personType.hidden = YES;
        }
        _meheader.personType.text = self.isPerson ? @"我的旅行社" : @"";
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
- (MeProgressView *)progressView
{
    if (!_progressView) {
        self.progressView = [MeProgressView creatProgressViewWithFrame:[UIScreen mainScreen].bounds];
        self.progressView.hidden = YES;
    }
    return _progressView;
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
    SubstationParttern *par = [SubstationParttern sharedStationName];
    [Lotuseed onEvent:@"page5MeSetting" attributes:@{@"stationName":par.stationName}];
}

// 点击头像上传照片
- (void)didClickHeadIcon
{
//        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册照片",@"拍照", nil];
//        [sheet showInView:self.view.window];
}

#pragma mark - MeButtonViewDelegate
- (void)buttonViewSelectedWithIndex:(NSInteger)index
{
    SubstationParttern *par = [SubstationParttern sharedStationName];
    switch (index) {// 我的收藏
        case 0:{
            MyListViewController *col = [[MyListViewController alloc] init];
            col.listType = collectionType;
            [Lotuseed onEvent:@"page5MeCollection" attributes:@{@"stationName":par.stationName}];
            [self.navigationController pushViewController:col animated:YES];
            break;
        }
        case 1:{ // 我的浏览
            MyListViewController *pre = [[MyListViewController alloc] init];
            pre.listType = previewType;
            [Lotuseed onEvent:@"page5MeHadSeen" attributes:@{@"stationName":par.stationName}];
            [self.navigationController pushViewController:pre animated:YES];
            break;
        }
        case 2:{ // 搬救兵
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
            SosViewController *sos = [sb instantiateViewControllerWithIdentifier:@"Sos"];
            [Lotuseed onEvent:@"page5Sos" attributes:@{@"stationName":par.stationName}];
            [self.navigationController pushViewController:sos animated:YES];
            break;
        }
        default:
            break;
    }
}

// 长按打电话
- (void)buttonViewLongPressToCall
{
    NSString *mobile = [UserInfo shareUser].sosMobile;
    if (!mobile) {
        return;
    }
    
    NSString *phone = [NSString stringWithFormat:@"tel://%@",mobile];
    
    SubstationParttern *par = [SubstationParttern sharedStationName];
    [Lotuseed onEvent:@"page5Tap3sToSos" attributes:@{@"stationName":par.stationName}];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

#pragma mark - RefreshNickNameDelegate
- (void)refreshNickName:(NSString *)name{
    _meheader.nickName.text = [UserInfo shareUser].userName;
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
        cell.detailTextLabel.text = @"23时至次日8时将不会有消息";
        
        // 添加一个开关
        UISwitch *btn = [[UISwitch alloc] init];
        [btn addTarget:self action:@selector(changePushMode:) forControlEvents:UIControlEventValueChanged];
        btn.on = [[UserInfo shareUser].pushMode integerValue];
        cell.accessoryView = btn;
    }
    if (indexPath.section == 2 && indexPath.row == 4) {
//        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 8, 80, 40)];
//        label.font = [UIFont systemFontOfSize:14];
//        label.textColor = [UIColor lightGrayColor];
//        label.text = @"检查到新版本";
//        [cell.contentView addSubview:label];
        NSLog(@"#######%@", self.versionInfoDic);
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
        if (![self.versionInfoDic[@"VersionCode"] isEqualToString:currentVersion]) {
            NSString * verStr = [NSString stringWithFormat:@"最新V%@", self.versionInfoDic[@"VersionCode"]];
            [WMAnimations WMNewTableViewCellWithCell:cell withRightStr:verStr];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    SubstationParttern *par = [SubstationParttern sharedStationName];
    // 下面的四个
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:{
                
                break;
            }
            case 1:{
                [Lotuseed onEvent:@"page5FeedBack" attributes:@{@"stationName":par.stationName}];
                FeedBcakViewController *feedBackVC = [sb instantiateViewControllerWithIdentifier:@"FeedBack"];
                [self.navigationController pushViewController:feedBackVC animated:YES];
                break;
            }
                
            case 2:{
                [Lotuseed onEvent:@"page5AboutLvYouQuan" attributes:@{@"stationName":par.stationName}];
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
                [Lotuseed onEvent:@"page5TalkApp" attributes:@{@"stationName":par.stationName}];
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"需要发布之后, 才能到appstore评分" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
//                NSString *str = [NSString stringWithFormat:
//                                 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
//                                 587767923];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                break;
            }
            case 4:{
                [Lotuseed onEvent:@"page5Inspection" attributes:@{@"stationName":par.stationName}];
//                InspectionViewController * InspectionVC = [sb instantiateViewControllerWithIdentifier:@"InspectionViewController"];
//                [self.navigationController pushViewController:InspectionVC animated:YES];
                
            
                [self checkNewVerSion];
            
//                NSString * str = @"不再询问";
//                self.isFindNew = YES;
//                if (self.isFindNew) {
//                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:@"请速速更新" delegate:self cancelButtonTitle:str otherButtonTitles:@"立即更新", nil];
//                    [alertView show];
//                }else{
//                    UIAlertView * alertView2 = [[UIAlertView alloc]initWithTitle:@"已更新到最新版本" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alertView2 show];
//                }
                
                
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
            [Lotuseed onEvent:@"page5AccountSafe" attributes:@{@"stationName":par.stationName}];
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
#pragma mark - CheckNewVersion
- (void)checkNewVerSion{
        NSString * versionCode = self.versionInfoDic[@"VersionCode"];
        NSArray * versionInfo = self.versionInfoDic[@"VersionInfo"];
        NSMutableString * str = [NSMutableString string];
        for (int i = 0; i < versionInfo.count; i++) {
            [str appendFormat:@"%d. %@  ", i+1, versionInfo[i]];
        }
        self.checkVersionLinkUrl = self.versionInfoDic[@"LinkUrl"];
        NSString * isMust = @"不在询问";
        if ([self.versionInfoDic[@"IsMustUpdate"]isEqualToString:@"1"]) {
            isMust = @"退出程序";
        }
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
        if (![versionCode isEqualToString:currentVersion]) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"发现新版本" message:str delegate:self cancelButtonTitle:isMust otherButtonTitles:@"立即更新", nil];
            [alertView show];
        }else{
            UIAlertView * alertV = [[UIAlertView alloc]initWithTitle:@"已是最新版本" message:[NSString stringWithFormat:@"版本号：%@", versionCode] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
        }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL *URL = [NSURL URLWithString:self.checkVersionLinkUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        self.progressView.hidden = NO;
        //下载请求
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        //正确的下载路径 [self getImagePath:@3.zip]
        
        //错误的路径
        //    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
        //    NSString *docPath = [path objectAtIndex:0];
        
        //            operation.outputStream = [NSOutputStream outputStreamToFileAtPath:[self getImagePath:@"3.zip"] append:YES];
        //下载进度回调
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            //下载进度
            float progress = ((float)totalBytesRead) / (totalBytesExpectedToRead);
            self.progressView.progressValue = progress;
        }];
        
        //成功和失败回调
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.progressView.hidden = YES;
            NSLog(@"ok");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            self.progressView.hidden = YES;
        }];
        
        [operation start];
        
    }else{
        if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"退出程序"]) {
            exit(0);
        }
    }
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
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    NSLog(@"----%@",info);
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    UIImage * newImage = [ResizeImage reSizeImage:image toSize:CGSizeMake(120, 120)];
    self.meheader.headIcon.image = newImage;
    NSData *data = UIImageJPEGRepresentation(newImage, 1.0);
    NSString *imageStr = [data base64EncodedStringWithOptions:0];
    
    [IWHttpTool postWithURL:@"/File/UploadPicture" params:@{@"FileStreamData":imageStr,@"PictureType":self.isPerson?@1:@2} success:^(id json) {
        NSLog(@"%@*******", json);
    } failure:^(NSError * error) {
        
    }];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:UIImageJPEGRepresentation(image, 0.3) forKey:@"userhead"];
    [def synchronize];
    SubstationParttern *par = [SubstationParttern sharedStationName];
    [Lotuseed onEvent:@"page5ChangeIcon" attributes:@{@"stationName":par.stationName}];
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
#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 1) {
//        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//        
//        //CFShow((__bridge CFTypeRef)(infoDic));
//        
//        NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
//        NSLog(@"!!!%@", currentVersion);
//        NSLog(@"立即更新");
//    }else{
//        if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"退出程序"]) {
//            exit(0);
//        }
//    }
//}
#pragma mark - FindNew
- (void)findnew:(id)sender {
    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    if (isAllow != nil) {
        SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
        sKStoreProductViewController.delegate = self;
        [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: @"594467299"}
                                                completionBlock:^(BOOL result, NSError *error) {
                                                    if (result) {
                                                        [self presentViewController:sKStoreProductViewController
                                                                           animated:YES
                                                                         completion:nil];
                                                    }
                                                    else{
                                                        NSLog(@"%@",error);
                                                    }
                                                }];
    }
    else{
        //低于iOS6没有这个类
        NSString *string = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",@"594467299"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
    //    SKStoreProductViewController * storeProductViewController = [[SKStoreProductViewController alloc] init];
    //    [storeProductViewController setDelegate:self];
    //    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"594467299"} completionBlock:^(BOOL result, NSError *error) {
    //        if(error)
    //        {
    //            NSLog(@"Error %@ with user info %@",error,[error userInfo]);
    //        }
    //        else
    //        {
    //            [self presentViewController:storeProductViewController animated:YES completion:nil];
    //        }
    //    }];
    
    
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    
    
    [viewController dismissViewControllerAnimated:YES
                                       completion:nil];
    
    
}
@end
