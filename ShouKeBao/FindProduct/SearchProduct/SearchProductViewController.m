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
@interface SearchProductViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
    [self loadHotWordDataSource];
    [self loadHistoryDataSource];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
   // [self setBtnText];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.subView.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:1 andNeedShadow:YES];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.table.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:1 andNeedShadow:YES];
}
-(void)hideKeyBoard
{
    [self.inputView resignFirstResponder];
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
-(void)loadHistoryDataSource
{

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"historyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataArr.count;
}

-(void)viewWillDisappear:(BOOL)animated
{
[super viewWillDisappear:animated];
    [self.delegate passSearchKeyFromSearchVC:self.inputView.text];
    
}
- (IBAction)search:(id)sender {
    ProductList *list = [[ProductList alloc] init];
    list.pushedSearchK = self.inputView.text;
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
