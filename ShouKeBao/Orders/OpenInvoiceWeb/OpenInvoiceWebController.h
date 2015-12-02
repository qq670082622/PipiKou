//
//  OpenInvoiceWebController.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

@interface OpenInvoiceWebController : SKViewController

@property (strong, nonatomic) UIWebView *webView;
@property (copy, nonatomic) NSString * titleName;
@property (copy,nonatomic) NSString *produceUrl;
@property (nonatomic,strong) NSMutableArray *OrderIDArr;
@property (nonatomic,copy) NSMutableArray *ParameterArr;

@property (nonatomic,copy) NSString *NewParameterStr;

@property (nonatomic,strong) UIViewController *viewCont;
@property (nonatomic,copy) NSString *NewUrlStr;
@end
