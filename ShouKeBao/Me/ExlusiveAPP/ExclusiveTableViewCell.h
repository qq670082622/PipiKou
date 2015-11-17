//
//  ExclusiveTableViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExclusiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *todayDataBtn;



@property (weak, nonatomic) IBOutlet UILabel *builtCount;
@property (weak, nonatomic) IBOutlet UILabel *builtLable;

@property (weak, nonatomic) IBOutlet UILabel *productCount;
@property (weak, nonatomic) IBOutlet UILabel *productL;

@property (weak, nonatomic) IBOutlet UIView *livingCount;
@property (weak, nonatomic) IBOutlet UILabel *livingL;

@property (weak, nonatomic) IBOutlet UILabel *placeCount;
@property (weak, nonatomic) IBOutlet UILabel *placeL;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
