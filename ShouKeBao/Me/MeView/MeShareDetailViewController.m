//
//  MeShareDetailViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/10/22.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MeShareDetailViewController.h"
#import "MeShareDetailTableViewCell.h"
#import "MeShareChooseViewController.h"
#import "MeSearchViewController.h"
#import "SKSearckDisplayController.h"
#import "MeSearchView.h"
#import "SKSearchBar.h"
#import "WriteFileManager.h"
#import "MeShareDetailModel.h"
#import "IWHttpTool.h"
#import "MJRefresh.h"

#define searchHistoryPlaceholder @"订单号/产品名称/供应商名称"
#define VIEW_width self.view.frame.size.width
#define VIEW_height self.view.frame.size.height
#define gap 10
#define pageSize 10
@interface MeShareDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, transmitPopKeyWords, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong)UITableView *shareTableView;
@property (nonatomic, strong)NSMutableArray *shareDataArr;
@property (nonatomic, strong)UIView *chooseView;
@property (nonatomic, assign)BOOL shareFlag;
@property (nonatomic, assign)BOOL isRefresh;
@property (nonatomic, assign)NSInteger pageIndex;
@property (nonatomic, strong)NSString *totalNumber;
@property (nonatomic, strong)UIImageView *noProductView;
//搜索
@property (nonatomic, strong)SKSearchBar *searchBar;
@property (nonatomic, strong)SKSearckDisplayController *searchDisplay;
@property (nonatomic, copy)NSString *searchK;
@property (nonatomic, weak)UIView *sep2;
@property (nonatomic, strong)MeSearchView *meHistoryView;
//全部筛选button
@property (nonatomic, strong)UIButton *allButton;
@end

@implementation MeShareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"分享详情";
//    布局更换
//    [self setRightBarButton];
    
    [self.view addSubview:self.searchBar];
    [self.view sendSubviewToBack:self.searchBar];
    [self searchDisplay];
    [self.view addSubview:self.allButton];
    [self.view addSubview:self.shareTableView];
    [self.view addSubview:self.chooseView];
    [self.view addSubview:self.noProductView];
    [self freshPage];
    
}

#pragma mark - 各种初始化
- (SKSearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[SKSearchBar alloc] initWithFrame:CGRectMake(10, 0, VIEW_width-70, 40)];
        _searchBar.delegate = self;
        _searchBar.barStyle = UISearchBarStyleDefault;
        _searchBar.translucent = NO;
        _searchBar.placeholder = searchHistoryPlaceholder;
        _searchBar.barTintColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        
