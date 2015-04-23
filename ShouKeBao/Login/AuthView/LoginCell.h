//
//  LoginCell.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/23.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginCellDelegate <NSObject>



@end

@interface LoginCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak) UIImageView *icon;

@property (nonatomic,weak) UITextField *inputField;

@property (nonatomic,weak) id<LoginCellDelegate> delegate;

@end
