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
#import "ButtonAndImageView.h"

#define searchHistoryPlaceholder @"订单号/产品名称/供应商名称"
#define VIEW_width self.view.frame.size.width
#define VIEW_height self.view.frame.size.height
#define gap 10
#define pageSize 10
@interface MeShareDetailViewController ()<UITableViewDataSource, UITableViewDelegate, /*UISearchBarDelegate, UISearchDisplayDelegate, */transmitPopKeyWords, backChanpinDetail>

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
//@property (nonatomic, strong)SKSearckDisplayController *searchDisplay;
@property (nonatomic, strong)UIButton *searchButton;
@property (nonatomic, strong)UIView *backGroundView;
@property (nonatomic, copy)NSString *searchK;
@property (nonatomic, weak)UIView *sep2;
@property (nonatomic, strong)MeSearchView *meHistoryView;
//全部筛选button
@property (nonatomic, strong)UIButton *allButton;

@property (nonatomic, assign)int timeFlag;
@property (nonatomic, assign)int flowFlag;
@property (nonatomic, assign)int orderFlag;
@property (nonatomic, assign)int SourtType;
@end

@implementation MeShareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"分享详情";
    self.pageIndex = 1;
    self.SourtType = 1;
//    布局更换
//    [self setRightBarButton];
    [self.view addSubview:self.backGroundView];
    [self.backGroundView addSubview:self.searchButton];
    [self.backGroundView addSubview:self.allButton];
//    [self.view sendSubviewToBack:self.searchBar];
//    [self searchDisplay];
    [self.view addSubview:self.allButton];
    [self.view addSubview:self.shareTableView];
    [self.view addSubview:self.chooseView];
    [self.view addSubview:self.noProductView];
    [self freshPage];
//    [self loadSharePageData];
    
}

#pragma mark - 各种初始化
- (UIView *)backGroundView{
    if (!_backGroundView) {
        self.backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_width, 40)];
        self.backGroundView.backgroundColor = [UIColor colorWithRed:(226.0/255.0) green:(229.0/255.0) blue:(230.0/255.0) alpha:1];
    }
    return _backGroundView;
}

- (UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(10, 5, VIEW_width-70, 30);
        [_searchButton setBackgroundColor:[UIColor whiteColor]];
        _searchButton.layer.cornerRadius = 5;
        [_searchButton setImage:[UIImage imageNamed:@"fdjBtn"] forState:UIControlStateNormal];
        [_searchButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_searchButton setTitle:searchHistoryPlaceholder forState:UIControlStateNormal];
        
        [_searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _searchButton;
}

- (UIButton *)allButton{
    if (!_allButton) {
        _allButton = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_width-60, 0, 60, 40)];
        [_allButton setTitle:@"排序" forState:UIControlStateNormal];
        [_allButton setImage:[UIImage imageNamed:@"xiangxia"] forState:UIControlStateNormal];
        [_allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_allButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
        [_allButton setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
        [_allButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_allButton addTarget:self action:@selector(editBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allButton;
}

- (UITableView *)shareTableView{
    if (!_shareTableView) {
        self.shareTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, VIEW_width, VIEW_height-64-40) style:UITableViewStylePlain];
        self.shareTableView.delegate = self;
        self.shareTableView.dataSource = self;
        self.shareTableView.tableFooterView = [[UIView alloc]init];
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
        _noProductView = [[UIImageView alloc]initWithFrame:CGRectMake(70, 80, VIEW_width-140, VIEW_height-300)];
        _noProductView.image = [UIImage imageNamed:@"content_null"];
        _noProductView.hidden = YES;
        
        UIGraphicsBeginImageContextWithOptions(_noProductView.image.size, NO, 0.0);
        [_noProductView.image drawAtPoint:CGPointZero];
        NSString *text = @"咦,您还没有分享噢！";
        NSDictionary *dict = @{
                               NSFontAttributeName:[UIFont systemFontOfSize:13],
                               NSForegroundColorAttributeName:[UIColor grayColor]
                               };
        [text drawAtPoint:CGPointMake(50, 190) withAttributes:dict];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭上下文
        UIGraphicsEndImageContext(); 
        _noProductView.image = newImage;
        // 把图片转换成png格式的二进制数据 
//        NSData *data = UIImagePNGRepresentation(newImage);
        
        
        
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
        self.chooseView = [[UIView alloc]initWithFrame:CGRectMake(VIEW_width-120-gap, 2+40, 120, 120)];
        self.chooseView.layer.cornerRadius = 7;
//        self.chooseView.layer.masksToBounds = YES;//这行必须去掉
        self.chooseView.layer.shadowColor = [UIColor grayColor].CGColor;
        self.chooseView.layer.shadowOffset = CGSizeMake(5, 5);
        self.chooseView.layer.shadowOpacity = 1.0f;
        self.chooseView.layer.shadowRadius = 3.5;
        self.chooseView.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
        self.chooseView.hidden = YES;
        
        UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
        [searchBtn setTitle:@"时间排序" forState:UIControlStateNormal];
        [searchBtn setImage:[UIImage imageNamed:@"sort"]forState:UIControlStateNormal];
        
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 5, 25)];
        [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 5, 10)];
        [searchBtn addTarget:self action:@selector(timeOrderAction) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView addSubview:searchBtn];

        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 120, 0.5)];
        line1.backgroundColor = [UIColor grayColor];
        [self.chooseView addSubview:line1];
        
        
        UIButton *chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, 120, 40)];
        [chooseBtn setTitle:@"产品流量次数" forState:UIControlStateNormal];
        [chooseBtn setImage:[UIImage imageNamed:@"sort"]forState:UIControlStateNormal];
        chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [chooseBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [chooseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 10)];
        [chooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 5, 0)];
       
        [chooseBtn addTarget:self action:@selector(flowOrderAction) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView addSubview:chooseBtn];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 80, 120, 0.5)];
        line2.backgroundColor = [UIColor grayColor];
        [self.chooseView addSubview:line2];
        
        UIButton *orderCountBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 80, 100, 40)];
        [orderCountBtn setTitle:@"下单次数" forState:UIControlStateNormal];
        [orderCountBtn setImage:[UIImage imageNamed:@"sort"]forState:UIControlStateNormal];
        orderCountBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [orderCountBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [orderCountBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 5, 10)];
        [orderCountBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 10)];
       
        [orderCountBtn addTarget:self action:@selector(orderOrderAction) forControlEvents:UIControlEventTouchUpInside];
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
    return self.shareDataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeShareDetailTableViewCell *cell = [MeShareDetailTableViewCell cellWithTableView:tableView];
    cell.shareModel = self.shareDataArr[indexPath.row];
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
//    if (self.shareFlag) {
//        self.chooseView.hidden = YES;
//    }else{
        self.chooseView.hidden = NO;
