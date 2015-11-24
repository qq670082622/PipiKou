//
//  EstablelishedViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

@interface EstablelishedViewController : SKViewController
@property (nonatomic, strong)UINavigationController *naVC;

@property (nonatomic, copy)NSString *isExclusiveCustomer;
@property (nonatomic, strong)NSMutableDictionary *ConsultanShareInfo;
@property (nonatomic, copy)NSString *clientManagerTel;
@end
