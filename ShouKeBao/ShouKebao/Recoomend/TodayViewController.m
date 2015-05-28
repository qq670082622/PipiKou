//
//  TodayViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "TodayViewController.h"
#import "TodayCell.h"
@interface TodayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataSource];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayCell *cell = [TodayCell cellWithTableView:tableView];
    cell.modal = self.dataArr[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
