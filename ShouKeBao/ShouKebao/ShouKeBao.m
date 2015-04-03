//
//  ShouKeBao.m
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ShouKeBao.h"
#import "MJRefresh.h"
#import "OrderCell.h"
#import "OrderModel.h"
#import "SearchProductViewController.h"
#import "ShouKeBaoCell.h"
#import "StationSelect.h"
#import "StoreViewController.h"
#import "QRCodeViewController.h"
#import "ResizeImage.h"
#import "BBBadgeBarButtonItem.h"
#import "messageCenterViewController.h"
@interface ShouKeBao ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
- (IBAction)changeStation:(id)sender;
- (IBAction)phoneToService:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *yesterDayOrderCount;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayVisitors;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UITableView *Table;

@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UIButton *stationName;

- (IBAction)search:(id)sender;

- (IBAction)add:(id)sender;
@end

@implementation ShouKeBao

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customLeftBarItem];
    [self customRightBarItem];
    self.searchBtn.layer.cornerRadius = 4;
    self.searchBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.searchBtn.layer.borderWidth = 0.5f;
    self.searchBtn.layer.masksToBounds = YES;
   self.Table.rowHeight = 40;
   
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToStore)];
    [self.upView addGestureRecognizer:tap];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    NSString *subStationName = [udf stringForKey:@"SubstationName"];
    if (subStationName) {
        [self.stationName setTitle:subStationName forState:UIControlStateNormal];
    }else if (!subStationName){
        [self.stationName setTitle:@"上海" forState:UIControlStateNormal];
    }
    
}
-(void)pushToStore
{
    StoreViewController *store =  [[StoreViewController alloc] init];
    store.PushUrl = @"http://skb.lvyouquan.cn/mc/kaifaceshi/";
    [self.navigationController pushViewController:store animated:YES];

}

-(void)customLeftBarItem
{
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [customButton addTarget:self action:@selector(ringAction) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"lingdang1"] forState:UIControlStateNormal];
    
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    
    barButton.badgeValue = @"12";
    barButton.shouldHideBadgeAtZero = YES;
    
    self.navigationItem.leftBarButtonItem = barButton;
    
    //改变badgeValue的值
    //    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItem;
    //    barButton.badgeValue = [NSString stringWithFormat:@"%d", [barButton.badgeValue intValue] + 1];
}

-(void)customRightBarItem
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setImage:[UIImage imageNamed:@"erweima"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
}

-(void)ringAction
{

    messageCenterViewController *messgeCenter = [[messageCenterViewController alloc] init];
    [self.navigationController pushViewController:messgeCenter animated:YES];
    
}
-(void)codeAction
{
    [self.navigationController pushViewController:[[QRCodeViewController alloc] init] animated:YES];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        ShouKeBaoCell *cell = [ShouKeBaoCell cellWithTableView:tableView];
    
    return cell;
   }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeStation:(id)sender {
    
    [self.navigationController pushViewController:[[StationSelect alloc] init] animated:YES];
}

- (IBAction)phoneToService:(id)sender {

}

- (IBAction)search:(id)sender {
    
    SearchProductViewController *searchVC = [[SearchProductViewController alloc] init];
   
    [self.navigationController pushViewController:searchVC animated:YES];

}

- (IBAction)add:(id)sender {
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}
@end
