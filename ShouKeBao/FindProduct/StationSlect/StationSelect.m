//
//  StationSelect.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "StationSelect.h"
#import "IWHttpTool.h"
@interface StationSelect ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray *dataArr;
@property (copy,nonatomic) NSMutableString *stationName;
@property (copy,nonatomic) NSMutableString *stationNum;
@end

@implementation StationSelect

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换分站";
    
    self.table.rowHeight = 40;
    
    self.table.delegate = self;
    self.table.dataSource = self;
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(void)loadDataSource
{
    
    [IWHttpTool WMpostWithURL:@"/Product/GetSubstation" params:nil success:^(id json) {
         NSLog(@"------获取分站信息%@-------",json);
        for(NSDictionary *dic in json[@"Substation"]){
            [self.dataArr addObject:dic];
        }
        [self.table reloadData];
    } failure:^(NSError *error) {
        NSLog(@"获取分站信息请求失败，原因：%@",error);
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.stationName = _dataArr[indexPath.row][@"Text"];
    self.stationNum = [NSMutableString stringWithFormat:@"%@",_dataArr[indexPath.row][@"Value"]];
    [self.navigationController popViewControllerAnimated:YES];
   //储存substation
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
   [accountDefaults setObject:_stationNum forKey:@"Substation"];
    [accountDefaults setObject:_stationName forKey:@"SubstationName"];
    [accountDefaults synchronize];
    [self.delegate notifiToReloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"Station";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    cell.textLabel.text = _dataArr[indexPath.row][@"Text"];
    //    _dataArr[indexPath.row][@"Value"] 分站代号 int型
    return cell;
}

@end
