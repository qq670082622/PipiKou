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
@interface SearchProductViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,searchFootViewDelegate>
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

@end

@implementation SearchProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadHotWordDataSource];
    [self loadHistoryDataSource];
    
  
    SearchFootView *foot = [SearchFootView footView];
    foot.delegate = self;
    self.table.tableFooterView = foot;
    self.table.tableFooterView.hidden = YES;
    
   }


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
    NSMutableArray *searchArr = [WriteFileManager WMreadData:@"searchHistory"];
    self.tableDataArr = searchArr;
    
}

#pragma -mark footViewDelegate
-(void)searchFootViewDidClickedLoadBtn:(SearchFootView *)footView
{
    [self.tableDataArr removeAllObjects];
    [WriteFileManager WMsaveData:_tableDataArr name:@"searchHistory"];
    [self.table reloadData];
    self.table.tableFooterView.hidden = YES;
    [self.inputView setText:@""];
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
        [self.navigationController pushViewController:list animated:YES];
    }
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
    }
    
    return cell;
}


-(void)viewWillDisappear:(BOOL)animated
{
[super viewWillDisappear:animated];
    [self.delegate passSearchKeyFromSearchVC:self.inputView.text];
    
}
- (IBAction)search:(id)sender {
    
    [self.tableDataArr addObject:self.inputView.text];
    [WriteFileManager WMsaveData:_tableDataArr name:@"searchHistory"];
    
    
    ProductList *list = [[ProductList alloc] init];
    list.pushedSearchK = self.inputView.text;
    self.table.tableFooterView.hidden = NO;
    
    [self.navigationController pushViewController:list animated:YES];
}

- (IBAction)clearinPutView:(id)sender {
    self.inputView.text = @"";
    [self.inputView resignFirstResponder];
    
   
}

-(IBAction)hotWordSearch:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.inputView.text = btn.currentTitle;
    ProductList *list = [[ProductList alloc] init];
    list.pushedSearchK = self.inputView.text;
   
    [self.navigationController pushViewController:list animated:YES];
   
}
@end
