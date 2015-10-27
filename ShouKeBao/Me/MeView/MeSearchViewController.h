//
//  MeSearchViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

//协议传值
@protocol transmitPopKeyWords <NSObject>
- (void)transmitPopKeyWord:(NSString *)keyWords;
@end

@protocol backChanpinDetail <NSObject>
- (void)backChanpinDetail;
@end

@interface MeSearchViewController : SKViewController<UITextFieldDelegate>

@property (nonatomic, strong)UITextField *inputSearchView;
@property(nonatomic, weak)id<transmitPopKeyWords>transmitDelegate;
@property(nonatomic, weak)id<backChanpinDetail>delegate;
@end