//    }
//    self.shareFlag = !self.shareFlag;
    
}

- (void)searchButtonAction:(UIButton *)button{
//    self.chanpingView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, VIEW_width, VIEW_height+64+49)];
//    self.navigationController.navigationBarHidden = YES;
    MeSearchViewController *meSearchVC = [[MeSearchViewController alloc]init];
    self.chooseView.hidden = YES;
    self.shareFlag = NO;
    meSearchVC.title = @"产品搜索";
//    self.chanpingView = meSearchVC.view;
//    meSearchVC.delegate = self;
//    [self.view addSubview:self.chanpingView];
    [self.navigationController pushViewController:meSearchVC animated:NO];
    
}
- (void)backChanPinDetail{
    self.chanpingView.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
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
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSString stringWithFormat:@"%d", self.pageIndex] forKey:@"PageIndex"];
    [dic setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"PageSize"];
    NSString *type = [NSString stringWithFormat:@"%d", self.SourtType];
    
    [dic setValue:type forKey:@"SourtType"];
    [dic setObject:@" " forKey:@"SearchKey"];
    
    [IWHttpTool WMpostWithURL:@"/Product/GetProductShareList" params:dic success:^(id json) {
    NSLog(@"json = %@------------]",json);
        
        NSArray *arr = json[@"ProductShareList"];
        NSLog(@"arr.count = %ld", arr.count);
        
        [self.shareDataArr removeAllObjects];
        if (arr.count==0) {
            self.noProductView.hidden = NO;
    
        }else if (arr.count>0){
            self.noProductView.hidden = YES;
            for (NSDictionary *dic in json[@"ProductShareList"]) {
                MeShareDetailModel *modal = [MeShareDetailModel shareDetailWithDict:dic];
                [self.shareDataArr addObject:modal];
            }
            self.totalNumber = json[@"TotalCount"];
        }
        
     
    
        
//        self.siftDic = json[@"ProductCondition"];
//        [self.conditionArr removeAllObjects];
//        self.conditionArr = conArr;//装载筛选条件数据
//        ShaiXuan.conditionArr =self.conditionArr;
//        NSLog(@"_+++%@",ShaiXuan.conditionArr);
//        NSString *page = [NSString stringWithFormat:@"%@",_page];
//        self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];
        
        if (_shareDataArr != nil) {
            [self.shareTableView reloadData];
            [self.shareTableView headerEndRefreshing];
            [self.shareTableView footerEndRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"-------产品搜索请求失败 error is%@----------",error);
    }];
}

