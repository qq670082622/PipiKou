//
//  NewCustomerCell.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomDynamicModel;
@interface NewCustomerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *TitleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *custNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *custNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (nonatomic, strong)CustomDynamicModel * model;
@end
