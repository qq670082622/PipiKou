//
//  CustomCell.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//
#import "CustomModel.h"
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class CustomModel;
@protocol transformPerformation <NSObject>

- (void)transformPerformation:(CustomModel *)model;
@end

@interface CustomCell : UITableViewCell<UIAlertViewDelegate, MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTele;
@property (weak, nonatomic) IBOutlet UILabel *userOders;
@property (weak, nonatomic)id<transformPerformation>delegate;

@property(nonatomic,strong) CustomModel *model;
@property (weak, nonatomic) IBOutlet UIButton *information;
@property (nonatomic, strong)NSString *telStr;

- (IBAction)callAction:(id)sender;

- (IBAction)informationIM:(id)sender;

//@property (nonatomic, copy)NSString *InvitationInfo;
+(instancetype)cellWithTableView:(UITableView *)tableView InvitationInfo:(NSString *)invitationInfo navigationC:(UINavigationController *)naNC;

@end
