//
//  RecomViewController.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
#import "RecommendViewController.h"
@interface RecomViewController : SKViewController
{
    UIView *leftView;
}
@property (nonatomic,strong) RecommendViewController *todayVC;
@property (nonatomic, assign)BOOL isFromEmpty;
@property (nonatomic) UIView *leftView;
//@property (nonatomic, strong)NSString *markStr;

@end
