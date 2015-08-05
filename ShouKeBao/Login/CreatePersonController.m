//
//  CreatePersonController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/5/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CreatePersonController.h"
#import "InputhCell.h"
#import "LoginTool.h"
#import "MBProgressHUD+MJ.h"
#import "MobClick.h"
@interface CreatePersonController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSArray *dataSource;

@property (nonatomic,weak) UIImageView *userIcon;

@property (nonatomic,copy) NSString *headIconUrl;// 创建时需要的参数

/**
 *  创建收客宝的域名
 */
@property (nonatomic,weak) UITextField *adrField;

@property (nonatomic,weak) UILabel *adrLab;

/**
 *  下面三行信息
 */
@property (nonatomic,weak) UITextField *nameField;// 名称

@property (nonatomic,weak) UITextField *positionField;// 职位

@property (nonatomic,weak) UITextField *phoneField;// 联系手机
@property (nonatomic, strong)UILabel * placeHolderlabel;//站位logo
@end

@implementation CreatePersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.createType == CreatePersonType ? @"开通个人收客宝" : @"开通收客宝";
    self.headIconUrl = @"";
    
    // 如果是创建收客宝就是如下数据源  不会太low吧这样写 嘻嘻
    if (self.createType == CreateSKBType) {
        self.dataSource = @[@[@{@"title":@"定制域名",@"des":@"仅限输入英文/数字/下划线"},
                              @{@"title":@"收客宝域名",@"des":@"skb/lvyouquan.cn/(您的域名)"}],
                            @[@{@"title":@"名称",@"des":@"使用公司名称或其他自定义"},
                              @{@"title":@"电话",@"des":@"客户可以点击电话与您联系"},
                              @{@"title":@"联系手机",@"des":@"填写手机号接受提醒"}]];
    }else{
        self.dataSource = @[@{@"title":@"名称",@"des":@"填写姓名方便用户认识您"},
                            @{@"title":@"职位",@"des":@"您在旅行社的职位"},
                            @{@"title":@"联系手机",@"des":@"该号码将显示在您的店铺上"}];
    }
    
    // 设置导航
    [self setNav];
    
    // 设置头像
    [self setupHeader];
    
    // 设置创建按钮
    [self setCreateButton];
    
    // 触屏退出编辑
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self.view addGestureRecognizer:tap];
    
    // 监听域名输入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adrFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.adrField];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LoginCreatePerson"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LoginCreatePerson"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private
/**
 *  监听域名输入
 */
- (void)adrFieldTextDidChange:(NSNotification *)noty
{
    NSString *tmp = [NSString stringWithFormat:@"skb/lvyouquan.cn/(%@)",self.adrField.text];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:tmp];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(18, self.adrField.text.length)];
    [self.adrLab setAttributedText:attr];
}

// 设置导航
- (void)setNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
}

// 取消
- (void)cancel:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 退出编辑
- (void)tapHandle:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
}

// 设置头部
- (void)setupHeader
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    cover.backgroundColor = [UIColor clearColor];
    
    // 阴影
    CGFloat shadowW = 150;
    CGFloat shadowX = (self.view.frame.size.width - shadowW) * 0.5;
    UIImageView *shadow = [[UIImageView alloc] initWithFrame:CGRectMake(shadowX, 5, shadowW, shadowW)];
    shadow.image = [UIImage imageNamed:@"yiny1"];
    [cover insertSubview:shadow atIndex:0];
    
    // 头像
    CGFloat iconW = shadowW - 32;
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.center = CGPointMake(shadow.center.x, shadow.center.y - 3);
    iconView.bounds = CGRectMake(0, 0, iconW, iconW);
    iconView.userInteractionEnabled = YES;
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.backgroundColor = [UIColor clearColor];
    self.placeHolderlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 45, 70, 20)];
    self.placeHolderlabel.backgroundColor = [UIColor clearColor];
    self.placeHolderlabel.font = [UIFont systemFontOfSize:14];
    self.placeHolderlabel.textAlignment = NSTextAlignmentCenter ;
    self.placeHolderlabel.textColor = [UIColor lightGrayColor];
    self.placeHolderlabel.text = @"上传Logo";
    [iconView addSubview:self.placeHolderlabel];
//    [iconView sd_setImageWithURL:[NSURL URLWithString:[UserInfo shareUser].LoginAvatar] placeholderImage:nil];
    iconView.layer.cornerRadius = 59;
    iconView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upLoadUserHead:)];
    tap.delegate = self;
    [iconView addGestureRecognizer:tap];
    [cover addSubview:iconView];
    self.userIcon = iconView;
    
    self.tableView.tableHeaderView = cover;
}

- (void)setCreateButton
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    CGFloat backW = self.view.frame.size.width - 40;
    UIButton *createBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, backW, 45)];
    createBtn.layer.cornerRadius = 3;
    createBtn.layer.masksToBounds = YES;
    [createBtn setBackgroundImage:[UIImage imageNamed:@"red-bg"] forState:UIControlStateNormal];
    [createBtn setTitle:@"开通收客宝" forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createBtn addTarget:self action:@selector(create:) forControlEvents:UIControlEventTouchUpInside];
    
    [cover addSubview:createBtn];
    self.tableView.tableFooterView = cover;
}

