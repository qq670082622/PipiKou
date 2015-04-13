//
//  remondViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "remondModel.h"
#import "remondTableViewCell.h"
#import "SKViewController.h"
#import "MBProgressHUD+MJ.h"

@class CustomModel;
@interface remondViewController : SKViewController
@property (nonatomic,copy) NSString *ID;

@property (nonatomic,strong) CustomModel *customModel;
@end
