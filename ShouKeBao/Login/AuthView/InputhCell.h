//
//  InputhCell.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/5/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputhCell : UITableViewCell

@property (nonatomic,weak) UITextField *inputField;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
