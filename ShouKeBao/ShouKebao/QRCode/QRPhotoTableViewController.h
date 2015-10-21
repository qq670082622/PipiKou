//
//  QRPhotoTableViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
#import "IdentifyViewController.h"
#import "QRPhotoCollectionViewCell.h"

@interface QRPhotoTableViewController : SKViewController
//@property (nonatomic, copy)NSString *customerId;
@property (nonatomic, strong)UINavigationController *identifyNav;
@property(nonatomic,assign) BOOL isLogin;
@property(nonatomic, strong)IdentifyViewController * IDVC;
@property(nonatomic, strong)QRPhotoCollectionViewCell * update;
@end
