//
//  OldCustomerViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/20.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SKViewController.h"

@interface OldCustomerViewController : SKViewController
@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)timeOrderAction:(id)sender;
- (IBAction)wordOrderAction:(id)sender;
- (IBAction)customSearch:(id)sender;
@end
