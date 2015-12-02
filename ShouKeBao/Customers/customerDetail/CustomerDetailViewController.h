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

@protocol DeleteCustomerDelegate <NSObject>


//代理方法：协议传值1: 由第二个页面制定一个协议,用来命令前一个页面做事(执行方法) .h文件
- (void)deleteCustomerWith:(NSString *)keyWords;

@end


//@protocol initPullDegate <NSObject>
//-(void)reloadMethod;
//
//@end

@interface CustomerDetailViewController : SKTableViewController

////协议传值
//@property (nonatomic, assign)id delegate;
//或者
//协议传值2:设置代理人属性 (.h文件) 注意位置
@property(nonatomic, assign)id<DeleteCustomerDelegate>delegate;

//@property(nonatomic, assign)id<initPullDegate>initDelegate;


@property (nonatomic, strong)UINavigationController * Nav;
@property (weak, nonatomic) IBOutlet UILabel *weChat;
@property (weak, nonatomic) IBOutlet UILabel *QQ;
@property (weak, nonatomic) IBOutlet UITextView *note;

//协议传值（删除时使用的属性）
//@property (nonatomic,copy) NSString *ID;
//@property (nonatomic, copy)NSString * keyWordss;

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

//@property (nonatomic,copy) NSString *picUrl;
//@property (nonatomic,strong) NSArray *pictureArray;
//@property (nonatomic,copy) NSString *QQStr;
//@property (nonatomic,copy) NSString *noteStr;
//@property (nonatomic,copy) NSString *teleStr;
//@property (nonatomic,copy) NSString *userNameStr;
//@property (nonatomic,copy) NSString *passPortIdStr;
//@property (nonatomic,copy) NSString *userMessageIDStr;
//
//@property (nonatomic,copy) NSString *bornDayStr;
//
//@property (nonatomic,copy) NSString *countryIDStr;
//@property (nonatomic,copy) NSString *nationalIDStr;
//@property (nonatomic,copy) NSString *pasportStartDayStr;
//@property (nonatomic,copy) NSString *pasportAddressStr;
//@property (nonatomic,copy) NSString *pasportInUseDayStr;
//@property (nonatomic,copy) NSString *livingAddressStr;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic,copy) NSString *AppSkbUserID;
//@property (nonatomic,strong) CustomModel *customMoel;

- (IBAction)remond:(id)sender;
- (IBAction)deleteCustomer:(id)sender;


@end
