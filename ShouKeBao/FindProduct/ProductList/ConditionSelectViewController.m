//
//  ConditionSelectViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ConditionSelectViewController.h"

@interface ConditionSelectViewController ()
@property (nonatomic,copy)NSMutableString *passValue;
@property (nonatomic,copy)NSMutableString *selectKey;
@property (nonatomic,copy)NSMutableString *selectValue;
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
    self.selectKey  = [keys objectAtIndex:0];//条件名称
    
    self.passValue = _dataArr1[indexPath.row][@"Value"];//取得的value
   
    self.selectValue = _dataArr1[indexPath.row][@"Text"];//取得的value的名称
  
    [self changeSelectKey];
    
    NSLog(@"---------------selectKey is %@ , passValue is %@ , selectValue is %@--------",_selectKey,_passValue,_selectValue);
//    [self.delegate passKey:key andValue:value andSelectIndexPath:self.superViewSelectIndexPath andSelectValue:selectValue];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
