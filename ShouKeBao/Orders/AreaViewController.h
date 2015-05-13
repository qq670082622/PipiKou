//
//  AreaViewController.h
//  ShouKeBao
//
//  Created by Chard on 15/3/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKTableViewController.h"
#import "DressView.h"

@protocol AreaViewControllerDelegate <NSObject>

- (void)didSelectAreaWithValue:(NSDictionary *)value Type:(areaType)type atIndex:(NSInteger)index isSelected:(BOOL)isSelected;

@end

@interface AreaViewController : SKTableViewController

@property (nonatomic,assign) areaType type;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSDictionary *param;

@property (nonatomic,assign) NSInteger chooseIndex;

@property (nonatomic,copy) NSDictionary *chooseDic;

@property (nonatomic,weak) id<AreaViewControllerDelegate> delegate;

@end
