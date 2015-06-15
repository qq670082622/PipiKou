//
//  QRHistoryViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/29.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "QRHistoryViewController.h"
#import "WriteFileManager.h"
#import "personIdModel.h"
#import "CardTableViewController.h"
#import "userIDTableviewController.h"
#import "IWHttpTool.h"
@interface QRHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,assign) BOOL isEditing;
@property (weak, nonatomic) IBOutlet UIView *subView;

@property(nonatomic,strong) NSMutableArray *editArr;
- (IBAction)deleteAction:(id)sender;
- (IBAction)saveToCustom:(id)sender;

@end

@implementation QRHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.rowHeight = 70;
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(EditCustomerDetail)];
    
    self.navigationItem.rightBarButtonItem= barItem;
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


-(void)EditCustomerDetail
{
      self.dataArr = [NSMutableArray arrayWithArray: [WriteFileManager WMreadData:@"scanning"]];
    
    //personIdModel *model = _dataArr[0];
    UILabel *testLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 320, 500)];
    testLab.backgroundColor = [UIColor whiteColor];
    testLab.text = [NSString stringWithFormat:@"(用来测试后台返回的数据，8秒后自动删除)\n\narr is %lu----,modelName is",self.dataArr.count];
    testLab.numberOfLines = 0;
    [self.view.window addSubview:testLab];

    if (self.subView.hidden == YES && !self.isEditing) {
       
        self.subView.hidden = NO;
        [self.table setEditing:YES animated:YES];
        self.isEditing = YES;
        
        
        self.navigationItem.rightBarButtonItem.title = @"取消";
        
    }else if (self.subView.hidden == NO && self.isEditing){
        self.subView.hidden = YES;
        
        [self.table setEditing:NO animated:YES];
        self.isEditing = NO;
        
        
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        self.dataArr = [NSMutableArray array];
        
//        for (int i =0; i<10; i++) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            [dic setObject:[NSString stringWithFormat:@"帅哥%d号",i+1]  forKey:@"name"];
//            [dic setObject:[NSString stringWithFormat:@"证件号码:11223345%d",i]  forKey:@"cardNum"];
//              [dic setObject:[NSString stringWithFormat:@"创建时间:1992.04.1%d",i]  forKey:@"creatTime"];
//            [self.dataArr addObject:dic];
        //}
    }
    return _dataArr;
}

-(NSMutableArray *)editArr
{
    if (_editArr == nil){
        self.editArr = [NSMutableArray array];
    }
    return _editArr;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
static NSString *cellID = @"QRHistoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        personIdModel *model = self.dataArr[indexPath.row];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 35, 35)];
        [cell.contentView addSubview:imgV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+10, 10, 200, 20)];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = model.UserName;
        [cell.contentView addSubview:label];
        
        UILabel *codeLab = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame)+10, 200, 20)];
        codeLab.textColor = [UIColor grayColor];
        codeLab.font = [UIFont systemFontOfSize:12];
        codeLab.textAlignment = NSTextAlignmentLeft;
       
        [cell.contentView addSubview:codeLab];
        
        UILabel *creatLab = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-130, codeLab.frame.origin.y, 130, 20)];
        creatLab.textColor = [UIColor grayColor];
        creatLab.font = [UIFont systemFontOfSize:13];
        creatLab.textAlignment = NSTextAlignmentRight;
        creatLab.text = model.createTime;
        
        
        if ([model.type isEqualToString:@"passport"]) {
            imgV.image = [UIImage imageNamed:@"passPort"];
             codeLab.text = model.PassportNum;
        }else if([model.type isEqualToString:@"personId"]){
            imgV.image = [UIImage imageNamed:@"IDInform"];
            codeLab.text = model.CardNum;
        }

        [cell.contentView addSubview:creatLab];
    }
  

    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    personIdModel *model = _dataArr[indexPath.row];
    
    if (self.table.editing == YES) {
        
        [self.editArr addObject:model];
        
    }else if (self.table.editing == NO){
        if ([model.type isEqualToString:@"personId"]) {
            userIDTableviewController *uid = [[userIDTableviewController alloc] init];
            uid.model = model;
                   [self.navigationController pushViewController:uid animated:YES];

        }else if ([model.type isEqualToString:@"passport"]){
            CardTableViewController *ca = [[CardTableViewController alloc] init];
            ca.model = model;
            [self.navigationController pushViewController:ca animated:YES];

        }

    }
    
    
//    NSLog(@"--------editArr is %@--------indexpath.row's model is %@---",_editArr,_dataArr[indexPath.row]);
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // remondModel *model = _dataArr[indexPath.row];
    personIdModel *model = self.dataArr[indexPath.row];
    if (self.table.editing == YES) {
        
        [self.editArr removeObject:model];
        
    }
    
  //  NSLog(@"--------editArr is %@--------indexpath.row's model is %@---",_editArr,_dataArr[indexPath.row]);
    
}



- (IBAction)deleteAction:(id)sender {
    
    for (int i = 0; i<self.editArr.count; i++) {
        [self.dataArr removeObject:self.editArr[i]];
    }
    [WriteFileManager WMsaveData:self.dataArr name:@"scanning"];
    [self.table reloadData];
    
}

- (IBAction)saveToCustom:(id)sender {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for(int i = 0 ;i<_editArr.count;i++){
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        personIdModel *model = _editArr[i];
        
        //[dic setValue:model.name forKey:@"Name"];
       // [dic setValue:model.tel forKey:@"Mobile"];
        [arr addObject:dic];
        
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];//@"/Customer/CreateCustomerList"
    [dic setObject:arr forKey:@"CustomerList"];
    
    [IWHttpTool WMpostWithURL:@"/Customer/CreateCustomerList" params:dic success:^(id json) {
        NSLog(@"批量导入客户成功 返回json is %@",json);
       // [self.delegate referesh];
    } failure:^(NSError *error) {
        NSLog(@"批量导入客户失败，返回error is %@",error);
    }];
    [self.navigationController popViewControllerAnimated:YES];

}
@end
