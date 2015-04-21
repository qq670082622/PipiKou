//
//  ProductHistoryCell.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ProductCell.h"

@class ProductModal;
@interface ProductHistoryCell : ProductCell

@property (nonatomic,strong) ProductModal *historyModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
