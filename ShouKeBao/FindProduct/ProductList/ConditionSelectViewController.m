//
//  ConditionSelectViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ConditionSelectViewController.h"
#import "WriteFileManager.h"
#import "MobClick.h"
#import "FindProductNew.h"
@interface ConditionSelectViewController ()
@property (nonatomic,copy)NSMutableString *passValue;
@property (nonatomic,copy)NSMutableString *selectKey;
@property (nonatomic,copy)NSMutableString *selectValue;
@property (nonatomic,strong) NSMutableArray *conditionSelectArr;//(arr内为一个字典)
@property (nonatomic,assign) BOOL rowHeight70;
@property (weak, nonatomic) IBOutlet UIImageView *noConditionImg;


@end

@implementation ConditionSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self loadDataSource];
   
    self.navigationController.title = self.conditionTitle;
//    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
//    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
//    
//    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//    
    self.navigationItem.leftBarButtonItem =leftItem;
 
    self.table.tableFooterView = [[UIView alloc] init];
    
   // NSLog(@"------------当前页面选择的条件为%@--------------------------",[[self.conditionSelectArr firstObject] objectForKey:self.title]);
    [self.conditionSelectArr removeAllObjects];
    self.conditionSelectArr = [NSMutableArray arrayWithArray:[WriteFileManager WMreadData:@"conditionSelect"]];
    
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
    
    }else if ([_selectKey isEqualToString:@"destination"]){
       
        self.selectKey = [NSMutableString stringWithFormat:@"SearchKey"];
    }

}


-(void)back
{
   // [self.delegate passKey:@"" andValue:nil andSelectIndexPath:nil andSelectValue:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSMutableArray *)dataArr1
{
    if (_dataArr1 == nil) {
        self.dataArr1 = [NSMutableArray array];
    }
    return _dataArr1;
     }

-(void)loadDataSource
{
    NSLog(@"------------选择列表的数据是%@----",_conditionDic);
           NSMutableArray *arr = [NSMutableArray array];
        NSArray *keys = [self.conditionDic allKeys];
        
        NSString *firstKey = [keys objectAtIndex:0];
        if ([firstKey isEqualToString:@"Supplier"]) {
            self.table.rowHeight = 70;
            self.rowHeight70 = YES;
            
        }
        // NSLog(@"------------firstKey is %@-----------",firstKey);
        for(NSDictionary *dic in self.conditionDic[firstKey] ){
                               [arr addObject:dic];
            
        }
    [self.dataArr1 removeAllObjects];
         _dataArr1 = arr;
    [self.table reloadData];
    if (_dataArr1.count == 0 ) {
        self.noConditionImg.hidden = NO;
    }
        //NSLog(@"arr count is %lu",[arr count]);
    
    // NSLog(@"------------arr is %@ count is %lu-----------",_dataArr1,(unsigned long)[_dataArr1 count]);

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

    //static NSString *cellID = [NSString stringWithFormat:@"conditionCell%ld",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"conditionCell%ld",(long)indexPath.row]];
    
    if (cell == nil) {
       
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"conditionCell%ld",(long)indexPath.row]];
        //labelText
        UILabel *label1 = [[UILabel alloc] init];
        CGFloat wid = self.view.frame.size.width*(32/28);
        
        if (self.rowHeight70 == YES) {
            
            label1.frame =  CGRectMake(15, 5, wid, 60);
            
        }else{
            
            label1.frame = CGRectMake(15, 5, wid, 30);
        }
        
        label1.numberOfLines = 0;
        // NSLog(@"----------- dataArr1 is %@-----------",_dataArr1);
        
        label1.text = _dataArr1[indexPath.row][@"Text"];
        label1.font = [UIFont systemFontOfSize:13.0];
    [cell.contentView addSubview:label1];
    }
    
    
    
    //以选中标示
    NSLog(@"读取的arr is %@ 对比的箭名%@",_conditionSelectArr,[[_conditionSelectArr firstObject] objectForKey:self.title]);
    NSString *conditionStr = [[_conditionSelectArr firstObject] objectForKey:self.title];
    
    if (!conditionStr &&indexPath.row == 0) {
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
       // [[_conditionSelectArr firstObject] setObject:@"不限" forKey:self.title];
     
    }else if ([_dataArr1[indexPath.row][@"Text"] isEqualToString:[[_conditionSelectArr firstObject] objectForKey:self.title]] ) {
                  cell.accessoryType = UITableViewCellAccessoryCheckmark;

    }
return cell;
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"FindProductConditionSelectView"];
    
   [self.delegate passKey:_selectKey andValue:_passValue andSelectIndexPath:self.superViewSelectIndexPath andSelectValue:_selectValue];
    
    }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"FindProductConditionSelectView"];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keys = [self.conditionDic allKeys];
    self.selectKey  = [keys objectAtIndex:0];//条件返回的键名
    
    self.passValue = _dataArr1[indexPath.row][@"Value"];//取得的value
   
    self.selectValue = _dataArr1[indexPath.row][@"Text"];//取得的value的名称
   
    //储存选择的键值对，便于下次进入时显示
   
    NSString *title = self.title;
//    NSMutableArray *arr = [NSMutableArray arrayWithArray:[WriteFileManager WMreadData:@"conditionSelect"]];

    NSMutableDictionary *dicNew = [NSMutableDictionary dictionary];
         for(NSMutableDictionary *dic in self.conditionSelectArr){
        dicNew = dic;
    }
    [dicNew setObject:_selectValue forKey:title];
    [self.conditionSelectArr removeAllObjects];
    [self.conditionSelectArr addObject:dicNew];

   // NSLog(@"---------储存的选择的条件字典为%@---arr is %@----",dicNew,_conditionSelectArr);
   
       [WriteFileManager WMsaveData:_conditionSelectArr name:@"conditionSelect"];
    
    //改变post的key名
    [self changeSelectKey];
    //  NSLog(@"---------------selectKey is %@ , passValue is %@ , selectValue is %@--------",_selectKey,_passValue,_selectValue);

   // [self.table reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