//        UIView *lineae = [[UIView alloc]initWithFrame:CGRectMake(0, 40, VIEW_width, 0.5)];
//        lineae.backgroundColor = [UIColor grayColor];
//        [self.view addSubview:lineae];
    }
    return _searchBar;
}
- (UIButton *)allButton{
    if (!_allButton) {
        _allButton = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_width-60, 0, 60, 40)];
        [_allButton setTitle:@"全部" forState:UIControlStateNormal];
        [_allButton setImage:[UIImage imageNamed:@"xiangxia"] forState:UIControlStateNormal];
        [_allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_allButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
        [_allButton setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
        [_allButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_allButton addTarget:self action:@selector(editBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allButton;
}

- (SKSearckDisplayController *)searchDisplay
{
    if (!_searchDisplay) {
        _searchDisplay = [[SKSearckDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchDisplay.delegate = self;
        _searchDisplay.searchResultsTableView.backgroundColor = [UIColor clearColor];
        _searchDisplay.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _searchDisplay;
}

- (UITableView *)shareTableView{
    if (!_shareTableView) {
        self.shareTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, VIEW_width, VIEW_height-64-40) style:UITableViewStylePlain];
        self.shareTableView.delegate = self;
        self.shareTableView.dataSource = self;
    }
    return _shareTableView;
}
-(NSMutableArray *)shareDataArr{
    if (_shareDataArr == nil) {
        self.shareDataArr = [NSMutableArray array];
    }
    return _shareDataArr;
}
-(UIImageView *)noProductView{
    if (!_noProductView) {
        _noProductView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEW_width, VIEW_height)];
        _noProductView.image = [UIImage imageNamed:@"content_null"];
        _noProductView.hidden = YES;
    }
    return _noProductView;
}
-(NSMutableArray *)conditionArr
{
    if (_conditionArr == nil) {
        _conditionArr = [NSMutableArray array];
    }
    return _conditionArr;
}
- (UIView *)chooseView{
    if (!_chooseView) {
        self.chooseView = [[UIView alloc]initWithFrame:CGRectMake(VIEW_width-150-gap, 2+40, 150, 150)];
        self.chooseView.layer.cornerRadius = 7;
//        self.chooseView.layer.masksToBounds = YES;//这行必须去掉
        self.chooseView.layer.shadowColor = [UIColor grayColor].CGColor;
        self.chooseView.layer.shadowOffset = CGSizeMake(10, 10);
        self.chooseView.layer.shadowOpacity = 1.0f;
        self.chooseView.layer.shadowRadius = 3.5;
        self.chooseView.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
        self.chooseView.hidden = YES;
        
        UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
        [searchBtn setTitle:@"时间排序" forState:UIControlStateNormal];
        [searchBtn setImage:[UIImage imageNamed:@"xiangxia"]forState:UIControlStateNormal];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 20, 5, 100)];
        [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 7, 5, 5)];
        [searchBtn addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView addSubview:searchBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 150, 0.5)];
        line.backgroundColor = [UIColor grayColor];
        [self.chooseView addSubview:line];
        
        
        UIButton *chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50, 150, 50)];
        [chooseBtn setTitle:@"产品流量次数" forState:UIControlStateNormal];
        [chooseBtn setImage:[UIImage imageNamed:@"xiangxia"]forState:UIControlStateNormal];
        chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [chooseBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [chooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 20, 5, 100)];
        [chooseBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 7, 5, 5)];
        [chooseBtn addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView addSubview:chooseBtn];
        
        UIButton *orderCountBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 150, 50)];
        [orderCountBtn setTitle:@"下单次数" forState:UIControlStateNormal];
        [orderCountBtn setImage:[UIImage imageNamed:@"xiangxia"]forState:UIControlStateNormal];
        orderCountBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [orderCountBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [orderCountBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 20, 5, 100)];
        [orderCountBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 7, 5, 5)];
        [orderCountBtn addTarget:self action:@selector(orderCountButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView addSubview:orderCountBtn];
        
    
    }
    return _chooseView;
}
#pragma mark - 刷新和分页
- (void)freshPage{
    [self.shareTableView addHeaderWithTarget:self action:@selector(headRefish)dateKey:nil];
    [self.shareTableView headerBeginRefreshing];
    [self.shareTableView addFooterWithTarget:self action:@selector(foodRefish)];
    self.shareTableView.alwaysBounceVertical = YES;
    self.shareTableView.headerPullToRefreshText = @"下拉刷新";
    self.shareTableView.headerRefreshingText = @"正在刷新中";
    self.shareTableView.footerPullToRefreshText = @"上拉刷新";
    self.shareTableView.footerRefreshingText = @"正在刷新";
    
}
-(void)headRefish{
    self.isRefresh = YES;
    self.pageIndex = 1;
    [self loadSharePageData];
}
- (void)foodRefish{
    self.isRefresh = NO;
    self.pageIndex++;
    if (self.pageIndex  > [self getTotalPage]) {
        [self.shareTableView footerEndRefreshing];
    }else{
        [self loadSharePageData];
    }
}
- (NSInteger)getTotalPage{
    NSInteger cos = [self.totalNumber integerValue]%pageSize;
    if (cos == 0) {
        return [self.totalNumber integerValue]/pageSize;
    }else{
        return [self.totalNumber integerValue]/pageSize + 1;
    }
}


