//
//  FindProduct.m
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "FindProduct.h"
#import "leftCell.h"
#import "rightCell.h"
#import "rightCell2.h"
#import "rightCell3.h"
#import "rightModal.h"
#import "rightModal2.h"
#import "rightModal3.h"
#import "HeaderView.h"
#import "ProductList.h"
#import "StationSelect.h"
#import "IWHttpTool.h"
#import "StrToDic.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "SearchProductViewController.h"
#import "WMAnimations.h"
#import "ResizeImage.h"
#import "UIImageView+WebCache.h"
#import "newModel.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"
@interface FindProduct ()<UITableViewDelegate,UITableViewDataSource,headerViewDelegate, notifi>
{
    NSInteger t;
}
@property (weak, nonatomic) IBOutlet UIView *blackView;

@property (weak, nonatomic) IBOutlet UIView *line;
- (IBAction)stationSelect:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *stationName;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
- (IBAction)search:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *leftTable;
@property (weak, nonatomic) IBOutlet UITableView *rightTable;
@property (strong,nonatomic) NSMutableArray *leftTableArr;
@property(strong,nonatomic)NSArray *leftNormoalIconArr;
@property(strong,nonatomic)NSArray *leftSelectIconArr;
@property(strong,nonatomic)NSMutableArray *rightTableArr;
@property(copy,nonatomic) NSMutableString *row;
@property (weak, nonatomic) IBOutlet UITableView *rightTable2;
@property (strong, nonatomic) NSMutableArray *rightMoreArr;
@property (strong , nonatomic) NSMutableArray *rightMoreSearchID;//rightTbale2的searchKey
@property(copy,nonatomic) NSMutableString *table2Row;
@property (weak, nonatomic) IBOutlet UITableView *hotTable;
@property (strong, nonatomic) NSMutableArray *hotArr;
@property (strong , nonatomic) NSMutableDictionary *hotArrDic;
@property (strong, nonatomic) NSMutableArray *hotSectionArr;
@property (strong, nonatomic) NSMutableArray *hotNumberOfSectionArr;//section内有多少个row
@property (weak,nonatomic) UIView *subHotView;
@property (weak, nonatomic)  UIImageView *hotIcon;
@property (weak, nonatomic)  UIButton *hotBtn;
@property (assign,nonatomic) BOOL isHot;

@property (nonatomic, assign)NSInteger selectNum;

@property (nonatomic,strong) NSMutableArray *pushArr;
@end

@implementation FindProduct

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
   self.title = @"找产品";
    self.leftTable.delegate = self;
    self.leftTable.dataSource  = self;
    self.rightTable.delegate = self;
    self.rightTable.dataSource = self;
    self.rightTable2.delegate = self;
    self.rightTable2.dataSource = self;
    self.hotTable.delegate = self;
    self.hotTable.dataSource = self;
    t=1;
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.searchBtn.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.5 andNeedShadow:NO];
    self.isHot = YES;
    self.rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    [self loadDataSourceLeft];
    [self loadHotData];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewDidClickedLoadBtn:)];
    [self.blackView addGestureRecognizer:tap];
    
    //设置一个没有的数，保证第一次都正常加载
    self.selectNum = 100;
    
}

#pragma -mark 点击手势隐藏蒙板


#pragma  mark - stationSelect delegate
-(void)notifiToReloadData
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *str = [def objectForKey:@"stationSelect"];
    if ([str isEqualToString:@"yes"]) {
        [self loadDataSourceLeft];
        [self loadHotData];
        [def setObject:@"no" forKey:@"stationSelect"];
        [def synchronize];
    }
   
//    [self loadDataSourceLeft];

}

-(NSMutableString *)row
{
    if (_row == nil) {
        self.row = [NSMutableString string];
    }
    return _row;
}

