//
//  OpprotunityFreqCell.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomDynamicModel;

@interface OpprotunityFreqCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *topTitleLab;
@property (strong, nonatomic) IBOutlet UIImageView *TitleImage;
@property (strong, nonatomic) IBOutlet UIImageView *sandian;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *BodyLabel;//产品介绍
@property (weak, nonatomic) IBOutlet UIImageView *HeadImage;
@property (weak, nonatomic) IBOutlet UILabel *MenShiLabel;//门市价
@property (weak, nonatomic) IBOutlet UILabel *SameJobLabel;//同行价
@property (weak, nonatomic) IBOutlet UILabel *NumberLabel;//编号
@property (weak, nonatomic) IBOutlet UILabel *DiLabel;
@property (weak, nonatomic) IBOutlet UILabel *SongLabel;
@property (weak, nonatomic) IBOutlet UILabel *ProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimerLabel;
@property (nonatomic, strong)CustomDynamicModel * model;

@end
