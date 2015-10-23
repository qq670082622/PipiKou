//
//  messageCell.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageModel.h"
@class messageModel;
@interface messageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hongdian;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (strong,nonatomic) messageModel *model;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong) NSMutableArray *isReadArr;
@end