-(NSMutableString *)table2Row
{
    if (_table2Row == nil) {
        self.table2Row = [NSMutableString string];
    }
    return _table2Row;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"FindProduct"];
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"FindProductNum" attributes:dict];
    [MobClick event:@"ShouKeBaoAndFindproductNum" attributes:dict];

    
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    NSString *subStationName = [udf stringForKey:@"SubstationName"];
    if (subStationName) {
        [self.stationName setTitle:subStationName forState:UIControlStateNormal];
    }else if (!subStationName){
        [self.stationName setTitle:@"上海" forState:UIControlStateNormal];
    }
    
    
    
    NSIndexPath *selected = [self.leftTable indexPathForSelectedRow];
    if(selected) [self.leftTable deselectRowAtIndexPath:selected animated:NO];
    
    NSIndexPath *selected1 = [self.rightTable indexPathForSelectedRow];
    if(selected1) [self.rightTable deselectRowAtIndexPath:selected animated:NO];
    
    NSIndexPath *selected2 = [self.hotTable indexPathForSelectedRow];
    if(selected2) [self.hotTable deselectRowAtIndexPath:selected animated:NO];
    
    NSIndexPath *selected3 = [self.rightTable2 indexPathForSelectedRow];
    if(selected3) [self.rightTable2 deselectRowAtIndexPath:selected animated:NO];
    
    [self notifiToReloadData];
    
  }

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FindProduct"];

}

#pragma mark - LoadDataSource
- (void)loadDataSourceLeft
{
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"加载中...";
    
    [IWHttpTool WMpostWithURL:@"/Product/GetNavigationType" params:nil success:^(id json) {
    //    NSLog(@"-------------------left json is %@----------",json);
        
        [self.leftTableArr removeAllObjects];
        for(NSDictionary *dic in json[@"NavigationTypeList"]){
            leftModal *modal = [leftModal modalWithDict:dic];
            [self.leftTableArr addObject:modal];
        }
        NSLog(@"%@~~~~~~~~~~",[NSThread currentThread]);
        
         [hudView show:YES];
        [hudView hide:YES afterDelay:0.5];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftTable reloadData];
            
            [self loadDataSourceRight];
        });
        
      //  NSLog(@"~~~~~~~~~~~leftArr is %@~~~~~~~~~~",_leftTableArr);
    
    } failure:^(NSError *error) {
        NSLog(@"左侧栏请求错误！～～～error is ~~~~~~~~~%@",error);
    }];
}


- (void)loadDataSourceRight
{
    int selectRow = [self.row intValue];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    leftModal *model = self.leftTableArr[selectRow];
    [dic setObject:model.Type forKey:@"NavigationType"];
    dispatch_queue_t q = dispatch_queue_create("loadDataSourceRight", DISPATCH_QUEUE_SERIAL);
    dispatch_async(q, ^{
        [IWHttpTool WMpostWithURL:@"/Product/GetNavigationMain" params:dic success:^(id json) {
             NSLog(@"-------------dataSourceRight json is %@-----------------",json);
            
            [self.rightTableArr removeAllObjects];
            NSMutableArray *searchKeyArr = [NSMutableArray array];
            for(NSDictionary *dic in json[@"NavigationMainList"] ){
                rightModal2 *modal = [rightModal2 modalWithDict:dic];
                [searchKeyArr addObject:dic[@"ID"]];
                [self.rightTableArr addObject:modal];
                
            }
            _rightMoreSearchID = searchKeyArr;//取出子大区的key
            
            
            //        self.rightTable.scrollEnabled = YES;
            [self.rightTable reloadData];
            [self.rightTable headerEndRefreshing];

        } failure:^(NSError *error) {
            NSLog(@"左侧栏请求错误！～～～error is ~~~~~~~~~%@",error);
        }];

    });
   }



- (void)loadDataSourceRight2
{
    int selectRow = [self.table2Row intValue];
   // NSLog(@"---------selectRow 转化为int 后为%d-------------",selectRow);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    NSString *searchID = _rightMoreSearchID[selectRow];
    [dic setObject:searchID forKey:@"NavigationMainID"];

  
    
    [IWHttpTool WMpostWithURL:@"/Product/GetNavigationChild" params:dic success:^(id json) {
       
        NSLog(@"-----------------------dataSource2 json is %@-----------------",json);
        
        [self.rightMoreArr removeAllObjects];
     
        for(NSDictionary *dic in json[@"NavigationChildList"] ){
            rightModal3 *modal = [rightModal3 modalWithDict:dic];
            [self.rightMoreArr addObject:modal];
       // newModel *model = [newModel modalWithDict:dic];
           // [self.pushArr addObject:model];
        }
        
            [self.rightTable2 reloadData];
       // });
    } failure:^(NSError *error) {
        NSLog(@"右侧栏子栏rightTable3 请求错误！～～～error is ~~~~~~~~~%@",error);
    }];
}


