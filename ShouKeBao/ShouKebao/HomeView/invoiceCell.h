//
//  invoiceCell.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeBase.h"
@interface invoiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *InvoiceOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *InvoriceProTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *InvoriceNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *InvoriceCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *InvoriceTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *OrderTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *InvoriceTimeLabel;

//-(void)showDataWithModel:(HomeBase *)model;
-(void)showDataWithModel;
@end
