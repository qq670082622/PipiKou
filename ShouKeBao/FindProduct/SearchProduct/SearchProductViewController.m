//
//  SearchProductViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/26.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SearchProductViewController.h"
#import "IWHttpTool.h"
#import "WMAnimations.h"
#import "ProductList.h"
#import "WriteFileManager.h"
#import "SearchFootView.h"
#import <QuartzCore/QuartzCore.h>
#import "MJRefresh.h"
#import "NSArray+QD.h"
#import "Lotuseed.h"
#import "SubstationParttern.h"
@interface SearchProductViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (strong,nonatomic)NSMutableArray *hotSearchWord;
@property(strong,nonatomic)NSMutableArray *tableDataArr;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *subView;
//@property (weak,nonatomic) UIView *footView;

@end

@implementation SearchProductViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"产品搜索";
    
    [self loadHotWordDataSource];
    

    
   [self.inputView becomeFirstResponder];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
    if (self.tableDataArr.count>0) {
        self.table.tableFooterView.hidden = NO;
    }else if (self.tableDataArr.count== 0){
        self.table.tableFooterView.hidden = YES;
    }
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
//   
//    [self.gestureView addGestureRecognizer:tap];
  
 }

//-(void)hideKeyBoard
//{
//    [self.inputView resignFirstResponder];
//}

-(void)back
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [Lotuseed onPageViewBegin:@"searchProduct"];
    [self.table addFooterWithTarget:self action:@selector(pullTable)];
    //设置文字
    self.table.footerPullToRefreshText = @"上拉刷新";
    self.table.footerRefreshingText = @"正在刷新";
    [self.table footerBeginRefreshing];
    [self loadHistoryDataSource];
        [self.table footerEndRefreshing];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [Lotuseed onPageViewEnd:@"searchProduct"];
     [self.delegate passSearchKeyFromSearchVC:self.inputView.text];
}

-(void)pullTable
{
    self.table.contentOffset = CGPointMake(0, 200);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self search];
    [self.inputView resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadHotWordDataSource
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@10 forKey:@"SubStation"];
    [IWHttpTool WMpostWithURL:@"/Product/GetHotSearchKey" params:dic success:^(id json) {
        NSLog(@"-------searchWord is json %@---------",json);
        if ([json[@"HotSearchKey"] count]>0) {
             self.hotSearchWord = json[@"HotSearchKey"];
            }
        [self setBtnText];
        NSLog(@"hotSearchKeyWord is%@",_hotSearchWord);
    } failure:^(NSError *error) {
        NSLog(@"searchWord 请求失败 原因：%@",error);
    }];

}


-(void)setBtnText
{
    
    [self.btn1 setTitle:_hotSearchWord[0] forState:UIControlStateNormal];
      [self.btn2 setTitle:_hotSearchWord[1] forState:UIControlStateNormal];
      [self.btn3 setTitle:_hotSearchWord[2] forState:UIControlStateNormal];
      [self.btn4 setTitle:_hotSearchWord[3] forState:UIControlStateNormal];
      [self.btn5 setTitle:_hotSearchWord[4] forState:UIControlStateNormal];
      [self.btn6 setTitle:_hotSearchWord[5] forState:UIControlStateNormal];
        

}



-(NSMutableArray *)hotSearchWord
{
    if (_hotSearchWord == nil) {
        
        _hotSearchWord = [NSMutableArray array];
    }
    return _hotSearchWord;
}


-(NSMutableArray *)tableDataArr
{

    if (_tableDataArr == nil) {
        self.tableDataArr = [NSMutableArray array];
        
    }
    return _tableDataArr;
}


- (void)loadHistoryDataSource
{
    self.tableDataArr = [WriteFileManager WMreadData:@"searchHistory"];

    [self.table reloadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.inputView resignFirstResponder];
}


#pragma -mark footViewDelegate
-(void)searchFootViewDidClickedLoadBtn:(SearchFootView *)footView
{
    [self.tableDataArr removeAllObjects];
   [WriteFileManager WMsaveData:self.tableDataArr name:@"searchHistory"];
    [self.table reloadData];
    self.table.tableFooterView.hidden = YES;
    [self.inputView setText:@""];
}


