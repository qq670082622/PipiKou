//
//  TravelCell.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/7.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Business;

@protocol TravelCellDelegate <NSObject>

- (void)didSelectedTravelWithIndextPath:(NSIndexPath *)indexPath;

@end

@interface TravelCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) Business *model;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,weak) id<TravelCellDelegate> delegate;

@end
