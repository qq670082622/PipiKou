//
//  MeShareChooseViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeShareChooseViewController.h"
#import "ShaiXuanCell.h"
#import "ShaiXuanViewController.h"
#import "ChooseDayViewController.h"
#import "ConditionSelectViewController.h"

@interface MeShareChooseViewController ()<UITableViewDataSource, UITableViewDelegate, ChooseDayViewControllerDelegate, passValue>

@property (nonatomic, strong)UITableView *resetTableView;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)ShaiXuanViewController *shaixuanVC;
@property (strong,nonatomic) NSMutableArray *subIndicateDataArr1;
@property(copy,nonatomic) NSMutableString *goDateStart;//出发期
@property(copy,nonatomic) NSMutableString *goDateEnd;//结束期
@property(nonatomic,copy) NSMutableString *month;//日期
@property(nonatomic,strong) NSArray *keydataArr;//返回字典key的名字
@property (strong,nonatomic) NSMutableDictionary *conditionDic;//当前条件开关

@end

@implementation MeShareChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"筛选";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.resetTableView];
    [self setRightBarButton];
    
    self.dataArray = @[@"目的地", @"出发城市", @"行程天数", @"游览线路"];
    self.subIndicateDataArr1 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ", nil];
    //    self.keydataArr = @[@"Destination",@"StartCity",@"GoDate",@"ScheduleDays",@"ProductBrowseTag",@"Supplier",@"ProductThemeTag",@"HotelStandard",@"TrafficType",@"CruiseShipCompany"];
    self.keydataArr = @[@"Destination",@"StartCity",@"ScheduleDays",@"ProductBrowseTag"];
    self.month = [NSMutableString stringWithFormat:@""];
}


#pragma mark - 各种初始化
- (UITableView *)resetTableView{
    if (!_resetTableView) {
        _resetTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _resetTableView.tableFooterView = [[UIView alloc]init];
        _resetTableView.delegate = self;
        _resetTableView.dataSource = self;
    }
    return _resetTableView;
}
-(NSArray *)dataArr{
    if (_dataArray == nil) {
        self.dataArray = [NSArray array];
    }
    return _dataArray;
}
-(NSMutableDictionary *)conditionDic{
    if (_conditionDic == nil) {
        self.conditionDic = [NSMutableDictionary dictionary];
    }
    return _conditionDic;
}
-(NSMutableArray *)conditionArr{
    if (_conditionArr == nil) {
        _conditionArr = [NSMutableArray array];
    }
    return _conditionArr;
}
- (NSArray *)keydataArr{
    if (_keydataArr == nil) {
        _keydataArr = [NSArray array];
    }
    return _keydataArr;
}
- (ShaiXuanViewController *)shaiXuanVC{
    if (!_shaixuanVC) {
        self.shaixuanVC = [[ShaiXuanViewController alloc]init];
    }
    return _shaixuanVC;
}


#pragma mark - UITableView - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reset = @"reset";
    ShaiXuanCell *cell = [tableView dequeueReusableCellWithIdentifier:reset];
    if (cell == nil) {
        cell = [[ShaiXuanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reset];
    }
//    赋值
    cell.str = self.dataArray[indexPath.row];
    cell.contentStr = self.subIndicateDataArr1[indexPath.row];
    NSString *detailStr = self.subIndicateDataArr1[indexPath.row];
    if (!detailStr.length || [detailStr isEqualToString:@" "]) {
        cell.contentStr = @"不限";
    }else{
        cell.contentStr = self.subIndicateDataArr1[indexPath.row];
    }
    [cell showdataWithString:cell.str];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [self.shaixuanVC putTextField];
     NSDictionary *conditionDic;
    for (NSInteger i = 0 ; i<[_conditionArr count]; i++) {
        if ([[_conditionArr objectAtIndex:i] objectForKey:self.keydataArr[indexPath.row]]) {
            conditionDic = _conditionArr[i];
        }
    }

    ConditionSelectViewController *conditionVC = [[ConditionSelectViewController alloc]init];
    conditionVC.delegate = self;
    conditionVC.conditionDic = conditionDic;
    
    NSArray *arr = [NSArray arrayWithObjects:0,[NSString  stringWithFormat:@"%ld",(long)indexPath.row], nil];
    conditionVC.superViewSelectIndexPath = arr;//取出第几行被选择（因为是数组代表分区和row）
    conditionVC.title = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:conditionVC animated:YES];
    
}





#pragma mark - 从后页面向前传值的代理方法/key:大字典的key value:字典中某一子value的值
-(void)passKey:(NSString *)key andValue:(NSString *)value andSelectIndexPath:(NSArray *)selectIndexPath andSelectValue:(NSString *)selectValue{
    if (value) {
        [self.conditionDic setObject:value forKey:key];
        NSLog(@"-------------传过来的key is %@------------",key);
        NSInteger a = [selectIndexPath[1] integerValue];
        self.subIndicateDataArr1[a] = selectValue;
        [self.resetTableView reloadData];
        NSLog(@"-----------conditionDic is %@--------",self.conditionDic);
    }
}

#pragma mark - 重置方法
- (void)setRightBarButton{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"重置" style:UIBarButtonItemStyleBordered target:self action:@selector(resetAction)];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)resetAction{
    //        self.conditionDic = nil;
    self.subIndicateDataArr1 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ", nil];
    self.goDateStart = [NSMutableString stringWithFormat:@""];
    self.goDateEnd = [NSMutableString stringWithFormat:@""];
    self.month = [NSMutableString stringWithFormat:@""];
    [self.resetTableView reloadData];
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
