//
//  EditCustomerDetailViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
#import "SKTableViewController.h"

@protocol notifiToRefereshCustomerDetailInfo<NSObject>

-(void)refreshCustomerInfoWithName:(NSString*)name andQQ:(NSString *)qq andWeChat:(NSString *)weChat andPhone:(NSString *)phone andCardID:(NSString *)cardID andBirthDate:(NSString *)birthdate andNationablity:(NSString *)nationablity andNation:(NSString *)nation andPassportStart:(NSString *)passPortStart andPassPortAddress:(NSString *)passPortAddress andPassPortEnd:(NSString *)passPortEnd andAddress:(NSString *)address andPassport:(NSString *)passPort andNote:(NSString *)note;
@end

//@protocol initPullDegate <NSObject>
//-(void)reloadMethod;
//
//@end


@interface EditCustomerDetailViewController : SKTableViewController
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *nameStr;
@property (nonatomic,copy) NSString *teleStr;
@property (nonatomic,copy) NSString *wechatStr;
@property (nonatomic,copy) NSString *QQStr;
@property (nonatomic,copy) NSString *noteStr;
//新添加的编辑选项
@property (nonatomic,copy) NSString *personCardIDStr;
@property (nonatomic,copy) NSString *birthdateStr;
@property (nonatomic,copy) NSString *nationalityStr;
@property (nonatomic,copy) NSString *nationStr;
@property (nonatomic,copy) NSString *passportDataStr;
@property (nonatomic,copy) NSString *passportAddressStr;
@property (nonatomic,copy) NSString *passportValidityStr;
@property (nonatomic,copy) NSString *addressStr;
@property (nonatomic,copy) NSString *passportStr;


@property(nonatomic,weak) id<notifiToRefereshCustomerDetailInfo>delegate;

//@property(nonatomic, assign)id<initPullDegate>initDelegate;

//@property (weak, nonatomic) IBOutlet UITextField *name;
//@property (weak, nonatomic) IBOutlet UITextField *tele;
//@property (weak, nonatomic) IBOutlet UITextField *wechat;
//@property (weak, nonatomic) IBOutlet UITextField *QQ;
//@property (weak, nonatomic) IBOutlet UITextView *note;
@end
