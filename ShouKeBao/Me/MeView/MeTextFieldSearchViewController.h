//
//  MeTextFieldSearchViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

@protocol searchBarTexts <NSObject>
- (void)searchBarText:(NSString *)text;
- (void)transmitPopKeyWord:(NSString *)keyWords;

@end

@interface MeTextFieldSearchViewController : SKViewController
@property(nonatomic, strong)NSString *detail_key;

@property (nonatomic, strong)UITextField *inputTextView;

@property(nonatomic, weak)id<searchBarTexts>searchDelegate;
@end
