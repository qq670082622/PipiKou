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
#import "ProduceDetailViewController.h"


#define searchHistoryPlaceholder @"订单号/产品名称/供应商名称"
#define VIEW_width self.view.frame.size.width
#define VIEW_height self.view.frame.size.height
#define gap 10
#define pageSize 10
@interface MeShareDetailViewController ()<UITableViewDataSource, UITableViewDelegate, /*UISearchBarDelegate, UISearchDisplayDelegate, */transmitPopKeyWords, backChanpinDetail, searchBarText>

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
        _searchButton.frame = CGRectMake(10, 6, VIEW_width-70, 28);
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
        self.chooseView = [[UIView alloc]initWithFrame:CGRectMake(VIEW_width-120-gap, 2+40, 120, 80)];
        self.chooseView.layer.cornerRadius = 7;
//        self.chooseView.layer.masksToBounds = YES;//这行必须去掉
        self.chooseView.layer.shadowColor = [UIColor grayColor].CGColor;
        self.chooseView.layer.shadowOffset = CGSizeMake(5, 5);
        self.chooseView.layer.shadowOpacity = 1.0f;
        self.chooseView.layer.shadowRadius = 3.5;
        self.chooseView.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1];
        self.chooseView.hidden = YES;

    //************** 时间排序暂时住掉 ***************
        
//        UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
//        [searchBtn setTitle:@"时间排序" forState:UIControlStateNormal];
//        [searchBtn setImage:[UIImage imageNamed:@"sort"]forState:UIControlStateNormal];
//        
//        searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 5, 25)];
//        [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 5, 10)];
//        [searchBtn addTarget:self action:@selector(timeOrderAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.chooseView addSubview:searchBtn];
//
//        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 120, 0.5)];
//        line1.backgroundColor = [UIColor grayColor];
//        [self.chooseView addSubview:line1];
        
        
        UIButton *chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
//        UIButton *chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, 120, 40)];
        [chooseBtn setTitle:@"产品浏览次数" forState:UIControlStateNormal];
        [chooseBtn setImage:[UIImage imageNamed:@"sort"]forState:UIControlStateNormal];
        chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [chooseBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [chooseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 10)];
        [chooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 5, 0)];
       
        [chooseBtn addTarget:self action:@selector(flowOrderAction) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView addSubview:chooseBtn];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 120, 0.5)];
        line2.backgroundColor = [UIColor grayColor];
        [self.chooseView addSubview:line2];
        
        UIButton *orderCountBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, 100, 40)];
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
    
    [self.searchButton setTitle:searchHistoryPlaceholder forState:UIControlStateNormal];
    [_searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.isRefresh = YES;
    self.pageIndex = 1;
    if (!self.shareDataArr.count) {
        self.popKeyWords =@"";
    }
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
    MeShareDetailModel *model = _shareDataArr[indexPath.row];
    
    NSString *productUrl = model.LinkUrl;

    detail.produceUrl = productUrl;
    detail.shareInfo = model.ShareInfo;
    detail.productName = model.Name;
//    NSLog(@"%@---%@----%@", detail.shareInfo,detail.produceUrl,productName);
     [self.navigationController pushViewController:detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    MeSearchViewController *meSearchVC = [[MeSearchViewController alloc]init];
    self.chooseView.hidden = YES;
    self.shareFlag = NO;
    meSearchVC.transmitDelegate = self;
    meSearchVC.searchDelegate = self;
    
    meSearchVC.title = @"产品搜索";
    if (![self.popKeyWords isEqualToString:[NSString stringWithFormat:@"%@",  searchHistoryPlaceholder]]) {
        meSearchVC.detail_key = self.popKeyWords;
        NSLog(@"self.searchKKK = %@, %@", self.popKeyWords, meSearchVC.searchBar.placeholder);
    }
    [self.navigationController pushViewController:meSearchVC animated:NO];
    
}


- (void)chooseButtonAction:(UIButton *)button{
    MeShareChooseViewController *meShareChooseVC = [[MeShareChooseViewController alloc]init];
    self.chooseView.hidden = YES;
    self.shareFlag = NO;
    [self.navigationController pushViewController:meShareChooseVC animated:YES];
}

#pragma mark - 数据请求
- (void)loadSharePageData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSString stringWithFormat:@"%d", self.pageIndex] forKey:@"PageIndex"];
    [dic setObject:[NSString stringWithFormat:@"%d", pageSize] forKey:@"PageSize"];
    NSString *type = [NSString stringWithFormat:@"%d", self.SourtType];
    
    [dic setValue:type forKey:@"SourtType"];
    if (self.popKeyWords.length) {
        [dic setObject:self.popKeyWords forKey:@"SearchKey"];
    }else{
        [dic setObject:@" " forKey:@"SearchKey"];
    }
    
    [IWHttpTool WMpostWithURL:@"/Product/GetProductShareList" params:dic success:^(id json) {
    NSLog(@"json = %@------------]",json);
        
        NSArray *arr = json[@"ProductShareList"];
        NSLog(@"arr.count = %d", arr.count);
        
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
        self.popKeyWords = @"";
    } failure:^(NSError *error) {
        NSLog(@"-------产品搜索请求失败 error is%@----------",error);
    }];
}

#pragma mark - 搜索界面协议传值方法
- (void)transmitPopKeyWord:(NSString *)keyWords{
    self.popKeyWords = keyWords;
    NSLog(@",,,,,,, key = %@ %@", keyWords, self.popKeyWords);
    [self.searchButton setTitle:self.popKeyWords forState:UIControlStateNormal];
    [self loadSharePageData];
}
- (void)searchBarText:(NSString *)text{
    self.popKeyWords = text;
    NSLog(@"text = %@", self.popKeyWords);
    [self.searchButton setTitle:self.popKeyWords forState:UIControlStateNormal];
    [self loadSharePageData];
}



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