#pragma mark - 搜索界面协议传值方法
- (void)transmitPopKeyWord:(NSString *)keyWords{
    self.popKeyWords = keyWords;
    [self freshPage];
}

#pragma mark - UISearchBar的delegate
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    [searchBar setShowsCancelButton:YES animated:YES];
//    
//    return YES;
//}
//// 这个方法里面纯粹调样式
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    self.allButton.hidden = YES;
//    for (UIView *searchbuttons in [[searchBar.subviews objectAtIndex:0] subviews]){
//        if ([searchbuttons isKindOfClass:[UIButton class]]){
//        UIButton *cancelButton = (UIButton *)searchbuttons;
//        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"取消"];
//        NSMutableDictionary *muta = [NSMutableDictionary dictionary];
//        [muta setObject:[UIColor colorWithRed:68/255.0 green:122/255.0 blue:208/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
//        [muta setObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
//        [attr addAttributes:muta range:NSMakeRange(0, 2)];
//        [cancelButton setAttributedTitle:attr forState:UIControlStateNormal];
//        break;
//    }else{
//        UITextField *textField = (UITextField *)searchbuttons;
//        // 边界线
//        CGFloat sepX = CGRectGetMaxX(textField.frame);
//        UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(sepX, 25, 0.5, 34)];
//        sep2.backgroundColor = [UIColor lightGrayColor];
//        sep2.alpha = 0.3;
//        [self.view.window addSubview:sep2];
//        self.sep2 = sep2;
//    }
//    }
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    NSString *trimStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    self.searchK = trimStr;
//}
//
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
//    return YES;
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [self.searchDisplayController setActive:NO animated:YES];
//    
//    if (self.searchK.length) {
//        [searchBar endEditing:YES];
//        NSMutableArray *tmp = [NSMutableArray array];
//        // 先取出原来的记录
//        NSArray *arr = [WriteFileManager readFielWithName:@"MeShareSearch"];
//        [tmp addObjectsFromArray:arr];
//        
//        // 再加上新的搜索记录
//        [tmp addObject:self.searchK];
//        
//        // 并保存
//        [WriteFileManager saveFileWithArray:tmp Name:@"MeShareSearch"];
//        //        [self searchLoadData];
//    }
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//    [searchBar setShowsCancelButton:NO animated:YES];
//}
//




//#pragma mark - UISearchDisplayDelegate
//-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
//{
//    // 纯粹调节样式
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    self.searchBar.barTintColor = [UIColor whiteColor];
//    // 历史记录的界面
//    MeSearchView *searchView = [[MeSearchView alloc] initWithFrame:CGRectMake(0, 64, VIEW_width, VIEW_height + 49)];
//    searchView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
//    [self.view.window addSubview:searchView];
//    self.meHistoryView = searchView;
//    self.searchBar.placeholder = searchHistoryPlaceholder;
//    self.searchBar.text = self.searchK;
//    
//}
//
//-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
// 
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    self.searchBar.barTintColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
//    [self.meHistoryView removeFromSuperview];
//    [self.sep2 removeFromSuperview];
//    if (self.searchK.length){
//        self.searchBar.placeholder = self.searchK;
//        NSLog(@"self.searchK = %@", self.searchK);
//    }else{
//        self.searchBar.placeholder = searchHistoryPlaceholder;
//    }
//    self.allButton.hidden = NO;
////    self.searchBar.frame = CGRectMake(10, 0, VIEW_width-70, 40);
//}
//- (void)MeShareSearch:(NSNotification *)noty
//{
//    self.searchK = noty.userInfo[@"searchKey"];
//    [self.searchDisplayController setActive:NO animated:YES];
//    [self loadSharePageData];
//}
//- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
//    tableView.hidden = YES;
//}

#pragma mark - 排序方法
- (void)timeOrderAction{
    if (self.timeFlag) {
        self.SourtType = 1;
    }else{
        self.SourtType = 2;
    }
    self.timeFlag = !self.timeFlag;
    self.chooseView.hidden = YES;
    [self freshPage];
//    NSLog(@",,,,,, time");
}
- (void)flowOrderAction{
    if (self.flowFlag) {
        self.SourtType = 1;
    }else{
        self.SourtType = 2;
    }
    self.flowFlag = !self.flowFlag;
    self.chooseView.hidden = YES;
    [self freshPage];
}
- (void)orderOrderAction{
    if (self.orderFlag) {
        self.SourtType = 1;
    }else{
        self.SourtType = 2;
    }
    self.orderFlag = !self.orderFlag;
    self.chooseView.hidden = YES;
    [self freshPage];
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
