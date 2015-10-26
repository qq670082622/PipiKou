//
//  invoiceCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "invoiceCell.h"

@implementation invoiceCell

-(void)showDataWith{
    self.InvoiceOrderLabel.text = @"12433";
    //self.InvoiceOrderLabel.text = model.
    self.InvoriceCodeLabel.text = @"qwerqew";
    //self.InvoriceCodeLabel.text = model.
    self.InvoriceNumLabel.text = @"asdfa";
    //self.InvoriceNumLabel.text = model.
    self.InvoriceTotalLabel.text = @"erqwrq";
    //self.InvoriceTotalLabel.text = model.
    self.InvoriceProTitleLabel.text = @"asdfasf";
    //self.InvoriceProTitleLabel.text = model.
    self.InvoriceTimeLabel.text = @"2015-10-11 13.25";
    //self.InvoriceTimeLabel.text = model.
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
