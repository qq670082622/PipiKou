//
//  UserInfoEditTableVC.m
//  TravelConsultant
//
//  Created by 冯坤 on 15/11/11.
//  Copyright (c) 2015年 冯坤. All rights reserved.
//

#import "UserInfoEditTableVC.h"
#import "UIImageView+EMWebCache.h"
#import "EditNickNameVC.h"
#import "EditUserNameVC.h"
#import "EditPhoneNumberVC.h"
@interface UserInfoEditTableVC ()<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong)NSArray * dataArray;
@property (nonatomic, strong)NSArray * userInfoArray;
@property (nonatomic, strong)UIImageView * iconImage;
@end

@implementation UserInfoEditTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:245/255.0 blue:246/255.0 alpha:1];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    self.title = @"个人信息";
    self.tableView.rowHeight = 50;
    self.dataArray = @[@[@"头像", @"昵称"],@[@"姓名",@"手机"]];
    self.userInfoArray = @[@[@"", @"tom"], @[@"曹余", @"1589127391"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.row==0&&indexPath.section==0)?90:50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * string = [NSString stringWithFormat:@"%d", arc4random()];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:string];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = self.userInfoArray[indexPath.section][indexPath.row];
    if (indexPath.section==0&&indexPath.row==0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100,15 , 60, 60)];
        imageView.backgroundColor = [UIColor brownColor];
        imageView.layer.cornerRadius = 30;
        self.iconImage = imageView;
        [cell.contentView addSubview:imageView];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                [self didClickHeadIcon];
                break;
            case 1:
                [self didClickNickName];
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                [self didClickUserName];
                break;
            case 1:
                [self didClickPhoneNumber];
                break;
            default:
                break;
        }
    }
}
// 点击头像上传照片
- (void)didClickHeadIcon
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册照片",@"拍照", nil];
    [sheet showInView:self.view.window];
    
}
//点击昵称修改
- (void)didClickNickName{
    EditNickNameVC *nickNameVC = [[EditNickNameVC alloc]init];
    [self.navigationController pushViewController:nickNameVC animated:YES];
}
//点击姓名修改
- (void)didClickUserName{
    EditUserNameVC *userNameVC = [[EditUserNameVC alloc]init];
    [self.navigationController  pushViewController:userNameVC animated:YES];
}
//点击手机修改
- (void)didClickPhoneNumber{
    EditPhoneNumberVC *phoneVC = [[EditPhoneNumberVC alloc]init];
    [self.navigationController pushViewController:phoneVC animated:YES];
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
//    UIImage * newImage = [ResizeImage reSizeImage:image toSize:CGSizeMake(120, 120)];
//    self.meheader.headIcon.image = newImage;
//    NSData *data = UIImageJPEGRepresentation(newImage, 1.0);
//    NSString *imageStr = [data base64EncodedStringWithOptions:0];
//    
//    [IWHttpTool postWithURL:@"Business/UploadBusinessHeader" params:@{@"FileStreamData":imageStr,@"PictureType":self.isPerson?@"5":@"6"} success:^(id json) {
//        NSLog(@"%@*******", json);
//        if (![json[@"PicUrl"]isEqualToString:@""]) {
//            [[NSUserDefaults standardUserDefaults]setObject:json[@"PicUrl"] forKey:UserInfoKeyLoginAvatar];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//        }
//        
//    } failure:^(NSError * error) {
//        
//    }];
    self.iconImage.image = image;

    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:UIImageJPEGRepresentation(image, 0.3) forKey:@"userhead"];
    [def synchronize];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
