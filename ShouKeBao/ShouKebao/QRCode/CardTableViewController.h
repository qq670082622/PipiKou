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


@property(nonatomic,assign) BOOL isLogin;
@property(weak,nonatomic) id<toIfPush>delegate;
@end
