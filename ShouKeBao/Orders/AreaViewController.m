//
//  AreaViewController.m
//  ShouKeBao
//
//  Created by Chard on 15/3/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "AreaViewController.h"
#import "OrderTool.h"

@interface AreaViewController ()

@property (nonatomic,copy) NSDictionary *chooseDic;

@end

@implementation AreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self configure];
    
    [self loadDataSource];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectAreaWithValue:Type:)]) {
        [_delegate didSelectAreaWithValue:self.chooseDic Type:self.type];
    }
}

#pragma mark - private
- (void)configure
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - loadDataSource
- (void)loadDataSource
{
    if (self.type == firstArea){
        return;
    }else if (self.type == secondArea){
        // 获取二级菜单
        [OrderTool getSecondLevelAreaWithParam:self.param success:^(id json) {
            if (json) {
                NSLog(@"-----%@",json);
                [self.dataSource removeAllObjects];
                for (NSDictionary *dic in json[@"LevelAreaList"]) {
                    [self.dataSource addObject:dic];
                }
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        // 获取三级菜单
        [OrderTool getThirdLevelAreaWithParam:self.param success:^(id json) {
            if (json) {
                NSLog(@"-----%@",json);
                [self.dataSource removeAllObjects];
                for (NSDictionary *dic in json[@"LevelAreaList"]) {
                    [self.dataSource addObject:dic];
                }
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark - getter
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"areacell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.dataSource[indexPath.row][@"Text"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.chooseDic = self.dataSource[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

@end
