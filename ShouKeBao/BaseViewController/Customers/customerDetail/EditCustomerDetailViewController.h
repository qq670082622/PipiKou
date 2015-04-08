//
//  EditCustomerDetailViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
@interface EditCustomerDetailViewController : SKViewController
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *nameStr;
@property (nonatomic,copy) NSString *teleStr;
@property (nonatomic,copy) NSString *wechatStr;
@property (nonatomic,copy) NSString *QQStr;
@property (nonatomic,copy) NSString *noteStr;

//@property (weak, nonatomic) IBOutlet UITextField *name;
//@property (weak, nonatomic) IBOutlet UITextField *tele;
//@property (weak, nonatomic) IBOutlet UITextField *wechat;
//@property (weak, nonatomic) IBOutlet UITextField *QQ;
//@property (weak, nonatomic) IBOutlet UITextView *note;
@end
