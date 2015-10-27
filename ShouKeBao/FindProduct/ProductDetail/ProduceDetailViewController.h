//
//  ProduceDetailViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
#import "BeseWebView.h"
typedef void (^CancelLeaveShare)(UINavigationController *na);
@class DayDetail;
@class yesterDayModel;
//@class BeseWebView;
typedef enum{
    FromQRcode,
    FromRecommend,
    FromStore,
    FromProductSearch,
    FromFindProduct,
    FromHotProduct,
    FromScanHistory
}JumpinFrom;
@protocol notiQRCToStartRuning<NSObject>
-(void)notiQRCToStartRuning;
@end
@interface ProduceDetailViewController : SKViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//@property (nonatomic, assign)BOOL isQRcode;
//@property (nonatomic, assign)BOOL isRecommend;
@property (nonatomic) NSInteger m;
@property (nonatomic, assign)JumpinFrom fromType;
@property (nonatomic, strong)NSMutableDictionary * shareInfo;
@property (nonatomic, assign)BOOL noShareInfo;
@property (copy,nonatomic) NSString *produceUrl;
@property (copy, nonatomic)NSString * titleName;
@property (copy,nonatomic) NSString *productName;
@property (nonatomic, strong) DayDetail *detail;
@property (nonatomic,copy) CancelLeaveShare canCelLeaveShare;
@property (nonatomic , strong)yesterDayModel *detail2;
@property(nonatomic,weak) id<notiQRCToStartRuning>delegate;
-(void)shareIt:(id)sender;

-(void)CancelLeaveShareBlock:(UINavigationController *)uinav;

@end