-(void)loadHotData
{

    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    
    hudView.labelText = @"加载中...";
    
    [hudView show:YES];
    
[IWHttpTool WMpostWithURL:@"/Product/GetRankingProduct" params:nil success:^(id json) {
   // NSLog(@"---------热卖返回json is %@--------",json);
   [self.hotArr removeAllObjects];
    
   // [self.hotSectionArr removeAllObjects];
    NSMutableArray *hotDicNameArr = [NSMutableArray array];
    for (NSDictionary *dic in json[@"RankingProdctList"]) {
        [hotDicNameArr addObject:dic[@"Name"]];
    }
    self.hotSectionArr = hotDicNameArr;   //获取section数组
   
    
    NSLog(@"hotSectionArr is %@",_hotSectionArr);
    
    for (NSDictionary *dic in json[@"RankingProdctList"]) {
        NSMutableArray *tmp = [NSMutableArray array];
for (NSDictionary *dict in dic[@"ProductList"]) {
            rightModal *modal = [rightModal modalWithDict:dict];
              [tmp addObject:modal];
}
         [self.hotArr addObject:tmp];
        }//获得热卖总数组
    
   // NSLog(@"------------hotarr------------------%@",self.hotArr);

    for (int i = 0 ; i<self.hotArr.count; i++) {
        [self.hotArrDic setObject:self.hotArr[i] forKey:self.hotSectionArr[i]];
    }
    
//    self.hotTable.scrollEnabled = YES;
        [self.hotTable reloadData];
    [hudView hide:YES];
} failure:^(NSError *error) {
    NSLog(@"-----------hot json 请求失败，原因：%@",error);
}];

    
}



#pragma mark - private
-(void)iniHeaderRight
{
        //下啦刷新
    [self.rightTable addHeaderWithTarget:self action:@selector(rightheadRefresh) dateKey:nil];
    [self.rightTable headerBeginRefreshing];
    //上啦刷新
    [self.rightTable addFooterWithTarget:self action:@selector(rightfootRefresh)];
    [self.rightTable footerBeginRefreshing];
    //设置文字
    self.rightTable.headerPullToRefreshText = @"下拉刷新";
    self.rightTable.headerRefreshingText = @"正在刷新中";
    
    self.rightTable.footerPullToRefreshText = @"上拉刷新";
    self.rightTable.footerRefreshingText = @"正在刷新";
    
    //下啦刷新
    [self.hotTable addHeaderWithTarget:self action:@selector(rightheadRefresh) dateKey:nil];
    [self.hotTable headerBeginRefreshing];
    //上啦刷新
    [self.hotTable addFooterWithTarget:self action:@selector(rightfootRefresh)];
    [self.hotTable footerBeginRefreshing];
    //设置文字
    self.hotTable.headerPullToRefreshText = @"下拉刷新";
    self.hotTable.headerRefreshingText = @"正在刷新中";
    
    self.hotTable.footerPullToRefreshText = @"上拉刷新";
    self.hotTable.footerRefreshingText = @"正在刷新";
}



-(void)rightheadRefresh
{//上拉刷新,一般在此方法内添加刷新内容
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        [self loadDataSourceRight];
        [self loadHotData];
       [self.rightTable headerEndRefreshing];
      });
}



-(void)rightfootRefresh
{//下拉刷新
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        [self loadDataSourceRight];
         [self loadHotData];
       [self.rightTable footerEndRefreshing];
      
    });
}



- (IBAction)stationSelect:(id)sender {
   // [MobClick event:@"changeStationInPageTwo"];
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"FindProductStationClick" attributes:dict];

    StationSelect *station = [[StationSelect alloc] init];
    station.delegate = self;
    [self.navigationController pushViewController:station animated:YES];
}



- (IBAction)search:(id)sender {
    
    //[MobClick event:@"searchInpageTwo"];
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"FindProductSearchList" attributes:dict];

    SearchProductViewController *SPVC = [[SearchProductViewController alloc] init];
    SPVC.isFromFindProduct = YES;
    [self.navigationController pushViewController:SPVC animated:NO];
}



