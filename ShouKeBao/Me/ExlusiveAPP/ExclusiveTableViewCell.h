//
//  ExclusiveTableViewCell.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeShareDetailModel.h"

@interface ExclusiveTableViewCell : UITableViewCell

@property (nonatomic, strong)MeShareDetailModel *model;


//今日数据
@property (weak, nonatomic) IBOutlet UIButton *todayDataBtn;

@property (weak, nonatomic) IBOutlet UILabel *builtCount;//已安装
@property (weak, nonatomic) IBOutlet UILabel *builtLable;

@property (weak, nonatomic) IBOutlet UILabel *productCount;//产品浏览
@property (weak, nonatomic) IBOutlet UILabel *productL;

@property (weak, nonatomic) IBOutlet UILabel *livingCount;//活跃数
@property (weak, nonatomic) IBOutlet UILabel *livingL;

@property (weak, nonatomic) IBOutlet UILabel *placeCount;//下单量
@property (weak, nonatomic) IBOutlet UILabel *placeL;

//历史数据
@property (weak, nonatomic) IBOutlet UIButton *historyDataBtn;
@property (weak, nonatomic) IBOutlet UILabel *H_builtCount;
@property (weak, nonatomic) IBOutlet UILabel *H_productCount;//
@property (weak, nonatomic) IBOutlet UILabel *H_livingCount;
@property (weak, nonatomic) IBOutlet UILabel *H_placeCount;

@property (weak, nonatomic) IBOutlet UIView *line2;






+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
