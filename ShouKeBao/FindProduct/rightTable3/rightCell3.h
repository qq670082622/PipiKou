//
//  rightCell3.h
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rightModal3.h"
@class rightModal3;
@interface rightCell3 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong , nonatomic) rightModal3 *modal;
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