-(void)setLeftTableHeader{

}


- (void)hotBtnClick:(id)sender {
   // [MobClick event:@"remmondClick"];
//    self.rightTable.scrollEnabled = NO;
    NSDictionary * dic = @{@"SubName":@"热门推荐"};
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:dic];
    [MobClick event:@"FindProductSubNameClick" attributes:dict];

    self.row = nil;
//    [self.hotBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    self.leftTable.tableHeaderView.backgroundColor = [UIColor whiteColor];
    [self.leftTable reloadData];
    self.isHot = YES;
    [UIView animateWithDuration:0.7 animations:^{
        self.rightTable.alpha = 0;
        self.rightTable2.alpha = 0;
        self.hotTable.alpha = 1;
        self.selectNum = 100;
        self.hotIcon.image = [UIImage imageNamed:@"APPhot2"];
    } completion:^(BOOL finished) {
//        self.hotTable.scrollEnabled = YES;
    }];
    
}

#pragma mark - getter
-(NSMutableArray *)leftTableArr
{
    if (_leftTableArr == nil) {
        _leftTableArr = [NSMutableArray array];
    }
    return _leftTableArr;
}


-(NSMutableArray *)rightTableArr
    {
        if (_rightTableArr == nil) {
            _rightTableArr = [NSMutableArray array];
        }
        return _rightTableArr;
    }


- (NSMutableArray *)rightMoreArr
{
    if (!_rightMoreArr) {
        _rightMoreArr = [NSMutableArray array];
    }
    return _rightMoreArr;
}


- (NSMutableArray *)hotArr
{
    if (!_hotArr) {
        _hotArr = [NSMutableArray array];
    }
    return _hotArr;
}

-(NSMutableArray *)pushArr
{
    if (_pushArr == nil) {
        self.pushArr = [NSMutableArray array];
    }
    return _pushArr;
}


#pragma mark - rightTable2的代理方法
-(void)headerViewDidClickedLoadBtn:(HeaderView *)headerView//rightTable2的代理方法
{
    [UIView animateWithDuration:0.3 animations:^{
        self.rightTable2.alpha = 0;
        self.rightTable.alpha = 1;
        self.blackView.alpha = 0;

    }];
}


#pragma mark - tableviewdatasource&& tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return 49;
    }
    if (tableView.tag == 3 ) {
        return 74;
    }
    
    if (tableView.tag == 4 ) {
        return 13;
    }
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == 1){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.leftTable.frame.size.width, 50)];
        view.backgroundColor = [UIColor colorWithRed:227/255.f green:237/255.f blue:245/255.f alpha:1];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, self.leftTable.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:184/255.f green:186/255.f blue:191/255.f alpha:1];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"APPhot2"] ];
       img.frame = CGRectMake(10, 16, 18, 18);
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotBtnClick:)];
        [img addGestureRecognizer:tap];
        self.hotIcon = img;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(35, 0, 60, 50);
