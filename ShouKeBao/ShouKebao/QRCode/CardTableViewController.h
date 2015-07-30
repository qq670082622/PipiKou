//
//  CardTableViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKTableViewController.h"
#import "personIdModel.h"
//@class personIdModel;
@protocol toIfPush <NSObject>

-(void)toIfPush;

@end

@protocol DelegateToOrder2 <NSObject>

- (void)writeDelegate:(NSDictionary *)dic;
- (void)toRefereshCustomers;

@end
@interface CardTableViewController : SKTableViewController
@property (copy, nonatomic) NSString *nameLabStr;
@property (copy, nonatomic) NSString *sexLabStr;
@property (copy, nonatomic) NSString *countryLabStr;
@property (copy, nonatomic) NSString *cardNumStr;
@property (copy, nonatomic) NSString *bornLabStr;
@property (copy, nonatomic) NSString *startDayLabStr;
@property (copy, nonatomic) NSString *startPointLabStr;
@property (copy, nonatomic) NSString *effectiveLabStr;
@property (copy,nonatomic) NSString *RecordId;
@property (copy,nonatomic) NSMutableString *ModifyDate;
@property (copy,nonatomic) NSString *PicUrl;
@property(nonatomic,assign) BOOL isLogin;
@property(nonatomic,assign) BOOL isFromOrder;
@property (nonatomic, assign)BOOL isFromeCamer;
@property (nonatomic, assign)BOOL isIDCard;
@property (nonatomic, strong)id VC;
@property (nonatomic, assign)id delegateToOrder;

@property(weak,nonatomic) id<toIfPush>delegate;
@end
