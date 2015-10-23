//
//  IdentifyViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
#import "QRPhotoCollectionViewCell.h"
@interface IdentifyViewController : SKViewController
@property(nonatomic,assign) BOOL isLogin;
@property (nonatomic, assign)BOOL historyFlag;
@property (nonatomic, strong) UISegmentedControl *control;
@property (nonatomic, strong)QRPhotoCollectionViewCell *QRphoto;

-(void)editCustomerDetail;
-(void)change;

@end
