//
//  MeShareDetailTableViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeShareDetailModel.h"
@interface MeShareDetailTableViewCell : UITableViewCell
@property (nonatomic, weak)UIImageView *imageV;
@property (nonatomic, weak)UILabel *titleLable;
@property (nonatomic, weak)UILabel *goLable;
@property (nonatomic, weak)UILabel *skimLable;
@property (nonatomic, weak)UILabel *orderLable;

@property (nonatomic, strong)MeShareDetailModel *shareModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

