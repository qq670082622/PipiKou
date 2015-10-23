//
//  userIDTableviewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKTableViewController.h"
#import "personIdModel.h"
//@class personIdModel;
@protocol toIfPush2 <NSObject>

-(void)toIfPush2;

@end
@protocol DelegateToOrder <NSObject>

- (void)writeDelegate:(NSDictionary *)dic;
- (void)toRefereshCustomers;
@end

@interface userIDTableviewController : SKTableViewController
//json[@"Address"],json[@"BirthDay"],json[@"CardNum"],json[@"Nation"],json[@"Sex"],json[@"UserName"]
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *birthDay;
@property(nonatomic,copy) NSString *cardNumber;
@property(nonatomic,copy) NSString *Nationality;
@property(nonatomic,copy) NSString *sex;
@property(nonatomic,copy) NSString *UserName;
@property (copy,nonatomic) NSString *RecordId;
@property (copy,nonatomic) NSMutableString *ModifyDate;
@property(nonatomic,assign) BOOL isLogin;
@property (copy,nonatomic) NSString *PicUrl;
@property(nonatomic,assign) BOOL isFromOrder;
@property (nonatomic, assign)BOOL isFromCamer;
@property (nonatomic, assign)BOOL isIDCard;
@property (nonatomic, strong)id VC;
@property (nonatomic, assign)id delegateToOrder;

@property(nonatomic,weak) id<toIfPush2>delegate;

@end
