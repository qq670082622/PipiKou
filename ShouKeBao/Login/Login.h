//
//  Login.h
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Business;

@interface Login : UITableViewController

//@property (nonatomic,copy) NSString *aa;

// 属性统一在最后一步保存
@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *chooseId;

@property (nonatomic,copy) NSString *businessId;

@property (nonatomic,copy) NSString *distributeId;

@property (nonatomic,strong) Business *business;

@property (nonatomic,assign) BOOL autoLoginFailed;

@end
