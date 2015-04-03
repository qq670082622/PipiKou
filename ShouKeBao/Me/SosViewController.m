//
//  SosViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/1.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SosViewController.h"
#import "MeHttpTool.h"

@interface SosViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailLab;

@property (weak, nonatomic) IBOutlet UILabel *phoneLav;

@property (weak, nonatomic) IBOutlet UILabel *QQLab;

@end

@implementation SosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搬救兵";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.tableView.scrollEnabled = NO;
    
    [self setHead];
    
    [self loadDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"plusdaohang1"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)loadDataSource
{
    [MeHttpTool getReinforcementsWithsuccess:^(id json) {
        if (json) {
            NSLog(@"---------%@",json);
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setHead
{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"SosHead" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 180);
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plusbanjiubingbg"]];
    self.tableView.tableHeaderView = view;
}

@end