#pragma mark - 创建按钮点击
- (void)create:(UIButton *)btn
{
    if (self.createType == CreatePersonType) {// 开通个人收客宝
        
        NSDictionary *param = @{@"Name": self.nameField.text,
                                @"Position": self.positionField.text,
                                @"Mobile": self.phoneField.text,
                                @"HeadUrl":self.headIconUrl};
        if ([self.nameField.text isEqualToString:@""] || [self.positionField.text isEqualToString:@""] || [self.phoneField.text isEqualToString:@""] || [self.headIconUrl isEqualToString:@""]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写必要信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LoginTool createDistributionWithParam:param success:^(id json) {
            
            if ([json[@"IsSuccess"] integerValue] == 1) {
                // 通知代理
                if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishCreateSkb:)]) {
                    [self.delegate didFinishCreateSkb:self];
                    [MBProgressHUD showSuccess:@"保存成功"];
                }
                
            }else{
//                [MBProgressHUD showError:json[@"ErrorMsg"] toView:self.view];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    }else{ // 创建收客宝
        NSDictionary *param = @{@"Domain": self.adrField.text,
                                @"Name": self.nameField.text,
                                @"Mobile": self.positionField.text,
                                @"Telephone": self.phoneField.text,
                                @"LogoUrl":self.headIconUrl};
        if ([self.adrField.text isEqualToString:@""] || [self.positionField.text isEqualToString:@""] || [self.phoneField.text isEqualToString:@""] || [self.headIconUrl isEqualToString:@""]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写必要信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LoginTool applyOpenSkbWithParam:param success:^(id json) {
            [MBProgressHUD showSuccess:@"申请成功"];
            if ([json[@"IsSuccess"] integerValue] == 1) {
                // 通知代理
                if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishCreateSkb:)]) {
                    [self.delegate didFinishCreateSkb:self];
                }
                
            }else{
//                [MBProgressHUD showError:json[@"ErrorMsg"] toView:self.view];
            }
            
        } failure:^(NSError *error) {
            
        }];
        }
    }
}

#pragma mark - 上传头像
- (void)upLoadUserHead:(UITapGestureRecognizer *)ges
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相册照片",@"拍照", nil];
    [sheet showInView:self.view.window];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.createType == CreateSKBType) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.createType == CreateSKBType) {
        return [self.dataSource[section] count];
    }else{
        return self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 这个地方有点恶心 没办法 自定义揍似这么恶心
    
    if (self.createType == CreateSKBType) {// 创建收客宝
        if (indexPath.section == 0 && indexPath.row == 1) {// 第一组
            InputhCell *cell = [InputhCell cellWithTableView:tableView];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            
            cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row][@"title"];
            cell.detailTextLabel.text = self.dataSource[indexPath.section][indexPath.row][@"des"];
            self.adrLab = cell.detailTextLabel;
            
            // 隐藏这行的输入框
            cell.inputField.hidden = YES;
            return cell;
        }else{
            InputhCell *cell = [InputhCell cellWithTableView:tableView];
            cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row][@"title"];
            cell.inputField.placeholder = self.dataSource[indexPath.section][indexPath.row][@"des"];
            if (indexPath.section == 1 && indexPath.row == 0) {
            }else{
                UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 5, 50)];
                lab.textColor = [UIColor redColor];
                lab.text = @"*";
                [cell.contentView addSubview:lab];
            }
            // 获取输入框
            if (indexPath.section == 0) {
                self.adrField = cell.inputField;
            }else{
                switch (indexPath.row) {
                    case 0:
                        self.nameField = cell.inputField;
                        break;
                    case 1:
                        self.positionField = cell.inputField;
                        break;
                    case 2:
                        self.phoneField = cell.inputField;
                        break;
                }
            }
            
            return cell;
        }
        
    }else{// 添加分销人
        InputhCell *cell = [InputhCell cellWithTableView:tableView];
        cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
        cell.inputField.placeholder = self.dataSource[indexPath.row][@"des"];
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 5, 50)];
        lab.textColor = [UIColor redColor];
        lab.text = @"*";
        [cell.contentView addSubview:lab];
        // 获取输入框
        switch (indexPath.row) {
            case 0:
                self.nameField = cell.inputField;
                break;
            case 1:
                self.positionField = cell.inputField;
                break;
            case 2:
                self.phoneField = cell.inputField;
                break;
        }
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.createType == CreateSKBType) {// 创建收客宝
        if (section == 1) {// 第一组
            return @"您填写的收客宝信息将帮助用户更好的联系您";
        }else{
            return nil;
        }
    }else{// 添加分销人
        return @"您填写的收客宝信息将帮助用户更好的联系您";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.createType == CreateSKBType) {// 创建收客宝
        if (indexPath.section == 0 && indexPath.row == 1) {// 第一组
            return 30;
        }else{
            return 50;
        }
        
    }else{// 添加分销人
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.createType == CreateSKBType) {// 创建收客宝
        if (section == 0) {// 第一组
            return 5.0f;
        }else{
            return 35;
        }
        
    }else{// 添加分销人
        return 35;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UITableView class]]) {
        return NO;
    }else{
        return YES;
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
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 获取图片
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    
    // 将图片转成base64字符串
    NSData *imgData = UIImageJPEGRepresentation(image, 0.3);
    NSString *encodedImgStr = [imgData base64EncodedStringWithOptions:0];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:UIImageJPEGRepresentation(image, 0.3) forKey:@"userhead"];
    [def synchronize];

    /**
     *  上传头像
     */
    NSDictionary *param = @{@"FileStreamData":encodedImgStr,
                            @"PictureType":self.createType == CreatePersonType ? @"1" : @"2"};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [LoginTool uploadHeadWithParam:param success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"-------   %@",json);
        
        if ([json[@"IsSuccess"] integerValue] == 1) {
            self.placeHolderlabel.hidden = YES;
            self.headIconUrl = json[@"PicUrl"];
            self.userIcon.image = image;
            
        }else{
            [MBProgressHUD showError:json[@"ErrorMsg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
