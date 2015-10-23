//
//  QRCodeCell.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/7/28.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class personIdModel;
@interface QRCodeCell : UITableViewCell

@property (nonatomic, strong)personIdModel * model;
+(instancetype)relationHistoryXib;

@end
