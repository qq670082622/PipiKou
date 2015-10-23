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
@end

@implementation MeShareChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"筛选";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.resetTableView];
    [self setRightBarButton];
    
    self.dataArray = @[@"目的地", @"出发城市", @"行程天书", @"游览线路"];
    
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
    cell.str = self.dataArray[indexPath.row];
    [cell showdataWithString:cell.str];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.shaixuanVC putTextField];
    if (indexPath.row == 2) {
        ChooseDayViewController *choose = [[ChooseDayViewController alloc]init];
        choose.delegate = self;
//        NSDictionary *conditionDic;
//        choose.buttons = conditionDic;
        choose.needMonth = @"1";
        [self.navigationController pushViewController:choose animated:YES];
        
    }else if(indexPath.row != 2){
//        NSDictionary *conditionDic;
        ConditionSelectViewController *conditionVC = [[ConditionSelectViewController alloc]init];
        conditionVC.delegate = self;
//        conditionVC.conditionDic = conditionDic;
        NSArray *arr = [NSArray arrayWithObjects:0,[NSString  stringWithFormat:@"%ld",(long)indexPath.row], nil];
        conditionVC.superViewSelectIndexPath = arr;//取出第几行被选择
        conditionVC.title = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:conditionVC animated:YES];
    }
}




- (void)setRightBarButton{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"重置" style:UIBarButtonItemStyleBordered target:self action:@selector(resetAction)];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)resetAction{
    NSLog(@"vvvvvvvvv");
    
}
-(void)passKey:(NSString *)key andValue:(NSString *)value andSelectIndexPath:(NSArray *)selectIndexPath andSelectValue:(NSString *)selectValue{
    
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
