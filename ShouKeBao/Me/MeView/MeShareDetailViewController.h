//
//  MeShareDetailViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

@interface MeShareDetailViewController : SKViewController
@property (nonatomic, strong)NSString *popKeyWords;
@property (nonatomic, strong)NSMutableArray *conditionArr;
@property (nonatomic, strong)UIView *chanpingView;
- (void)backChanPinDetail;
@end
