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
@class CustomModel;

@interface CustomerDetailViewController : SKViewController
@property (weak, nonatomic) IBOutlet UITextField *weChat;
@property (weak, nonatomic) IBOutlet UITextField *QQ;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (nonatomic,copy) NSString *ID;
@property (weak, nonatomic) IBOutlet UITextField *tele;
@property (nonatomic,copy) NSString *weChatStr;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic,copy) NSString *QQStr;
@property (nonatomic,copy) NSString *noteStr;
@property (nonatomic,copy) NSString *teleStr;
@property (nonatomic,copy) NSString *userNameStr;
@property (nonatomic,strong) CustomModel *customMoel;

- (IBAction)remond:(id)sender;
- (IBAction)deleteCustomer:(id)sender;


@end