-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 37;
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, 37)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = foot.frame;
    [btn setTitle:@"清除历史纪录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15] ];
    [btn addTarget:self action:@selector(searchFootViewDidClickedLoadBtn:) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:btn];
    self.table.tableFooterView = foot;
    foot.hidden = YES;
    return foot;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableDataArr) {
       
        return self.tableDataArr.count;
    }
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
           NSLog(@"table 被点击");
      
    NSMutableString *selectHistoryKey = _tableDataArr[indexPath.row];
    if (selectHistoryKey) {
        self.inputView.text = selectHistoryKey;
        ProductList *list = [[ProductList alloc] init];
        list.pushedSearchK = self.inputView.text;
        self.table.tableFooterView.hidden = NO;
        //self.footView.hidden = NO;
        [self.navigationController pushViewController:list animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"historyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (_tableDataArr) {
    cell.textLabel.text = _tableDataArr[indexPath.row ];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        cell.textLabel.textColor = [UIColor grayColor];
        
        self.table.tableFooterView.hidden = NO;
    }else if (!_tableDataArr){
         self.table.tableFooterView.hidden = YES;
    }
    
    return cell;
}





- (IBAction)search
{
   
    if (self.inputView.text.length>=1 && ![self.inputView.text hasPrefix:@" "]) {
        if (![self.tableDataArr containsObject:self.inputView.text]) {
            [self.tableDataArr addObject:self.inputView.text];
            
            if (self.tableDataArr.count > 6) {
                [self.tableDataArr removeObjectAtIndex:0];
            }
            
            
            [WriteFileManager WMsaveData:_tableDataArr name:@"searchHistory"];
            
            
        }
        
        ProductList *list = [[ProductList alloc] init];
        list.pushedSearchK = self.inputView.text;
        self.table.tableFooterView.hidden = NO;
        
        [self.navigationController pushViewController:list animated:YES];
    }else if (self.inputView.text.length<1 ){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的输入内容有误" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
//        [alert show];
        self.inputView.text = @"推荐";
        if (![self.tableDataArr containsObject:self.inputView.text]) {
            [self.tableDataArr addObject:self.inputView.text];
            
            if (self.tableDataArr.count > 6) {
                [self.tableDataArr removeObjectAtIndex:0];
            }
            
            
            [WriteFileManager WMsaveData:_tableDataArr name:@"searchHistory"];
            
            
        }
        
        ProductList *list = [[ProductList alloc] init];
        list.pushedSearchK = self.inputView.text;
        SubstationParttern *par = [SubstationParttern sharedStationName];
        [Lotuseed onEvent:@"searchKey" attributes:@{@"searchKey":self.inputView.text,@"stationName":par.stationName}];
        self.table.tableFooterView.hidden = NO;
        
        [self.navigationController pushViewController:list animated:YES];

    }else if ([self.inputView.text hasPrefix:@" "]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的输入内容有误" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
//        [alert show];
        self.inputView.text = @"推荐";
        if (![self.tableDataArr containsObject:self.inputView.text]) {
            [self.tableDataArr addObject:self.inputView.text];
            
            if (self.tableDataArr.count > 6) {
                [self.tableDataArr removeObjectAtIndex:0];
            }
            
        [WriteFileManager WMsaveData:_tableDataArr name:@"searchHistory"];
            
            }
        ProductList *list = [[ProductList alloc] init];
        list.pushedSearchK = self.inputView.text;
        self.table.tableFooterView.hidden = NO;
        
        [self.navigationController pushViewController:list animated:YES];
    }
   
}



- (IBAction)clearinPutView:(id)sender
{
    self.inputView.text = @"";
   
    [self.inputView resignFirstResponder];
    
    self.table.tableFooterView.hidden = NO;
    
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)hotWordSearch:(id)sender
{
   
    UIButton *btn = (UIButton *)sender;
    self.inputView.text = btn.currentTitle;
    [self search];
 
}
@end
