//
//  RecommendCell.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShouKeBaoCell.h"

@class Recommend;


@interface RecommendCell : ShouKeBaoCell


@property (nonatomic,strong) Recommend *recommend;

@property (nonatomic,weak) UIImageView *redTip;// 红点

@property (nonatomic,assign) CGFloat cellHeight;

//@property (nonatomic,weak) UIImageView *imgV1;
//
//@property (nonatomic,weak) UIImageView *imgV2;
//
//@property (nonatomic,weak) UIImageView *imgV3;
@property(nonatomic,weak) UIView *imgSuperView;

@property (nonatomic,weak) UIView *line;

@property (nonatomic,weak) UILabel *bottomLab;
@property (nonatomic,weak) UILabel *bottomLab2;
@property (nonatomic, strong)UINavigationController * ShouKeBaoNav;



+ (instancetype)cellWithTableView:(UITableView *)tableView number:(NSInteger)number;

+(instancetype)cellWithCollectionView:(UICollectionView *)collectionView;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
