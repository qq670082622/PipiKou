//
//  ScanningViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
#import "V8HorizontalPickerView.h"

@class V8HorizontalPickerView;

@interface ScanningViewController : SKViewController<V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource,UIScrollViewDelegate>
@property (nonatomic,assign) BOOL isLogin;
@property (nonatomic, assign)BOOL isFromOrder;
@property (nonatomic, assign)BOOL isFromCostom;
@property (nonatomic, strong)id VC;
@end
