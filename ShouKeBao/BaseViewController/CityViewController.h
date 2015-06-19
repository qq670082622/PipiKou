//
//  CityViewController.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/2.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKTableViewController.h"

@protocol CityViewControllerDelegate <NSObject>

- (void)didSelectedWithCity:(NSString *)city;

@end

@interface CityViewController : SKTableViewController

@property (nonatomic,weak) id<CityViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString * selectedCityName;

@end