[btn setTitle:@"热门推荐" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.hotBtn = btn;
        
        if (7>=[self.row intValue]>=0) {
            img.image = [UIImage imageNamed:@"APPhot"];
            [btn setTitleColor:[UIColor colorWithRed:85/255.f green:94/255.f blue:100/255.f alpha:1] forState:UIControlStateNormal];
        }
        
        if (_isHot == YES) {
            img.image = [UIImage imageNamed:@"APPhot2"];
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            view.backgroundColor = [UIColor whiteColor];
        }
        [view addSubview:line];
        [view addSubview:img];
        [view addSubview:btn];
        self.subHotView = view;
        return view;
    }
    
    
    
    if (tableView.tag == 3) {
        HeaderView *header = [HeaderView headerView];
        header.frame = CGRectMake(0, 0, 200, 74);
        header.delegate = self;
        return header;
    }if (tableView.tag == 4) {
                UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 13)];
      
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12, -5, 180, 13)];
                lab.text = self.hotSectionArr[section];
                lab.font = [UIFont systemFontOfSize:11];
        [v_headerView addSubview:lab];
        lab.backgroundColor = [UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:1];//设置v_headerLab的背景颜色
        lab.textColor = [UIColor grayColor];//设置v_headerLab的字体颜色
        lab.font = [UIFont fontWithName:@"Arial" size:11];//设置v_headerLab的字体样式和大小
        return v_headerView;
    }
    return 0;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 50;
    }else if (tableView.tag == 2){
        return  88;
    }else if (tableView.tag == 3){
        return 59;
    }else if (tableView.tag == 4){
        return 88;
    }
    return 0;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   if (tableView.tag == 4) {
       NSLog(@"-------%lu",(unsigned long)self.hotSectionArr.count);
        return self.hotSectionArr.count;
    }
    return 1;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 4) {
        return self.hotSectionArr[section];
        
    }
    return 0;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return self.leftTableArr.count;
    }else if (tableView.tag == 2){
        return self.rightTableArr.count;
    }else if (tableView.tag == 3) {
        return self.rightMoreArr.count;
    }else if (tableView.tag == 4){
        return [self.hotArr[section] count];
        
    }
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.rightTable.scrollEnabled = NO;
//    self.hotTable.scrollEnabled = NO;
    if (tableView.tag == 1) {
        
        if (self.selectNum == indexPath.row) {
            [self.leftTable reloadData];
        }else{

        self.selectNum = indexPath.row;
        leftModal *model = self.leftTableArr[indexPath.row];
            NSDictionary * dic = @{@"SubName":model.Name};
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:dic];
            [MobClick event:@"FindProductSubNameClick" attributes:dict];

                self.isHot = NO;
        self.row = [NSMutableString stringWithFormat:@"%ld",(long)indexPath.row];
        NSLog(@"self.row is %@",_row);
//            dispatch_queue_t q = dispatch_queue_create("lidingd", DISPATCH_QUEUE_SERIAL);
//            dispatch_async(q, ^{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                               [self loadDataSourceRight];
            [self.leftTable reloadData];

                           [MBProgressHUD hideHUDForView:self.view animated:YES];
           // });
      
       
        
        [self.hotBtn setTitleColor:[UIColor colorWithRed:214/255.f green:222/255.f blue:232/255.f alpha:0.7] forState:UIControlStateNormal];
        self.hotBtn.titleLabel.font = [UIFont systemFontOfSize:12];
         self.subHotView.backgroundColor = [UIColor colorWithRed:214/255.f green:222/255.f blue:232/255.f alpha:1];
        [UIView animateWithDuration:0.3 animations:^{
            self.rightTable2.alpha = 0;
            self.hotTable.alpha = 0;
           // self.hotIcon.image = [UIImage imageNamed:@"APPhot"];
            self.rightTable.alpha = 1;
            self.rightTable.frame = self.hotTable.frame;
            
            [self.hotBtn setTitleColor:[UIColor colorWithRed:214/255.f green:222/255.f blue:232/255.f alpha:0.7] forState:UIControlStateNormal];
            self.hotBtn.titleLabel.font = [UIFont systemFontOfSize:12];

        }];
        }

    }
    
    if (tableView.tag == 2 ) {
      
//        rightModal2 *model = self.rightTableArr[indexPath.row];
        
        self.table2Row = [NSMutableString stringWithFormat:@"%ld",(long)indexPath.row];
        NSLog(@"-----------tableSelectRow is %@--------",_table2Row);
//        [UIView animateWithDuration:0.3 animations:^{
//            self.rightTable2.alpha = 1;
//            self.rightTable.alpha = 0;
//            self.blackView.alpha = 0.5;
//            self.rightTable2.frame = self.hotTable.frame;
//       }];
    //--------------
        int selectRow = [self.table2Row intValue];
        // NSLog(@"---------selectRow 转化为int 后为%d-------------",selectRow);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        NSString *searchID = _rightMoreSearchID[selectRow];
        [dic setObject:searchID forKey:@"NavigationMainID"];
        
        dispatch_queue_t q = dispatch_queue_create("lidingd", DISPATCH_QUEUE_SERIAL);
        dispatch_async(q, ^{
       //     [self.rightMoreArr removeAllObjects];
            
            [IWHttpTool WMpostWithURL:@"/Product/GetNavigationChild" params:dic success:^(id json) {
                
                NSLog(@"-----------------------dataSource2 json is %@-----------------",json);
                
                [self.rightMoreArr removeAllObjects];
                
                for(NSDictionary *dic in json[@"NavigationChildList"] ){
                    rightModal3 *modal = [rightModal3 modalWithDict:dic];
                    [self.rightMoreArr addObject:modal];
                    
                    NSMutableDictionary *dicNew = [NSMutableDictionary dictionary];
                    
                    [dicNew setObject:dic[@"Name"] forKey:@"Text"];
                    [dicNew setObject:dic[@"SearchKey"] forKey:@"Value"];
                    [self.pushArr addObject:dicNew];
                }
                //NSLog(@"------------ first object is %@,rightarr is %@",[self.rightMoreArr firstObject],_rightMoreArr);
                rightModal3 *modal3 = [self.rightMoreArr firstObject];
                NSString *key = modal3.searchKey;
                NSString *title = modal3.Name;
                NSLog(@" key is ~~` ~%@``````````------",key);
                ProductList *list = [[ProductList alloc] init];
                list.pushedSearchK = key;
                list.title = title;
                list.pushedArr = _pushArr;

                NSDictionary * dic = @{@"TwoSubName":key};
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:dic];
                [MobClick event:@"FindProductList" attributes:dict];

                [self.navigationController pushViewController:list animated:YES];
                //  [self.rightTable2 reloadData];
                
            } failure:^(NSError *error) {
                NSLog(@"右侧栏子栏rightTable3 请求错误！～～～error is ~~~~~~~~~%@",error);
            }];

        });
        
    }
