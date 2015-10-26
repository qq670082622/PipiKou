//
//  QRHistoryTableViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/15.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

@interface QRHistoryTableViewController : SKViewController
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic, strong)UINavigationController *identifyNav;
@property(nonatomic,assign) BOOL isLogin;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (nonatomic,assign) BOOL isEditing;


-(void)editHistoryDetail;

@end
