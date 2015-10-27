//
//  addSubCondController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "addSubCondController.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface addSubCondController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *cellNameArr;
@property (nonatomic,strong) UIView *footView;
@end

@implementation addSubCondController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加订阅条件";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatRightNav];
    //
    UIView *footSta = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 8)];
    footSta.backgroundColor = [UIColor lightGrayColor];
    footSta.alpha = 0.3;
    [self.footView addSubview:footSta];
    [self.view addSubview:self.tableView];
}
-(NSArray *)cellNameArr{
    if (_cellNameArr == nil) {
        _cellNameArr = [[NSArray alloc] initWithObjects:@"目的地",@"出发日期",@"行程天数",@"出发地",@"供应商" ,nil];
    }
    return _cellNameArr;
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0 , kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
        _tableView.rowHeight = 50;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = self.footView;
    }
    return _tableView;
}
-(UIView *)footView{
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 360)];
        _footView.backgroundColor = [UIColor whiteColor];
    }
    return _footView;
}
/*
 //自定义尾视图
 UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 443)];//原来是158，388
 UIView *footSta = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 8)];
 footSta.backgroundColor = [UIColor lightGrayColor];
 footSta.alpha = 0.3;
 [footView addSubview:footSta];

 */
-(void)creatRightNav{
    UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    turnOff.titleLabel.font = [UIFont systemFontOfSize:15];
    turnOff.frame = CGRectMake(0, 0, 30, 10);
    turnOff.tag = 211;
    [turnOff addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [turnOff setTitle:@"重置"  forState:UIControlStateNormal];
    turnOff.titleEdgeInsets = UIEdgeInsetsMake(-2, -35, 0, 0);
    [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];
    self.navigationItem.rightBarButtonItem = turnOffItem;
}

-(void)btnClick:(UIButton *)button{
NSLog(@"点击重置")
    ;
}
#pragma mark - UITableView的协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellNameArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 50)];
    cell.textLabel.text = self.cellNameArr[indexPath.row];
    UILabel *noLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2, 10, kScreenSize.width/3+20, 30)];
    noLabel.text = @"不限";
    noLabel.textAlignment = UITextLayoutDirectionRight;
    noLabel.textColor = [UIColor lightGrayColor];
    noLabel.font = [UIFont systemFontOfSize:14];
    [cell addSubview:noLabel];
    UIImageView *rigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 30, 15, 20, 20)];
    rigImageView.image = [UIImage imageNamed:@"xiangyou"];
    [cell addSubview:rigImageView];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
