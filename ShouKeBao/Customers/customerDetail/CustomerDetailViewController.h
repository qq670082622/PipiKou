//
//  CustomerDetailViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomModel.h"
#import "SKViewController.h"
#import "SKTableViewController.h"
@class CustomModel;

@interface CustomerDetailViewController : SKTableViewController
@property (weak, nonatomic) IBOutlet UILabel *weChat;
@property (weak, nonatomic) IBOutlet UILabel *QQ;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (nonatomic,copy) NSString *ID;

@property (weak, nonatomic) IBOutlet UILabel *tele;
@property (nonatomic,copy) NSString *weChatStr;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *passPortId;
@property (weak, nonatomic) IBOutlet UILabel *userMessageID;

@property (weak, nonatomic) IBOutlet UILabel *bornDay;

@property (weak, nonatomic) IBOutlet UILabel *countryID;
@property (weak, nonatomic) IBOutlet UILabel *nationalID;
@property (weak, nonatomic) IBOutlet UILabel *pasportStartDay;
@property (weak, nonatomic) IBOutlet UILabel *pasportAddress;
@property (weak, nonatomic) IBOutlet UILabel *pasportInUseDay;
@property (weak, nonatomic) IBOutlet UILabel *livingAddress;
- (IBAction)attachmentAction:(id)sender;//附件
@property (nonatomic,copy) NSString *picUrl;




@property (nonatomic,copy) NSString *QQStr;
@property (nonatomic,copy) NSString *noteStr;
@property (nonatomic,copy) NSString *teleStr;
@property (nonatomic,copy) NSString *userNameStr;
@property (nonatomic,copy) NSString *passPortIdStr;
@property (nonatomic,copy) NSString *userMessageIDStr;

@property (nonatomic,copy) NSString *bornDayStr;

@property (nonatomic,copy) NSString *countryIDStr;
@property (nonatomic,copy) NSString *nationalIDStr;
@property (nonatomic,copy) NSString *pasportStartDayStr;
@property (nonatomic,copy) NSString *pasportAddressStr;
@property (nonatomic,copy) NSString *pasportInUseDayStr;
@property (nonatomic,copy) NSString *livingAddressStr;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,strong) CustomModel *customMoel;

- (IBAction)remond:(id)sender;
- (IBAction)deleteCustomer:(id)sender;


@end
