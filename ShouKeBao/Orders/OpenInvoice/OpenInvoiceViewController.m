//
//  OpenInvoiceViewController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/20.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "OpenInvoiceViewController.h"
#import "OrderinformationCell.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface OpenInvoiceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int _sectionStatus[5];//纪录每个分区的展开状况 0表示关闭  1表示展开
}
@property (nonatomic,strong) UITableView *TableView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSArray *SectionDataArr;
@end

@implementation OpenInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开具发票";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatDataArr];
    [self creatTableView];
}
-(UITableView *)TableView{
    if (!_TableView) {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, kScreenSize.width, kScreenSize.height-94) style:UITableViewStylePlain];
        _TableView.rowHeight = 500;
        _TableView.delegate = self;
        _TableView.dataSource = self;
        _TableView.tableFooterView = [[UIView alloc] init];
        [_TableView registerClass:[OrderinformationCell class] forCellReuseIdentifier:@"OrderinformationCell"];
    }
    return _TableView;
}
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSArray alloc] init];
    }
    return _dataArr;
}
-(NSArray *)secondDataArr{
    if (!_SectionDataArr) {
        _SectionDataArr = [[NSArray alloc] init];
    }
    return _SectionDataArr;
}

-(void)creatDataArr{
    
    self.SectionDataArr = @[@"201510081528090890",@"201510081528090630",@"201510081528090890",@"Hansm"];
}
-(void)creatTableView{
    UIView *HeadView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 30)];
    HeadView.backgroundColor = [UIColor colorWithRed:(245.0/255.0) green:(245.0/255.0) blue:(245.0/255.0) alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 70, 30)];
    label.text = @"订单信息";
    label.font = [UIFont boldSystemFontOfSize:16];
    [HeadView addSubview:label];
    [self.view addSubview:HeadView];
    [self.view addSubview:self.TableView];
}
#pragma mark TableViewDelegate &&  TableViewDataSource
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return self.SectionDataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_sectionStatus[section]) {
        return 1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderinformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderinformationCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.ScheduleProductLabel.text =
    cell.nav = self.navigationController;
    [cell  showDatawWithMe];
     return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *backgroundview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 1)];
    backgroundview1.backgroundColor = [UIColor blackColor];
    [view addSubview:backgroundview1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 70, 30)];
    label.text = @"订单编号";
    label.font = [UIFont systemFontOfSize:16];
    [view addSubview:label];
    UILabel *NumLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, kScreenSize.width/2, 30)];
    NumLabel.text = self.SectionDataArr[section];
    NumLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:NumLabel];
    UILabel *MoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width-kScreenSize.width/4, 0, 50, 30)];
    MoneyLabel.text = @"¥ 10";
    MoneyLabel.font = [UIFont systemFontOfSize:16];
    MoneyLabel.textColor = [UIColor orangeColor];
    [view addSubview:MoneyLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width-50, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"hongdian"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 101+section;
    [view addSubview:button];
    UIView *backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 29, kScreenSize.width, 1)];
    backgroundview.backgroundColor = [UIColor blackColor];
    [view addSubview:backgroundview];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
-(void)btnClick:(UIButton *)button{
    NSLog(@"点击红点");
    NSInteger section = button.tag - 101;
    _sectionStatus[section] = !_sectionStatus[section];
     [self.TableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    
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
