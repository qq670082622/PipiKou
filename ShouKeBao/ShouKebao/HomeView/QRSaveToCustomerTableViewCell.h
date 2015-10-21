//
//  QRSaveToCustomerTableViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/20.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomModel.h"
@interface QRSaveToCustomerTableViewCell : UITableViewCell

@property (nonatomic, weak)UILabel *nameL;
@property (nonatomic, weak)UILabel *telNumberL;

@property (strong, nonatomic)CustomModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
