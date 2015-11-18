//
//  OpportunitykeywordCell.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomDynamicModel;

@interface OpportunitykeywordCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *topTitleLab;
@property (strong, nonatomic) IBOutlet UIImageView *TitleImage;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *CustNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *HeadImage;
@property (weak, nonatomic) IBOutlet UILabel *ContactNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimerLabel;
@property (nonatomic, strong)CustomDynamicModel * model;

@end
