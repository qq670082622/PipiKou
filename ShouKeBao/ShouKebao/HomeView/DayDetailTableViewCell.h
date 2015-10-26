//
//  DayDetailTableViewCell.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DayDetail;
@interface DayDetailTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,copy) DayDetail *detail;
@property (strong, nonatomic) IBOutlet UIButton *descripBtn;//展开按钮
@property (strong, nonatomic) IBOutlet UILabel *titleLab;//产品标题
@property (strong, nonatomic) IBOutlet UIImageView *productImage;//产品图片

@property (strong, nonatomic) IBOutlet UILabel *descripLab;//简介
@property (strong, nonatomic) IBOutlet UILabel *productNum;//产品编号
@property (strong, nonatomic) IBOutlet UILabel *salePrice;//门市价
@property (strong, nonatomic) IBOutlet UILabel *peerPrice;//同行价


@end
