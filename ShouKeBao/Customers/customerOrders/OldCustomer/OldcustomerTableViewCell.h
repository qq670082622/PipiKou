//
//  OldcustomerTableViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/20.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomModel.h"

@interface OldcustomerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userTele;
@property (weak, nonatomic) IBOutlet UILabel *userOders;
@property (weak, nonatomic) IBOutlet UILabel *userName;
- (IBAction)callAction:(id)sender;

@property(nonatomic,strong) CustomModel *model;


+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
