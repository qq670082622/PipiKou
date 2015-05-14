//
//  ConditionSelectViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ConditionSelectViewController.h"
#import "WriteFileManager.h"
@interface ConditionSelectViewController ()
@property (nonatomic,copy)NSMutableString *passValue;
@property (nonatomic,copy)NSMutableString *selectKey;
@property (nonatomic,copy)NSMutableString *selectValue;
@property (nonatomic,copy) NSMutableDictionary *conditionSelectDiction;
@end

@implementation ConditionSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.title = self.conditionTitle;
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
 
    self.table.tableFooterView = [[UIView alloc] init];
    
    NSLog(@"------------当前页面选择的条件为%@--------------------------",[self.conditionSelectDiction objectForKey:self.title]);
    
    [self conditionSelectDiction];
    
}

-(void)changeSelectKey
{
    if ([_selectKey isEqualToString:@"ProductBrowseTag"]) {
        
        self.selectKey = [NSMutableString stringWithFormat:@"ProductBrowseTagID"];
    }
    
    else if ([_selectKey isEqualToString:@"GoDate"]){
        
      
       // self.selectKey = [NSMutableString stringWithFormat:@"StartDate"];
    }
    
    else if ([_selectKey isEqualToString:@"ProductThemeTag"]){
        
        self.selectKey = [NSMutableString stringWithFormat:@"ProductThemeTagID"];
    }
    
    else if ([_selectKey isEqualToString:@"Supplier"]){
        
    self.selectKey = [NSMutableString stringWithFormat:@"SupplierId"];
    }
    
    else if ([_selectKey isEqualToString:@"CruiseShipCompany"]){
        
        self.selectKey = [NSMutableString stringWithFormat:@"CruiseShipCompanyID"];
    }

}


-(void)back
{
   // [self.delegate passKey:@"" andValue:nil andSelectIndexPath:nil andSelectValue:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSArray *)dataArr1
{
    NSLog(@"选择列表的数据是%@----",_conditionDic);
    if (_dataArr1 == nil) {
        NSMutableArray *arr = [NSMutableArray array];
        NSArray *keys = [self.conditionDic allKeys];
        
        NSString *firstKey = [keys objectAtIndex:0];
        
        for(NSDictionary *dic in self.conditionDic[firstKey] ){
            [arr addObject:dic];
            }
        _dataArr1 = arr;
    }
        return _dataArr1;
}

-(NSMutableDictionary *)conditionSelectDiction
{
   // if (_conditionSelectDiction == nil) {
   
        self.conditionSelectDiction = [NSMutableDictionary dictionary];
        
        _conditionSelectDiction = [[WriteFileManager WMreadData:@"conditionSelect"] firstObject];
   // }
   
    return _conditionSelectDiction;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self dataArr1 ].count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
       
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, 280, 35)];
        
        NSLog(@"----------- dataArr1 is %@-----------",_dataArr1);
        
        label1.text = _dataArr1[indexPath.row][@"Text"];
        
       
       
        if ([_dataArr1[indexPath.row][@"Text"] isEqualToString:[self.conditionSelectDiction objectForKey:self.title]]) {
          
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        }else{
        
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
       
        //  NSString *value = _dataArr1[indexPath.row][@"Value"];//选项的searchID;
        
        label1.font = [UIFont systemFontOfSize:13.0];
        
       [cell.contentView addSubview:label1];
        
    }
    
    return cell;
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
   [self.delegate passKey:_selectKey andValue:_passValue andSelectIndexPath:self.superViewSelectIndexPath andSelectValue:_selectValue];
    
    }


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keys = [self.conditionDic allKeys];
    self.selectKey  = [keys objectAtIndex:0];//条件返回的键名
    
    self.passValue = _dataArr1[indexPath.row][@"Value"];//取得的value
   
    self.selectValue = _dataArr1[indexPath.row][@"Text"];//取得的value的名称
   
    //储存选择的键值对，便于下次进入时显示
  //  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *title = self.title;
    [self.conditionSelectDiction setObject:_selectValue forKey:title];
       [WriteFileManager WMsaveData:[NSMutableArray arrayWithObject:_conditionSelectDiction] name:@"conditionSelect"];
    
    //改变post的key名
    [self changeSelectKey];
      NSLog(@"---------------selectKey is %@ , passValue is %@ , selectValue is %@--------",_selectKey,_passValue,_selectValue);
//    [self.delegate passKey:key andValue:value andSelectIndexPath:self.superViewSelectIndexPath andSelectValue:selectValue];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
