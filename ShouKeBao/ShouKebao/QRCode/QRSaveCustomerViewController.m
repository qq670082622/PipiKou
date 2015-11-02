//
//  QRSaveCustomerViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/20.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "QRSaveCustomerViewController.h"
#import "QRSaveToCustomerTableViewCell.h"
#import "MJRefresh.h"
#import "CustomModel.h"
#import "IWHttpTool.h"
#define pageSize 10

@interface QRSaveCustomerViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)NSMutableArray *arr;
@property (nonatomic, strong)NSMutableArray * customIDArray;
@property (nonatomic,assign)int pageIndex;
@property (nonatomic,assign) BOOL isRefresh;
@property (nonatomic,copy) NSString *totalNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewWhenIsNull;
@property (weak, nonatomic) IBOutlet UIView *ensureView;
- (IBAction)ensureButton:(id)sender;



@end

@implementation QRSaveCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"保存客户附件至";
    self.view.backgroundColor = [UIColor whiteColor];

    self.pageIndex = 1;
    [self.tableView setEditing:YES animated:YES];
    [self setTableViewDelegate:self.tableView];
    [self.view bringSubviewToFront:self.ensureView];
    
    
}
#pragma mark - 初始化
- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (NSMutableArray *)customIDArray{
    if (!_customIDArray) {
        _customIDArray = [NSMutableArray array];
    }
    return _customIDArray;
}

#pragma mark - tableView-delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    QRSaveToCustomerTableViewCell *cell = [QRSaveToCustomerTableViewCell cellWithTableView:tableView];
    CustomModel *model = [self.array objectAtIndex:indexPath.row];
    cell.model = model;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.customIDArray addObject:((CustomModel *)self.array[indexPath.row]).ID];
    self.ensureView.hidden = NO;
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.customIDArray removeObject:((CustomModel *)self.array[indexPath.row]).ID];
    if (self.customIDArray.count == 0) {
        self.ensureView.hidden = YES;
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return self.view.frame.size.height/8;
//}

#pragma mark - 刷新和分页
- (void)setTableViewDelegate:(UITableView*)tableView{
    //设置代理
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView addHeaderWithTarget:self action:@selector(headPull)dateKey:nil];
    [tableView headerBeginRefreshing];
    [tableView addFooterWithTarget:self action:@selector(foodPull)];
    tableView.headerPullToRefreshText = @"下拉刷新";
    tableView.headerRefreshingText = @"正在刷新中";
    tableView.footerPullToRefreshText = @"上拉刷新";
    tableView.footerRefreshingText = @"正在刷新";
    
}
-(void)headPull{
    self.isRefresh = YES;
    self.pageIndex = 1;
    [self loadCustomerData];
}
//  上啦加载
- (void)foodPull{
//    [self.imageViewWhenIsNull removeFromSuperview];
    self.isRefresh = NO;
    self.pageIndex++;
    if (self.pageIndex  > [self getTotalPage]) {
        [self.tableView footerEndRefreshing];
    }else{
        [self loadCustomerData];
    }
}

- (NSInteger)getTotalPage{
    NSInteger cos = [self.totalNumber integerValue] % pageSize;
    if (cos == 0) {
        return [self.totalNumber integerValue] / pageSize;
    }else{
        return [self.totalNumber integerValue] / pageSize + 1;
    }
}

- (void)loadCustomerData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%d", self.pageIndex] forKey:@"PageIndex"];
    [dic setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"PageSize"];

    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sortType = [accountDefaults stringForKey:@"sortType"];
    if (sortType) {
        [dic setObject:sortType forKey:@"sortType"];
    }else if (!sortType){
        [dic setObject:@"2" forKey:@"sortType"];
    }
    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomerList" params:dic success:^(id json) {
        
        if (self.isRefresh) {
            [self.array removeAllObjects];
        }
        self.totalNumber = json[@"TotalCount"];
            for(NSDictionary *dic in  json[@"CustomerList"]){
                CustomModel *model = [CustomModel modalWithDict:dic];
                [self.array addObject:model];
            [self.tableView reloadData];
            if (_array.count==0) {
                self.imageViewWhenIsNull.hidden = NO ;
            }else if (_array.count>0){
                self.imageViewWhenIsNull.hidden = YES ;
            } }
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
     
    }failure:^(NSError *error) {
        NSLog(@"-------接口请求失败%@------",error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ensureButton:(id)sender {

    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"保存中...";
    [hudView show:YES];
  
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:self.picArray forKey:@"PicUrls"];
    [postDic setObject:self.customIDArray forKey:@"CustomerIds"];

    [IWHttpTool WMpostWithURL:@"/Customer/AddPicToCustomer" params:postDic success:^(id json) {
        NSLog(@"json = %@", json);
        
        hudView.labelText = @"保存成功...";
        
        [hudView hide:YES afterDelay:0.4];

        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        NSLog(@"----保存图片失败 %@-----",error);
    }];
    
    
    
    
    
}
@end