#pragma mark - UITableView - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeShareDetailTableViewCell *cell = [MeShareDetailTableViewCell cellWithTableView:tableView];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - 导航栏上布局及各种点击方法
- (void)setRightBarButton{
    UIButton *searchChooseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    searchChooseBtn.frame = CGRectMake(0, 0, 21, 7);
    [searchChooseBtn setBackgroundImage:[UIImage imageNamed:@"gengduoann"] forState:UIControlStateNormal];
    [searchChooseBtn addTarget:self action:@selector(editBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:searchChooseBtn];
    self.navigationItem.rightBarButtonItem = barItem;
}
- (void)editBarButtonAction{
    if (self.shareFlag) {
        self.chooseView.hidden = YES;
    }else{
        self.chooseView.hidden = NO;
    }
    self.shareFlag = !self.shareFlag;
    
}

- (void)searchButtonAction:(UIButton *)button{
    MeSearchViewController *meSearchVC = [[MeSearchViewController alloc]init];
    self.chooseView.hidden = YES;
    self.shareFlag = NO;
    meSearchVC.title = @"产品搜索";
    [self.navigationController pushViewController:meSearchVC animated:YES];
    
}
- (void)chooseButtonAction:(UIButton *)button{
    MeShareChooseViewController *meShareChooseVC = [[MeShareChooseViewController alloc]init];
    self.chooseView.hidden = YES;
    self.shareFlag = NO;
    [self.navigationController pushViewController:meShareChooseVC animated:YES];
}
- (void)orderCountButtonAction:(UIButton *)button{
    
}
#pragma mark - 数据请求
- (void)loadSharePageData{
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:[NSString stringWithFormat:@"%ld", self.pageIndex] forKey:@"PageIndex"];
//    [dic setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"PageSize"];
////    [dic setObject:_popKeyWords forKey:@"SearchKey"];
//    
//
//    [IWHttpTool WMpostWithURL:@"/Product/GetProductShareList" params:dic success:^(id json) {
//    NSLog(@"json = %@------------]",json);
//        NSArray *arr = json[@"ProductDTO"];
//        [self.shareDataArr removeAllObjects];
//        NSLog(@"arr = %@", arr);
//        if (arr.count==0) {
//            self.noProductView.hidden = NO;
//    
//        }else if (arr.count>0){
//            self.noProductView.hidden = YES;
//            for (NSDictionary *dic in json[@"ProductList"]) {
//                MeShareDetailModel *modal = [MeShareDetailModel shareDetailWithDict:dic];
//                [self.shareDataArr addObject:modal];
//            }
//            self.totalNumber = json[@"TotalCount"];
//        }
//        
//        NSMutableArray *conArr = [NSMutableArray array];
//               for(NSDictionary *dic in json[@"ProductConditionList"] ){
//            [conArr addObject:dic];
//        }
    
        
//        self.siftDic = json[@"ProductCondition"];
//        [self.conditionArr removeAllObjects];
//        self.conditionArr = conArr;//装载筛选条件数据
//        ShaiXuan.conditionArr =self.conditionArr;
//        NSLog(@"_+++%@",ShaiXuan.conditionArr);
//        NSString *page = [NSString stringWithFormat:@"%@",_page];
//        self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];
        
//        if (_shareDataArr != nil) {
            [self.shareTableView reloadData];
            [self.shareTableView headerEndRefreshing];
            [self.shareTableView footerEndRefreshing];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"-------产品搜索请求失败 error is%@----------",error);
//    }];
}

#pragma mark - 搜索界面协议传值方法
- (void)transmitPopKeyWord:(NSString *)keyWords{
    self.popKeyWords = keyWords;
    [self freshPage];
}

#pragma mark - UISearchBar的delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
// 这个方法里面纯粹调样式
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    for (UIView *searchbuttons in [[searchBar.subviews objectAtIndex:0] subviews])
    {if ([searchbuttons isKindOfClass:[UIButton class]]){
        UIButton *cancelButton = (UIButton *)searchbuttons;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"取消"];
        NSMutableDictionary *muta = [NSMutableDictionary dictionary];
        [muta setObject:[UIColor colorWithRed:68/255.0 green:122/255.0 blue:208/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
        [muta setObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
        [attr addAttributes:muta range:NSMakeRange(0, 2)];
        [cancelButton setAttributedTitle:attr forState:UIControlStateNormal];
        break;
    }else{
        UITextField *textField = (UITextField *)searchbuttons;
        // 边界线
        CGFloat sepX = CGRectGetMaxX(textField.frame);
        UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(sepX, 25, 0.5, 34)];
        sep2.backgroundColor = [UIColor lightGrayColor];
        sep2.alpha = 0.3;
        [self.view.window addSubview:sep2];
        self.sep2 = sep2;
    }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *trimStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.searchK = trimStr;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchDisplayController setActive:NO animated:YES];
    
    if (self.searchK.length) {
        [searchBar endEditing:YES];
        NSMutableArray *tmp = [NSMutableArray array];
        // 先取出原来的记录
        NSArray *arr = [WriteFileManager readFielWithName:@"MeShareSearch"];
        [tmp addObjectsFromArray:arr];
        
        // 再加上新的搜索记录
        [tmp addObject:self.searchK];
        
        // 并保存
        [WriteFileManager saveFileWithArray:tmp Name:@"MeShareSearch"];
        //        [self searchLoadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UISearchDisplayDelegate
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
//    self.allButton.hidden = YES;
    // 纯粹调节样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.searchBar.barTintColor = [UIColor whiteColor];
    // 历史记录的界面
    MeSearchView *searchView = [[MeSearchView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height + 49)];
    searchView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    [self.view.window addSubview:searchView];
    self.meHistoryView = searchView;
    self.searchBar.placeholder = searchHistoryPlaceholder;
    self.searchBar.text = self.searchK;
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    [self.sep2 removeFromSuperview];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.searchBar.barTintColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    [self.meHistoryView removeFromSuperview];
    [self.sep2 removeFromSuperview];
    if (self.searchK.length){
        self.searchBar.placeholder = self.searchK;
        NSLog(@"self.searchK = %@", self.searchK);
    }else{
        self.searchBar.placeholder = searchHistoryPlaceholder;
    }
}
- (void)MeShareSearch:(NSNotification *)noty
{
    self.searchK = noty.userInfo[@"searchKey"];
    [self.searchDisplayController setActive:NO animated:YES];
    [self loadSharePageData];
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
    tableView.hidden = YES;
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
