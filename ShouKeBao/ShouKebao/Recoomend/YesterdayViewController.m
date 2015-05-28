//
//  YesterdayViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "YesterdayViewController.h"
#import "YesterDayCell.h"
#import "addCustomerViewController.h"
@interface YesterdayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,strong) NSMutableArray *dataArr;
- (IBAction)push:(id)sender;
@end

@implementation YesterdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataSource];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadDataSource
{

}
-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (IBAction)push:(id)sender {
    [self.navigationController pushViewController:[[addCustomerViewController alloc] init] animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YesterDayCell *cell = [YesterDayCell cellWithTableView:tableView];
    cell.modal = self.dataArr[indexPath.row];
    return cell;
}
@end
