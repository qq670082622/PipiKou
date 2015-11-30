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
@property (weak, nonatomic) IBOutlet UIView *DiImageView;

@property (weak, nonatomic) IBOutlet UIView *SongImageView;

@property (weak, nonatomic) IBOutlet UILabel *DiRMBImage;
@property (weak, nonatomic) IBOutlet UILabel *SongRMBImage;
@property (weak, nonatomic) IBOutlet UIImageView *shandianImage;

@property (weak, nonatomic) IBOutlet UILabel *DiLabel;
@property (weak, nonatomic) IBOutlet UILabel *SongLabel;
@property (weak, nonatomic) IBOutlet UIImageView *PicImage;
@property (nonatomic, strong)UINavigationController * NAV;
@property (nonatomic, strong)DayDetail * productModel;
@property (nonatomic,strong) NSString *NewPageUrl;
@property (nonatomic,strong) NSMutableDictionary *shareInfo;
- (IBAction)cananl:(UIButton *)sender;
- (IBAction)nowsee:(UIButton *)sender;
@end
