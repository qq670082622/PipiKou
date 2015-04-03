//
//  CustomCell.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//
#import "CustomModel.h"
#import <UIKit/UIKit.h>
@class CustomModel;
@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTele;
@property (weak, nonatomic) IBOutlet UILabel *userOders;

@property(nonatomic,strong) CustomModel *model;
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