//    if (tableView.tag ==3 && _rightMoreArr) {
//
//                  rightModal3 *modal3 = _rightMoreArr[indexPath.row];
//            NSString *key = modal3.searchKey;
//            NSString *title = modal3.Name;
//            NSLog(@" key is ~~` ~%@``````````------",key);
//            ProductList *list = [[ProductList alloc] init];
//            list.pushedSearchK = key;
//            list.title = title;
//
//        [self.navigationController pushViewController:list animated:YES];
//        
//    
//    }
    if (tableView.tag == 4) {

        ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
        rightModal *model =  _hotArr[indexPath.section][indexPath.row];
        NSString *productUrl = model.productUrl;
        detail.produceUrl = productUrl;
        detail.fromType = FromHotProduct;
        detail.m = t;
             [self.navigationController pushViewController:detail animated:YES];
    }

 [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}



- (void)deselect{
    
   // [self.leftTable deselectRowAtIndexPath:[self.leftTable indexPathForSelectedRow] animated:YES];
     [self.rightTable deselectRowAtIndexPath:[self.rightTable indexPathForSelectedRow] animated:YES];
     [self.rightTable2 deselectRowAtIndexPath:[self.rightTable2 indexPathForSelectedRow] animated:YES];
     [self.hotTable deselectRowAtIndexPath:[self.hotTable indexPathForSelectedRow] animated:YES];
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (tableView.tag == 1 ) {//&& ([_row intValue] == 0)
        leftCell *cell = [leftCell cellWithTableView:tableView];
        leftModal *model = self.leftTableArr[indexPath.row];
        cell.modal = model;
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.MaxIcon]];

        
        if (indexPath.row == [self.row intValue] && self.isHot == NO){
            
            cell.name.textColor = [UIColor orangeColor];
            [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.MaxIconFocus]];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }else if(tableView.tag == 2) {
        
    rightCell2 *cell = [rightCell2 cellWithTableView:tableView];
        cell.modal = [self.rightTableArr objectAtIndex:indexPath.row];
       
        return cell;
    }else if (tableView.tag == 3){
        
        rightCell3 *cell = [rightCell3 cellWithTableView:tableView];
        cell.modal = [self.rightMoreArr objectAtIndex:indexPath.row];
               return cell;
    }else if (tableView.tag == 4){
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        rightCell *cell = [rightCell cellWithTableView:tableView];
        cell.rightIcon.image = [ResizeImage reSizeImage:cell.rightIcon.image toSize:CGSizeMake(50, 50)];

        rightModal *model = [[self.hotArr objectAtIndex:section] objectAtIndex:row];
        cell.modal = model;
        return cell;
    }
    return cell;
}

@end
