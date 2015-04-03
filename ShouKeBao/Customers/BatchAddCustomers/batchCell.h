//
//  batchCell.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "batchModel.h"
@class batchModel;
@interface batchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *recordId;
@property (weak, nonatomic) IBOutlet UILabel *tele;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (strong ,nonatomic) batchModel *model;
+(instancetype)cellWithTableView:(UITableView *)table;
@end
