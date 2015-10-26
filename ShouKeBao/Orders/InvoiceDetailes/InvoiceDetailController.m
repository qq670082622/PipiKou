//
//  InvoiceDetailController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/10/21.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "InvoiceDetailController.h"
#import "InvoiceStateCell.h"
#import "ShadowHandleCell.h"
#import "InvInformCell.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface InvoiceDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    int _sectionStatus[1];//纪录每个分区的展开状况 0表示关闭  1表示展开
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *SectionData;

@end

@implementation InvoiceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"发票详情";
    [self.view addSubview:self.tableView];
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
       [_tableView registerNib:[UINib nibWithNibName:@"ShadowHandleCell" bundle:nil] forCellReuseIdentifier:@"ShadowHandleCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"InvoiceStateCell" bundle:nil] forCellReuseIdentifier:@"InvoiceStateCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"InvInformCell" bundle:nil] forCellReuseIdentifier:@"InvInformCell"];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
-(NSArray *)SectionData{
    if (_SectionData == nil) {
        _SectionData = [[NSArray alloc] init];
        _SectionData = @[@"开票状态",@"跟踪处理",@"发票信息"];
    }
    return _SectionData;
}
#pragma mark UITableViewDataSource和UITableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        if (_sectionStatus[section]) {
            return 6;
        }
        return 3;
    }
       return 1;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 130;
    }
    return 210;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

         return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(indexPath.section == 0){
        InvoiceStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvoiceStateCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if(indexPath.section == 2){
        
        InvInformCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvInformCell" forIndexPath:indexPath];
       //InvInformCell *cell = [[InvInformCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    ShadowHandleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShadowHandleCell" forIndexPath:indexPath];
    //ShadowHandleCell *cell = [[ShadowHandleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ShadowHandleCell"];
    //cell.textLabel.text = @"测试";
    if (_sectionStatus[indexPath.section]) {
        if (indexPath.row == 5) {
            cell.CellButton.alpha = 1;
        }
    }else{
        if (indexPath.row == 2) {
            cell.CellButton.alpha = 1;
        }
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

//        UITableViewCell *cell = [[UITableViewCell alloc] init];
//        UIButton *qqqw = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width-70, 180, 50, 20)];
//        qqqw.backgroundColor = [UIColor colorWithRed:(240.0/255.0) green:(240.0/255.0) blue:(240.0/255.0) alpha:1];
//        qqqw.tag = 1101+indexPath.section;
//        NSLog(@"--%ld",qqqw.tag);
//        [qqqw setTitle:@"显示全部" forState:UIControlStateNormal];
//        [qqqw setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        qqqw.titleLabel.font = [UIFont systemFontOfSize:10];
//        [qqqw addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [qqqw.layer setMasksToBounds:YES];
//        [qqqw.layer setBorderWidth:1];
//        [qqqw.layer setCornerRadius:3];
//        [cell addSubview:qqqw];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        UIView *SectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 30)];
        SectionView.backgroundColor = [UIColor colorWithRed:(240.0/255.0) green:(240.0/255.0) blue:(240.0/255.0) alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 20)];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.text = self.SectionData[section];
        if (section == 1) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(75, 10, 50, 15)];
            [button setTitle:@"添加备注" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:10];
            button.tag = 1101;
            [button addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button.layer setMasksToBounds:YES];
            [button.layer setBorderWidth:1];
            [button.layer setCornerRadius:3];
            
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 0.5, 0.5, 0.5, 1 });
            button.layer.borderColor =borderColorRef;
            [SectionView addSubview:button];
        }
        [SectionView addSubview:label];
        return SectionView;

}
-(void)ClickBtn:(UIButton *)button{
    if (button.tag == 110) {
        NSLog(@"哈哈");
    }else
    
    {
    //if (button.tag == 1101) {
         NSLog(@"点击添加备注了");
   // }else{
        NSInteger section = button.tag - 1100;
        _sectionStatus[section] = !_sectionStatus[section];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"显示全部");

    }
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
