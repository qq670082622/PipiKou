//
//  FindProductNew.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

typedef enum{
    SelectTypeHot,
    SelectTypeNomal,
    SelectTypeShip
}SelectType;

@interface FindProductNew : SKViewController
@property (nonatomic, assign)SelectType leftSelectType;
@property (nonatomic, assign)NSInteger SelectNum;

@end
