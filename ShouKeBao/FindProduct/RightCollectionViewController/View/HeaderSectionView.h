//
//  HeaderSectionView.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/10.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderSectionView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UIButton *allBtn;
@property (nonatomic, strong)UINavigationController * FindProductNav;
@property (strong, nonatomic) IBOutlet UIView *spotView;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UIView *seperateLine;
@end
