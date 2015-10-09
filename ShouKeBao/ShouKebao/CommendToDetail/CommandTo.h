//
//  CommandTo.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/9/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayDetail.h"

@interface CommandTo : UIView
//@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *retailsalesLabel;

@property (weak, nonatomic) IBOutlet UILabel *DiLabel;
@property (weak, nonatomic) IBOutlet UILabel *SongLabel;
@property (nonatomic, strong)DayDetail * productModel;
@property (nonatomic, strong)UINavigationController * NAV;
- (IBAction)cananl:(UIButton *)sender;
- (IBAction)nowsee:(UIButton *)sender;
@end
