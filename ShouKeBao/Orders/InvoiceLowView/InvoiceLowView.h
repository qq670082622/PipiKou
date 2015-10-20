//
//  InvoiceLowView.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/19.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceLowView : UIView
@property (nonatomic,strong) UINavigationController *LowNav;
- (IBAction)SelectAllBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
- (IBAction)InbatchesbBtn:(UIButton *)sender;

@end
