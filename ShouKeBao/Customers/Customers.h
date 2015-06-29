//
//  Customers.h
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"


@interface Customers : SKViewController
@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)timeOrderAction:(id)sender;

//- (IBAction)orderNumAction:(id)sender;

- (IBAction)wordOrderAction:(id)sender;
- (IBAction)customSearch:(id)sender;


@end
