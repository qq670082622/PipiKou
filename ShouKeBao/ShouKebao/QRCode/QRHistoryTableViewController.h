//
//  QRHistoryTableViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
#import "IdentifyViewController.h"
@interface QRHistoryTableViewController : SKViewController
@property(nonatomic, strong)IdentifyViewController * IdenVC;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic, strong)UINavigationController *identifyNav;
@property(nonatomic,assign) BOOL isLogin;
@end
