//
//  remondViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/31.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "remondViewController.h"
#import "addRemondViewController.h"
#import "IWHttpTool.h"
#import "RemindDetailViewController.h"
#import "WriteFileManager.h"
#import "CustomModel.h"

@interface remondViewController ()<UITableViewDataSource,UITableViewDelegate,ringToRefreshTheRemind>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray *dataArr;
- (IBAction)addRemond:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (strong,nonatomic) NSMutableArray *editArr;
- (IBAction)deletAction:(id)sender;

@property (nonatomic,assign) BOOL isEditing;
@property (strong, nonatomic) IBOutlet UIView *footView;

@end

@implementation remondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self loadData];
    [self setUpRightButton];
    self.table.separatorStyle = UITableViewCellAccessoryNone;
    
    UIView *footView = [[[NSBundle mainBundle] loadNibNamed:@"remondViewController" owner:self options:nil] lastObject];
    self.table.tableFooterView = footView;
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    self.table.rowHeight = 62;

    
    
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)setUpRightButton{

    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(EditCustomerDetail)];
    
    self.navigationItem.rightBarButtonItem= barItem;
}
-(void)EditCustomerDetail
{
    if (self.subView.hidden == NO && !self.isEditing) {
        self.subView.hidden = YES;
        self.deleBtn.hidden = NO;
        [self.table setEditing:YES animated:YES];
        self.isEditing = YES;

        
        self.navigationItem.rightBarButtonItem.title = @"取消";

    }else if (self.subView.hidden == YES && self.isEditing){
        self.subView.hidden = NO;
        self.deleBtn.hidden = YES;
        [self.table setEditing:NO animated:YES];
        self.isEditing = NO;

        
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
    
}

-(void)loadData
{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.ID forKey:@"CustomerID"];
    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomerRemindList" params:dic success:^(id json) {
        NSLog(@"提醒列表json is %@",json);
        [self.dataArr removeAllObjects];
        for(NSDictionary *dic in json[@"CustomerRemindList"]){
            remondModel *model = [remondModel modalWithDict:dic];
            model.name = self.customModel.Name;
            model.phone = self.customModel.Mobile;
            [self.dataArr addObject:model];
        }
        [self.table reloadData];
        
        // 保存添加的提醒
        [WriteFileManager saveData:self.dataArr name:@"remindData"];
        
    } failure:^(NSError *error) {
        NSLog(@"客户提醒列表请求错误 %@",error);
    }];
}

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)editArr
{
    if (_editArr == nil) {
        self.editArr = [NSMutableArray array];
    }
    return _editArr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    remondModel *model = _dataArr[indexPath.row];
    if (self.table.editing == YES) {
       
        [self.editArr addObject:model];
      
    }else if (self.table.editing == NO){
        RemindDetailViewController *remondDetail = [[RemindDetailViewController alloc] init];
        remondDetail.time = model.RemindTime;
        remondDetail.note = model.Content;
        [self.navigationController pushViewController:remondDetail animated:YES];
    }
    
    
    NSLog(@"--------editArr is %@--------indexpath.row's model is %@---",_editArr,_dataArr[indexPath.row]);
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    remondModel *model = _dataArr[indexPath.row];
    if (self.table.editing == YES) {
        
    [self.editArr removeObject:model];
        
    }
   
    NSLog(@"--------editArr is %@--------indexpath.row's model is %@---",_editArr,_dataArr[indexPath.row]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return     self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    remondTableViewCell *cell = [remondTableViewCell cellWithTableView:tableView];
    cell.model = _dataArr[indexPath.row];
    return cell;

}

- (IBAction)addRemond:(id)sender {
    
    addRemondViewController *add = [[addRemondViewController alloc] init];
    add.ID = self.ID;
    add.delegate = self;
    [self.navigationController pushViewController:add animated:YES];
    
}
#pragma -mark addRemindDelegate
-(void)ringToRefreshRemind
{
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"更新中...";
    [hudView show:YES];
    [self loadData];
    hudView.labelText = @"更新成功";
    [hudView hide:YES afterDelay:1];
    [self.table reloadData];
   
}
- (IBAction)deletAction:(id)sender {
    NSLog(@"_editArr is %@",_editArr);
   
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<self.editArr.count; i++) {
        remondModel *model = _editArr[i];
        [arr addObject:model.ID];
    
        [self.dataArr removeObject:_editArr[i]];
    }
    
    if (arr) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:arr forKey:@"CustomerRemindIDList"];
        [dic setObject:self.ID forKey:@"CustomerID"];
        [IWHttpTool WMpostWithURL:@"/Customer/DeleteCustomerRemindList" params:dic success:^(id json) {
            NSLog(@"删除客户提醒成功%@",json);
            [self.dataArr removeAllObjects];
            for(NSDictionary *dic in  json[@"CustomerRemindList"]){
                remondModel  *model = [remondModel modalWithDict:dic];
                
                [self.dataArr addObject:model];
            }
            [self.table reloadData];
            
        } failure:^(NSError *error) {
            NSLog(@"删除客户提醒请求失败%@",error);
        }];
        
        [self.table setEditing:NO animated:YES];
        [self.table reloadData];

    }else if (!arr){
    [self.table setEditing:NO animated:YES];
    }
    
    }
@end
