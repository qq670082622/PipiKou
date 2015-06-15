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
@interface userIDTableviewController : SKTableViewController
//json[@"Address"],json[@"BirthDay"],json[@"CardNum"],json[@"Nation"],json[@"Sex"],json[@"UserName"]
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *birthDay;
@property(nonatomic,copy) NSString *cardNumber;
@property(nonatomic,copy) NSString *Nation;
@property(nonatomic,copy) NSString *sex;
@property(nonatomic,copy) NSString *UserName;
@property(nonatomic,strong)personIdModel *model;
//@property(nonatomic,strong) NSDictionary *json;

@property(nonatomic,weak) id<toIfPush2>delegate;

@end
