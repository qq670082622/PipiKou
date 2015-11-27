//
//  Customers.h
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
#import "messageCenterViewController.h"
#import "NewMessageCenterController.h"
#import "BBBadgeBarButtonItem.h"
#import "HomeHttpTool.h"

@interface Customers : SKViewController
@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)timeOrderAction:(id)sender;

//- (IBAction)orderNumAction:(id)sender;

- (IBAction)wordOrderAction:(id)sender;
- (IBAction)customSearch:(id)sender;
//标题弹出框
@property (weak, nonatomic) IBOutlet UITableView *popTableview;
@property (strong, nonatomic) UIView *shadeView;


@property (weak, nonatomic) IBOutlet UIButton *bellButton;
@property (weak, nonatomic) IBOutlet UILabel *messagePrompt;
@property (weak, nonatomic) IBOutlet UILabel *timePrompt;
@property (nonatomic,strong) NSMutableArray *isReadArr;
@property (nonatomic, assign)int messageCount;

@property (nonatomic, assign)NSInteger customerType;
@property (nonatomic, assign)BOOL isMe;
@end
