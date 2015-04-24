//
//  ProductList.m
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//
#define titleWid 2/3
#import "ProductList.h"
#import "ProductCell.h"
#import "ProductModal.h"
#import "IWHttpTool.h"
#import "MJRefresh.h"
#import "ProductModal.h"
#import "FootView.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "StrToDic.h"
#import "ConditionSelectViewController.h"
#import "ConditionModel.h"
#import "MBProgressHUD+MJ.h"
#import "SearchProductViewController.h"
#import "SearchProductViewController.h"
#import "StationSelect.h"
#import "MinMaxPriceSelectViewController.h"
#import "WMAnimations.h"
#import "MJRefresh.h"
@interface ProductList ()<UITableViewDelegate,UITableViewDataSource,footViewDelegate,MGSwipeTableCellDelegate,passValue,passSearchKey,UITextFieldDelegate,passThePrice>
@property (copy,nonatomic) NSMutableString *searchKey;
@property (weak, nonatomic) IBOutlet UIView *subView;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray *dataArr;
@property (copy , nonatomic) NSMutableString *page;
@property (weak, nonatomic) IBOutlet UITableView *subTable;
- (IBAction)sunCancel:(id)sender;
- (IBAction)subReset:(id)sender;
- (IBAction)subDone:(id)sender;
- (IBAction)subMinMax:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *jiafanSwitch;

- (IBAction)jiafanSwitchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *jishiSwitch;
- (IBAction)jishiSwitchAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *priceBtnOutlet;
//@property (weak, nonatomic) IBOutlet UIView *blackView;

//@property (copy , nonatomic) NSMutableString *ProductSortingType;//推荐:”0",利润（从低往高）:”1"利润（从高往低:”2"
//同行价（从低往高）:”3,同行价（从高往低）:"4"
- (IBAction)recommond:(id)sender;
- (IBAction)profits:(id)sender;
- (IBAction)cheapPrice:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *commondOutlet;
@property (weak, nonatomic) IBOutlet UIButton *profitOutlet;
@property (weak, nonatomic) IBOutlet UIButton *cheapOutlet;
@property (strong,nonatomic) NSMutableDictionary *conditionDic;//当前条件开关
@property (strong,nonatomic) NSMutableArray *conditionArr;//post装载的条件数据
@property (strong,nonatomic) NSArray *subDataArr1;
@property (strong,nonatomic) NSArray *subDataArr2;
@property (strong,nonatomic) NSMutableArray *subIndicateDataArr1;
@property (strong,nonatomic) NSMutableArray *subIndicateDataArr2;
@property (strong,nonatomic) NSMutableString *turn;
@property (weak , nonatomic) UIButton *subTableSectionBtn;
@property (copy,nonatomic) NSMutableString *jiafan;
@property (copy,nonatomic) NSMutableString *jishi;
@property (weak, nonatomic) IBOutlet UIView *subSubView;
@property (weak,nonatomic) UIView *coverView;

@end

@implementation ProductList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPull];
    
    [self editButtons];
    
    // self.navigationController.title = self.title;
    [self customRightBarItem];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.subTable.delegate = self;
    self.subTable.dataSource = self;
 
    self.page = [NSMutableString stringWithFormat:@"1"];
    
    FootView *foot = [FootView footView];
    foot.delegate = self;
    //self.table.tableFooterView = foot;
    [self.commondOutlet setSelected:YES];
    
   // [self loadDataSource];

    [self.profitOutlet setTitle:@"利润 ↑" forState:UIControlStateNormal ];
   
    [self.cheapOutlet setTitle:@"同行价 ↑" forState:UIControlStateNormal ];
   
    self.subTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.subDataArr1 = [NSArray arrayWithObjects:@"游览线路      ",@"出发日期      ",@"出发城市      ",@"主题推荐      ",@"供应商      ", nil];//5
    self.subDataArr2 = [NSArray arrayWithObjects:@"酒店类型      ",@"出行方式      ",@"油轮公司      ",@"线路等级      ", nil];//4
    self.subIndicateDataArr1 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ", nil];
    self.subIndicateDataArr2 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ", nil];
    self.turn = [NSMutableString stringWithFormat:@"Off"];

    self.table.tableFooterView = [[UIView alloc] init];

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*titleWid, 34)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];//215 237 244
    btn.frame = CGRectMake(0, 0, self.view.frame.size.width*titleWid, 34);
    [btn setBackgroundImage:[UIImage imageNamed:@"sousuoBackView"] forState:UIControlStateNormal];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"fdjBtn"] forState:UIControlStateNormal];

    // UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 14, 14)];
    //imgv.image = [UIImage imageNamed:@"fdjBtn"];
    btn2.frame = CGRectMake(28, 0, self.view.frame.size.width*titleWid-28, 34);
    [btn2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

    [btn2 setTitle:[NSString stringWithFormat:@"  %@",_pushedSearchK] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
 [btn addTarget:self action:@selector(clickPush) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btn];
    [btn2 addTarget:self action:@selector(clickPush) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btn];
    [titleView addSubview:btn2];
   // [titleView addSubview:imgv];
    self.navigationItem.titleView = titleView;
    
    SearchProductViewController *searchVC = [[SearchProductViewController alloc] init];
    searchVC.delegate = self;
    
   
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
 
//self.table.separatorStyle = UITableViewCellSelectionStyleNone;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editButtons
{
    
    [self.commondOutlet setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateSelected];
    [self.commondOutlet setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateHighlighted];
    [self.commondOutlet setTitleColor:[UIColor colorWithRed:14/255.f green:123/255.f blue:225/255.f alpha:1] forState:UIControlStateSelected];
    
    [self.profitOutlet setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateSelected];
    [self.profitOutlet setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateHighlighted];
    [self.profitOutlet setTitleColor:[UIColor colorWithRed:14/255.f green:123/255.f blue:225/255.f alpha:1] forState:UIControlStateSelected];
    
    [self.cheapOutlet setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateSelected];
    [self.cheapOutlet setBackgroundImage:[UIImage imageNamed:@"btnWhiteBackGround"] forState:UIControlStateHighlighted];
    [self.cheapOutlet setTitleColor:[UIColor colorWithRed:14/255.f green:123/255.f blue:225/255.f alpha:1] forState:UIControlStateSelected];

}
-(UIView *)subView
{
    if (_subView == nil) {
        self.subView = [[[NSBundle mainBundle] loadNibNamed:@"ProductList" owner:self options:nil] lastObject];
    }
    return _subView;
}
#pragma - stationSelect delegate
-(void)passStation:(NSString *)stationName andStationNum:(NSNumber *)stationNum
{

}
-(void)passSearchKeyFromSearchVC:(NSString *)searchKey
{
    self.pushedSearchK = [NSMutableString stringWithFormat:@"%@",searchKey];
}
#pragma  mark 没有产品时嵌图
-(void)addANewFootViewWhenHaveNoProduct
{
    CGFloat wid = self.view.frame.size.width;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake((wid-200)/2, 100, 200, 200)];
    imgv.contentMode = UIViewContentModeScaleAspectFit;
    imgv.image = [UIImage imageNamed:@"content_null"];
    [self.view addSubview:imgv];
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)clickPush
{
    [self.navigationController pushViewController:[[SearchProductViewController alloc] init] animated:NO];
}

-(NSMutableString *)jishi
{
    if (_jishi == nil) {
        if (self.jishiSwitch.on == YES) {
            _jishi = [NSMutableString stringWithFormat:@"1"];
        }else
            _jishi = [NSMutableString stringWithFormat:@"0"];
       
    }
    return _jishi
    ;
}


-(NSMutableString *)jiafan
{
    if (_jiafan == nil) {
        if (self.jiafanSwitch.on == YES) {
            _jiafan = [NSMutableString stringWithFormat:@"1"];
        }else
            _jiafan = [NSMutableString stringWithFormat:@"0"];
    }
    return _jiafan;
}


-(NSMutableDictionary *)conditionDic
{
    if (_conditionDic == nil) {
        self.conditionDic = [NSMutableDictionary dictionary];
    }
    return _conditionDic;
}


#pragma  mark - conditionDetail delegate//key 指大字典的key value指字典中某一子value的值
-(void)passKey:(NSString *)key andValue:(NSString *)value andSelectIndexPath:(NSArray *)selectIndexPath andSelectValue:(NSString *)selectValue
{
    //确认列表选择值
   // self.conditionDic = [NSMutableDictionary dictionary];
    
    if (value) {
   
        [self.conditionDic setObject:value forKey:key];
        
        if ([selectIndexPath[0]isEqualToString:@"0"]) {
            
            NSInteger a = [selectIndexPath[1] integerValue];//分析selected IndexPath.row的值
            
            self.subIndicateDataArr1[a] = selectValue;
     
        }else if ([selectIndexPath[0] isEqualToString:@"1"]){
            
            NSInteger a = [selectIndexPath[1] integerValue];
           
            self.subIndicateDataArr2[a] = selectValue;
        }
        
        [self.subTable reloadData];
        //[self loadDataSourceWithCondition];

    }
   
    self.coverView.hidden = NO;
    
    NSLog(@"-----------conditionDic is %@--------",self.conditionDic);
    
}


#pragma  mark -priceDelegate
-(void)passTheMinPrice:(NSString *)min AndMaxPrice:(NSString *)max
{
    self.coverView.hidden = NO;
    
    if (![min  isEqual: @""] && ![max  isEqual: @""]) {
        [self.conditionDic setObject:min forKey:@"MinPrice"];
        [self.conditionDic setObject:max forKey:@"MaxPrice"];
        [self.priceBtnOutlet setTitle:[NSString stringWithFormat:@"价格区间：%@元－%@元",min,max] forState:UIControlStateNormal];

    }else if ([max isEqualToString:@"0"]){
        [self.priceBtnOutlet setTitle:@"价格区间" forState:UIControlStateNormal];
    }else if ([min  isEqual: @""] || [max  isEqual: @""]){
     [self.priceBtnOutlet setTitle:@"价格区间" forState:UIControlStateNormal];
    }
}

-(void)initPull
{
    //上啦刷新
    [self.table addFooterWithTarget:self action:@selector(footViewDidClickedLoadBtn:)];
    //设置文字
   self.table.footerPullToRefreshText = @"加载更多";
    self.table.footerRefreshingText = @"正在刷新";
    //下拉
    [self.table addHeaderWithTarget:self action:@selector(headerPull)];
    [self.table headerBeginRefreshing];

    self.table.headerPullToRefreshText =@"刷新内容";
    self.table.headerRefreshingText = @"正在刷新";
}

-(void)initConditionPull
{
    //上啦刷新
    [self.table addFooterWithTarget:self action:@selector(loadDataSourceWithCondition)];
    //设置文字
    self.table.footerPullToRefreshText = @"加载更多";
    self.table.footerRefreshingText = @"正在刷新";
}

#pragma  -mark 下来刷新数据
-(void)headerPull
{
    [self loadDataSource];
    [self.table headerEndRefreshing];
    
    
}
#pragma footView - delegate上拉加载更多
-(void)footViewDidClickedLoadBtn:(FootView *)footView
{//推荐:”0",利润（从低往高）:”1"利润（从高往低:”2"
    //同行价（从低往高）:”3,同行价（从高往低）:"4"
    NSString *type = [NSString string];
    if (self.commondOutlet.selected == YES) {
        type = @"0";
    }
    if (self.profitOutlet.selected == YES && [self.profitOutlet.currentTitle isEqual:@"利润 ↑"]) {
        type = @"1";
    }else if (self.profitOutlet.selected == YES && [self.profitOutlet.currentTitle isEqual:@"利润 ↓"]){
    type = @"2";
    }
    if (self.cheapOutlet.selected == YES && [self.cheapOutlet.currentTitle isEqualToString:@"同行价 ↑"]) {
        type = @"3";
    }else if (self.cheapOutlet.selected == YES && [self.cheapOutlet.currentTitle isEqualToString:@"同行 ↓"])
    {
    type = @"4";
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:[self conditionDic]];//增加筛选条件
  //  [dic setObject:@"10" forKey:@"Substation"];
    [dic setObject:@"10" forKey:@"PageSize"];
    [dic setObject:self.pushedSearchK forKey:@"SearchKey"];
    [dic setObject:_page forKey:@"PageIndex"];
    [dic setObject:type forKey:@"ProductSortingType"];
    [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
    [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];
   // NSLog(@"-------page2 请求的 dic  is %@-----",dic);
    [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
        NSLog(@"----------更多按钮返回json is %@--------------",json);
        NSArray *arr = json[@"ProductList"];
        if (arr.count == 0) {
           // self.table.tableFooterView.hidden = YES;
            
        }else if (10>arr.count>0){
         // self.table.tableFooterView.hidden = YES;
            for (NSDictionary *dic in json[@"ProductList"]) {
                ProductModal *modal = [ProductModal modalWithDict:dic];
                [self.dataArr addObject:modal];
            }
            
            [self.table reloadData];
            NSString *page = [NSString stringWithFormat:@"%@",_page];
            self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];
        }else if (arr.count == 10){
           // self.table.tableFooterView.hidden = NO;
            for (NSDictionary *dic in json[@"ProductList"]) {
                ProductModal *modal = [ProductModal modalWithDict:dic];
                [self.dataArr addObject:modal];
            }
            
            [self.table reloadData];
            NSString *page = [NSString stringWithFormat:@"%@",_page];
            self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];

        }
       
        [self.table footerEndRefreshing];
            
    } failure:^(NSError *error) {
        NSLog(@"-------产品搜索请求失败 error is%@----------",error);
    }];


}
#pragma mark - private
-(void)customRightBarItem
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [button setImage:[UIImage imageNamed:@"APPsaixuan"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(setSubViewHideNo)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem= barItem;
}

- (void)loadDataSource
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    self.page = [NSMutableString stringWithFormat:@"1"];
  //  [dic setObject:@"10" forKey:@"Substation"];
    [dic setObject:@"10" forKey:@"PageSize"];
    [dic setObject:@1 forKey:@"PageIndex"];
    [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
    [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];
    
    [dic setObject:_pushedSearchK forKey:@"SearchKey"];
    [dic setObject:@"0" forKey:@"ProductSortingType"];
    [dic addEntriesFromDictionary:[self conditionDic]];//增加筛选条件
    [self.dataArr removeAllObjects];
    [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
        
        NSLog(@"--------------json[condition is  %@------------]",json);
        NSArray *arr = json[@"ProductList"];
        NSLog(@"------------arr.cont is %lu---------",(unsigned long)arr.count);
        if (arr.count==0) {
            [self addANewFootViewWhenHaveNoProduct];
          //  self.table.tableFooterView.hidden = YES;
        }else if (10>arr.count>0){
         //self.table.tableFooterView.hidden = YES;
            for (NSDictionary *dic in json[@"ProductList"]) {
                ProductModal *modal = [ProductModal modalWithDict:dic];
                [self.dataArr addObject:modal];
            }

        }else if (arr.count == 10){
           // self.table.tableFooterView.hidden = NO;
            for (NSDictionary *dic in json[@"ProductList"]) {
                ProductModal *modal = [ProductModal modalWithDict:dic];
                [self.dataArr addObject:modal];
            }

        }
        
        NSMutableArray *conArr = [NSMutableArray array];
        
        for(NSDictionary *dic in json[@"ProductConditionList"] ){
            [conArr addObject:dic];
        }
        
        
        _conditionArr = conArr;//装载筛选条件数据
        
        NSLog(@"---------!!!!!!dataArr is %@!!!!!! conditionArr is %@------",_dataArr,_conditionArr);

        
//        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        
        NSString *page = [NSString stringWithFormat:@"%@",_page];
        self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];

        if (_dataArr != nil) {
           
           
            [self.table reloadData];
     
        }
        
    } failure:^(NSError *error) {
        NSLog(@"-------产品搜索请求失败 error is%@----------",error);
    }];

}

#pragma 筛选navitem
-(void)setSubViewHideNo
{

    UIView *cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
   
    CGFloat W = self.view.frame.size.width * 0.8;
  
    self.subView.frame = CGRectMake(self.view.frame.size.width, 0, W, self.view.window.bounds.size.height);

    [cover addSubview:self.subView];
    self.coverView = cover;
    [self.view.window addSubview:cover];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.subView.transform = CGAffineTransformMakeTranslation(- self.subView.frame.size.width, 0);
    }];

    
}


#pragma mark - getter
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }

    return _dataArr;
   
}

-(NSMutableArray *)conditionArr
{
    if (_conditionArr == nil) {
        _conditionArr = [NSMutableArray array];
    }
    return _conditionArr;
}

// 左边滑动的按钮
- (NSArray *)createLeftButtons:(ProductModal *)model
{
//    NSString *tmp = [NSString stringWithFormat:@"%@\n%@",model.ContactName,model.ContactMobile];
    NSString *tmp = [NSString stringWithFormat:@"联系人\n%@\n\n联系电话\n%@",@"恰的",@"13120555759"];
    NSMutableArray * result = [NSMutableArray array];
    UIColor * color = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    
    MGSwipeButton * button = [MGSwipeButton buttonWithTitle:tmp icon:nil backgroundColor:color callback:^BOOL(MGSwipeTableCell * sender){
        NSLog(@"Convenience callback received (left).");
        return YES;
    }];
    CGRect frame = button.frame;
    frame.size.width = 100;
    button.frame = frame;
    button.titleLabel.numberOfLines = 0;
    [button setTitleColor:[UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [result addObject:button];
    button.enabled = NO;
    
    return result;
}

// 右边滑动的按钮
- (NSArray *)createRightButtons:(ProductModal *)model
{
    NSMutableArray * result = [NSMutableArray array];
    NSString *add = [NSString stringWithFormat:@"最近班期:%@\n\n供应商:%@",model.LastScheduleDate,model.SupplierName];
    NSString* titles[2] = {@"", add};
    UIColor * colors[2] = {[UIColor clearColor], [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1]};
    for (int i = 0; i < 2; i ++)
    {
        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            NSLog(@"Convenience callback received (right). %d",i);
            return YES;
        }];
        
        if (i == 0) {
            NSString *img = [model.IsFavorites isEqualToString:@"1"] ? @"uncollection_icon" : @"collection_icon";
            [button setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        }else{
            button.titleLabel.numberOfLines = 0;
            button.enabled = NO;
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:[UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1] forState:UIControlStateNormal];
        CGRect frame = button.frame;
        frame.size.width = i == 1 ? 200 : 42;
        button.frame = frame;
        
        [result addObject:button];
    }
    return result;
}

#pragma mark - tableviewdatasource& tableviewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 136;
    }
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1){
        return self.dataArr.count;
    }
    if (tableView.tag == 2) {
        if (section == 0) {
            NSLog(@"-------%lu",(unsigned long)_subDataArr1.count);
            return _subDataArr1.count;
        }
        if (section == 1 && [_turn isEqualToString:@"On" ]) {
            NSLog(@"-------%lu",(unsigned long)_subDataArr2.count);
            return _subDataArr2.count;
        }

    }
    return 0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 2) {
        return 2;
    }
    return 1;
}

//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if(tableView.tag == 2){

//        if(section == 1 && [_turn isEqualToString:@"Off"]){
//       
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.subTable.frame.size.width, 38)];
//        
//            view.userInteractionEnabled = YES;
//    
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-0.5, view.frame.size.width, 0.5)];
//        
//            line.backgroundColor = [UIColor colorWithRed:203/255.f green:204/255.f blue:205/255.f alpha:1];
//        
//            [view addSubview:line];
//      
//        view.backgroundColor = [UIColor whiteColor];
//        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//        
//            btn.titleLabel.font = [UIFont systemFontOfSize:15];
//       
//            btn.frame = CGRectMake(0, 0, view.frame.size.width, 38);
//        
//            [btn setTitle:@"展开更多▼" forState:UIControlStateNormal];
//       
//            [btn addTarget:self action:@selector(beMore) forControlEvents:UIControlEventTouchUpInside];
//       
//            self.subTableSectionBtn = btn;
//       
//            [view addSubview:btn];
//        
//        return view;
//   
//        }else if (section == 1 && [_turn isEqualToString:@"On"]){
//        
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 1,self.subTable.frame.size.width, 38)];
//       
//            view.userInteractionEnabled = YES;
//        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-0.5,
//                                                                view.frame.size.width, 0.5)];
//       
//            line.backgroundColor = [UIColor colorWithRed:203/255.f green:204/255.f blue:205/255.f
//                                                   alpha:1];
//        [view addSubview:line];
//
//        view.backgroundColor = [UIColor whiteColor];
//       
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//       
//            btn.titleLabel.font = [UIFont systemFontOfSize:15];
//       
//            btn.frame = CGRectMake(0, 0,view.frame.size.width, 38);
//       
//            [btn setTitle:@"收起▲" forState:UIControlStateNormal];
//       
//            [btn addTarget:self action:@selector(beMore) forControlEvents:UIControlEventTouchUpInside];
//       
//            self.subTableSectionBtn = btn;
//       
//            [view addSubview:btn];
//        
   //     return view;
//        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, 0)];
//        return view;
//    }
//
//    return 0;
//    
//}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 2 ) {
        
        
        if(section == 1 && [_turn isEqualToString:@"Off"]){
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.subTable.frame.size.width, 38)];
            
            view.userInteractionEnabled = YES;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-0.5, view.frame.size.width, 0.5)];
            
            line.backgroundColor = [UIColor colorWithRed:203/255.f green:204/255.f blue:205/255.f alpha:1];
            
            [view addSubview:line];
            
            view.backgroundColor = [UIColor whiteColor];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            
            btn.frame = CGRectMake(0, 0, view.frame.size.width, 38);
            
            [btn setTitle:@"展开更多▼" forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(beMore) forControlEvents:UIControlEventTouchUpInside];
            
            self.subTableSectionBtn = btn;
            
            [view addSubview:btn];
            
            
            
            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.subTable.frame.size.width, 210)];
            
            UIView *subLine = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.subTable.frame.size.width, 20)];
            
            subLine.backgroundColor = [UIColor colorWithRed:237/255.f green:238/255.f blue:239/255.f alpha:1];
            
            UIView *sublineSub = [[UIView alloc] initWithFrame:CGRectMake(0,49.5, subLine.frame.size.width,0.5)];
            
            sublineSub.backgroundColor = [UIColor colorWithRed:203/255.f green:204/255.f blue:205/255.f alpha:1];
            
            [subLine addSubview:sublineSub];
            
            [footView addSubview:subLine];
            
            self.subSubView.frame = CGRectMake(0, 50, self.subTable.frame.size.width, 160);
            
            [WMAnimations WMAnimationMakeBoarderNoCornerRadiosWithLayer:self.subSubView.layer andBorderColor:[UIColor colorWithRed:203/255.f green:204/255.f blue:205/255.f alpha:1] andBorderWidth:0.5 andNeedShadow:NO ];
            
            [footView addSubview:self.subSubView];

            [footView addSubview:view];
            return footView;
            
        }else if (section == 1 && [_turn isEqualToString:@"On"]){
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 1,self.subTable.frame.size.width, 38)];
            
            view.userInteractionEnabled = YES;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-0.5,
                                                                    view.frame.size.width, 0.5)];
            
            line.backgroundColor = [UIColor colorWithRed:203/255.f green:204/255.f blue:205/255.f
                                                   alpha:1];
            [view addSubview:line];
            
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                    view.frame.size.width, 0.5)];
            
            line2.backgroundColor = [UIColor colorWithRed:203/255.f green:204/255.f blue:205/255.f
                                                   alpha:1];
            [view addSubview:line2];
            
            view.backgroundColor = [UIColor whiteColor];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            
            btn.frame = CGRectMake(0, 0,view.frame.size.width, 38);
            
            [btn setTitle:@"收起▲" forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(beMore) forControlEvents:UIControlEventTouchUpInside];
            
            self.subTableSectionBtn = btn;
            
            [view addSubview:btn];
            
//////////
        
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.subTable.frame.size.width, 210)];
        
        UIView *subLine = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.subTable.frame.size.width, 20)];
        
        subLine.backgroundColor = [UIColor colorWithRed:237/255.f green:238/255.f blue:239/255.f alpha:1];
        
        UIView *sublineSub = [[UIView alloc] initWithFrame:CGRectMake(0,49.5, subLine.frame.size.width,0.5)];
        
        sublineSub.backgroundColor = [UIColor colorWithRed:203/255.f green:204/255.f blue:205/255.f alpha:1];
        
        [subLine addSubview:sublineSub];
        
        [footView addSubview:subLine];
        
        self.subSubView.frame = CGRectMake(0, 50, self.subTable.frame.size.width, 160);
        
        [WMAnimations WMAnimationMakeBoarderNoCornerRadiosWithLayer:self.subSubView.layer andBorderColor:[UIColor colorWithRed:203/255.f green:204/255.f blue:205/255.f alpha:1] andBorderWidth:0.5 andNeedShadow:NO ];
        
        [footView addSubview:self.subSubView];
            [footView addSubview:view];
        
        return footView;
    }
    }
        return 0;


}

-(void)beMore
{
    NSLog(@"点击了butn");
    
    if ([_turn isEqualToString:@"Off"]) {
      
        self.turn = [NSMutableString stringWithString:@"On"];
    }
    else
    
        self.turn = [NSMutableString stringWithString:@"Off"];
  
    [self.subTable reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 2 && section == 1) {
   
        return 0;
    }
   
    return 0;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 2 && section == 1) {
        
        return 220;
    }
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
       
        ProductModal *model = _dataArr[indexPath.row];
        
       NSString *productUrl = model.LinkUrl;
       
        NSString *productName = model.Name;
     
        ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
       
        detail.produceUrl = productUrl;
       
        detail.productName = productName;
       
        [self.navigationController pushViewController:detail animated:YES];
       
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
   
    if (tableView.tag == 2) {
        
        NSInteger a = (5*(indexPath.section)) + (indexPath.row);//获得当前点击的row行数
    
        //    NSLog(@"-------------a is %ld  ----_conditionArr[a] is %@------------",(long)a,_conditionArr[a]);
       NSDictionary *conditionDic = _conditionArr[a];
       
        ConditionSelectViewController *conditionVC = [[ConditionSelectViewController alloc] init];
       
        conditionVC.delegate = self;
       
        conditionVC.conditionDic = conditionDic;
        
        NSArray *arr = [NSArray arrayWithObjects:[NSString  stringWithFormat:@"%ld",(long)
                                                  indexPath.section],[NSString  stringWithFormat:@"%ld",(long)indexPath.row], nil];
        conditionVC.superViewSelectIndexPath = arr;//取出第几行被选择
  
        //取出conditionVC的navTile
        NSString *conditionVCTile;
       
        if (indexPath.section == 0) {
       
            conditionVCTile = _subDataArr1[indexPath.row];
       
        }else if (indexPath.section == 1){
         
            conditionVCTile = _subDataArr2[indexPath.row];
        }
       
        conditionVC.title = conditionVCTile;
        
       
        //    NSLog(@"-----------conditionVC.conditionDic is %@---------",conditionVC.conditionDic);
        self.coverView.hidden = YES;
       
        [self.navigationController pushViewController:conditionVC animated:YES];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1 ) {
       //if (_dataArr) {
        
        ProductCell *cell = [ProductCell cellWithTableView:tableView];
            
            ProductModal *model = _dataArr[indexPath.row];
        
        cell.modal = model;
            
            cell.delegate = self;
            
            // cell的滑动设置
            cell.leftSwipeSettings.transition = MGSwipeTransitionStatic;
        
        cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
            
            cell.leftButtons = [self createLeftButtons:model];
        
        cell.rightButtons = [self createRightButtons:model];
        
        return cell;
 
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"没有找到符合要求的产品" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
//        [alert show];
            }
  
   if (tableView.tag == 2) {
      
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
      
       if (cell == nil) {
           
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
          
           cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
          
           UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, self.subTable.frame.size.width, 0.5)];
           
           line.backgroundColor = [UIColor colorWithRed:203/255.f green:204/255.f blue:205/255.f alpha:1];
           
           [cell addSubview:line];
        }
       
       if (indexPath.section == 0) {
          
           cell.textLabel.font = [UIFont systemFontOfSize:15];
          
           cell.textLabel.text =  [NSString stringWithFormat:@"%@",self.subDataArr1[indexPath.row]];
          
          cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
         
           cell.detailTextLabel.text = self.subIndicateDataArr1[indexPath.row];
          
           cell.detailTextLabel.textColor = [UIColor orangeColor];
     
       }else {
          
           cell.textLabel.text = [NSString stringWithFormat:@"%@",self.subDataArr2[indexPath.row]];
          
           cell.textLabel.font = [UIFont systemFontOfSize:15];
         
           cell.textLabel.text =  [NSString stringWithFormat:@"%@",self.subDataArr2[indexPath.row]];
          
           cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
          
           cell.detailTextLabel.text = self.subIndicateDataArr2[indexPath.row];
          
           cell.detailTextLabel.textColor = [UIColor orangeColor];

       }
       return cell;
    }
    return  0;
}


#pragma mark - MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction
{
    return YES;
}

- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    return [NSArray array];
}

// 收藏按钮点击
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSIndexPath *indexPath = [self.table indexPathForCell:cell];
    
    NSLog(@"------%@",indexPath);
    
    ProductModal *model = _dataArr[indexPath.row];
   
    NSString *result = [model.IsFavorites isEqualToString:@"0"]?@"1":@"0";
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:model.ID forKey:@"ProductID"];
    
    [dic setObject:result forKey:@"IsFavorites"];///Product/ SetProductFavorites
  
    [IWHttpTool WMpostWithURL:@"/Product/SetProductFavorites" params:dic success:^(id json) {
       NSLog(@"产品收藏成功%@",json);
      
        [MBProgressHUD showSuccess:@"操作成功"];
     
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
        
            [MBProgressHUD hideHUD];
      
        });

   } failure:^(NSError *error) {
  
       NSLog(@"产品收藏网络请求失败");
  
   }];
    
    return YES;
}


#pragma mark - other
- (void)didReceiveMemoryWarning {
   
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)recommond:(id)sender {//推荐
   
    [self.profitOutlet setSelected:NO];
   
    [self.cheapOutlet setSelected:NO];
   
    [self.commondOutlet setSelected:YES];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic addEntriesFromDictionary:_conditionDic];//增加筛选条件
   
    NSLog(@"----------增加的conditionDic is %@------------",_conditionDic);
  
    [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
  
    [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];

  //  [dic setObject:@"10" forKey:@"Substation"];
    [dic setObject:@"10" forKey:@"PageSize"];
   
    [dic setObject:@1 forKey:@"PageIndex"];
   
    [dic setObject:@"0" forKey:@"ProductSortingType"];
   // [self ProductSortingTypeWith:@"0"];
   
    [dic setObject:self.pushedSearchK forKey:@"SearchKey"];
   // NSLog(@"-------page2 请求的 dic  is %@-----",dic);
    [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
    
        [self.dataArr removeAllObjects];//移除
      
        NSMutableArray *dicArr = [NSMutableArray array];
      
        for (NSDictionary *dic in json[@"ProductList"]) {
        
            ProductModal *modal = [ProductModal modalWithDict:dic];
         
            [dicArr addObject:modal];
        
        }
        
        _dataArr = dicArr;
       
        
        [self.table reloadData];
       
        NSString *page = [NSString stringWithFormat:@"%@",_page];
      
        self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];
      //  NSLog(@"---------转化后的page is %@ +1后的 page is -------%@----",page,_page);
    } failure:^(NSError *error) {
      
        NSLog(@"-------产品搜索请求失败 error is%@----------",error);
    }];

}


- (IBAction)profits:(id)sender {//利润2,1
    
    if (self.profitOutlet.selected == NO) {
       
        [self.profitOutlet setSelected:YES];
       
        [self.cheapOutlet setSelected:NO];
       
        [self.commondOutlet setSelected:NO];
       
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
       
        [dic addEntriesFromDictionary:_conditionDic];//增加筛选条件
       
        [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
       
        [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];

       // [dic setObject:@"10" forKey:@"Substation"];
        [dic setObject:@"10" forKey:@"PageSize"];
      
        [dic setObject:@1 forKey:@"PageIndex"];
      
        [dic setObject:@"2" forKey:@"ProductSortingType"];
        //[self ProductSortingTypeWith:@"2"];
        [dic setObject:self.pushedSearchK forKey:@"SearchKey"];
      
        NSLog(@"-------page2 请求的 dic  is %@-----",dic);
      
        [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
         
            [self.dataArr removeAllObjects];//移除
         
            NSMutableArray *dicArr = [NSMutableArray array];
         
            for (NSDictionary *dic in json[@"ProductList"]) {
             
                ProductModal *modal = [ProductModal modalWithDict:dic];
              
                [dicArr addObject:modal];
            }
            _dataArr = dicArr;
            
            
            [self.table reloadData];
         
            NSString *page = [NSString stringWithFormat:@"%@",_page];
           
            self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];
          //  NSLog(@"---------转化后的page is %@ +1后的 page is -------%@----",page,_page);
        } failure:^(NSError *error) {
         
            NSLog(@"-------产品搜索请求失败 error is%@----------",error);
        }];
        

    }else if (self.profitOutlet.selected == YES && [self.profitOutlet.titleLabel.text
                                                    isEqualToString:@"利润 ↑"]){
        [self.profitOutlet setTitle:@"利润 ↓" forState:UIControlStateNormal];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
       
        [dic addEntriesFromDictionary:_conditionDic];//增加筛选条件
       
        [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
      
        [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];

      //  [dic setObject:@"10" forKey:@"Substation"];
        [dic setObject:@"10" forKey:@"PageSize"];
       
        [dic setObject:@1 forKey:@"PageIndex"];
      
        [dic setObject:@"1" forKey:@"ProductSortingType"];
       // [self ProductSortingTypeWith:@"1"];
        [dic setObject:self.pushedSearchK forKey:@"SearchKey"];
       // NSLog(@"-------page2 请求的 dic  is %@-----",dic);
        [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
       
            [self.dataArr removeAllObjects];//移除
         
            NSMutableArray *dicArr = [NSMutableArray array];
          
            for (NSDictionary *dic in json[@"ProductList"]) {
          
                ProductModal *modal = [ProductModal modalWithDict:dic];
             
                [dicArr addObject:modal];
            }
            _dataArr = dicArr;
            
            
            [self.table reloadData];
           
            NSString *page = [NSString stringWithFormat:@"%@",_page];
           
            self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];
            //NSLog(@"---------转化后的page is %@ +1后的 page is -------%@----",page,_page);
        } failure:^(NSError *error) {
        
            NSLog(@"-------产品搜索请求失败 error is%@----------",error);
        }];
  
    }else if (self.profitOutlet.selected == YES && [self.profitOutlet.titleLabel.text
                                                    isEqualToString:@"利润 ↓"]){
    [self.profitOutlet setTitle:@"利润 ↑" forState:UIControlStateNormal];
       
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
      
        [dic addEntriesFromDictionary:_conditionDic];//增加筛选条件
     
        [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
       
        [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];

      //  [dic setObject:@"10" forKey:@"Substation"];
        [dic setObject:@"10" forKey:@"PageSize"];
       
        [dic setObject:@1 forKey:@"PageIndex"];
       
        [dic setObject:@"2" forKey:@"ProductSortingType"];
       // [self ProductSortingTypeWith:@"2"];
        [dic setObject:self.pushedSearchK forKey:@"SearchKey"];
      //  NSLog(@"-------page2 请求的 dic  is %@-----",dic);
       
        [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
          
            [self.dataArr removeAllObjects];//移除
         
            NSMutableArray *dicArr = [NSMutableArray array];
          
            for (NSDictionary *dic in json[@"ProductList"]) {
              
                ProductModal *modal = [ProductModal modalWithDict:dic];
               
                [dicArr addObject:modal];
            }
            _dataArr = dicArr;
            
            
            [self.table reloadData];
           
            NSString *page = [NSString stringWithFormat:@"%@",_page];
          
            self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];
          //  NSLog(@"---------转化后的page is %@ +1后的 page is -------%@----",page,_page);
        } failure:^(NSError *error) {
          
            NSLog(@"-------产品搜索请求失败 error is%@----------",error);
        }];

   }
    }


- (IBAction)cheapPrice:(id)sender {//同行价4,3
   
    if (self.cheapOutlet.selected == NO) {
       
        [self.cheapOutlet setSelected:YES];
        
        [self.commondOutlet setSelected:NO];
        
        [self.profitOutlet setSelected:NO];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic addEntriesFromDictionary:_conditionDic];//增加筛选条件
        
        [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
        
        [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];

        //[dic setObject:@"10" forKey:@"Substation"];
        
        [dic setObject:@"10" forKey:@"PageSize"];
        
        [dic setObject:@1 forKey:@"PageIndex"];
        
        [dic setObject:@"4" forKey:@"ProductSortingType"];
     //   [self ProductSortingTypeWith:@"4"];
        
        [dic setObject:self.pushedSearchK forKey:@"SearchKey"];
       // NSLog(@"-------page2 请求的 dic  is %@-----",dic);
        
        [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
        
            [self.dataArr removeAllObjects];//移除
            
            NSMutableArray *dicArr = [NSMutableArray array];
            
            for (NSDictionary *dic in json[@"ProductList"]) {
            
                ProductModal *modal = [ProductModal modalWithDict:dic];
                
                [dicArr addObject:modal];
            }
           
            _dataArr = dicArr;
            
            
            [self.table reloadData];
            
            NSString *page = [NSString stringWithFormat:@"%@",_page];
            
            self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];
          //  NSLog(@"---------转化后的page is %@ +1后的 page is -------%@----",page,_page);
        } failure:^(NSError *error) {
          
            NSLog(@"-------产品搜索请求失败 error is%@----------",error);
        
        }];

    }else if (self.cheapOutlet.selected == YES && [self.cheapOutlet.titleLabel.text
                                                   isEqualToString:@"同行价 ↑"]){
        
        [self.cheapOutlet setTitle:@"同行价 ↓" forState:UIControlStateNormal];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic addEntriesFromDictionary:_conditionDic];//增加筛选条件
        
        [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
        
        [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];

      //  [dic setObject:@"10" forKey:@"Substation"];
        
        [dic setObject:@"10" forKey:@"PageSize"];
        
        [dic setObject:@1 forKey:@"PageIndex"];
        
        [dic setObject:@"3" forKey:@"ProductSortingType"];
       // [self ProductSortingTypeWith:@"3"];
        
        [dic setObject:self.pushedSearchK forKey:@"SearchKey"];
       // NSLog(@"-------page2 请求的 dic  is %@-----",dic);
        
        [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
        
            [self.dataArr removeAllObjects];//移除
            
            NSMutableArray *dicArr = [NSMutableArray array];
            
            for (NSDictionary *dic in json[@"ProductList"]) {
            
                ProductModal *modal = [ProductModal modalWithDict:dic];
                
                [dicArr addObject:modal];
            }
            
            _dataArr = dicArr;
            
            
            [self.table reloadData];
            
            NSString *page = [NSString stringWithFormat:@"%@",_page];
            
            self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];
         //   NSLog(@"---------转化后的page is %@ +1后的 page is -------%@----",page,_page);
        } failure:^(NSError *error) {
         
            NSLog(@"-------产品搜索请求失败 error is%@----------",error);
        }];

    }else if (self.cheapOutlet.selected == YES &&[self.cheapOutlet.titleLabel.text
                                                  isEqualToString:@"同行价 ↓"]){
    [self.cheapOutlet setTitle:@"同行价 ↑" forState:UIControlStateNormal];
       
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic addEntriesFromDictionary:_conditionDic];//增加筛选条件
        
        [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
        
        [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];

       // [dic setObject:@"10" forKey:@"Substation"];
        [dic setObject:@"10" forKey:@"PageSize"];
        
        [dic setObject:@1 forKey:@"PageIndex"];
        
        [dic setObject:@"4" forKey:@"ProductSortingType"];
       // [self ProductSortingTypeWith:@"4"];
        
        [dic setObject:self.pushedSearchK forKey:@"SearchKey"];
      //  NSLog(@"-------page2 请求的 dic  is %@-----",dic);
        
        [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
        
            [self.dataArr removeAllObjects];//移除
            
            NSMutableArray *dicArr = [NSMutableArray array];
            
            for (NSDictionary *dic in json[@"ProductList"]) {
            
                ProductModal *modal = [ProductModal modalWithDict:dic];
                
                [dicArr addObject:modal];
            }
            
            _dataArr = dicArr;
            
            
            [self.table reloadData];
            
            NSString *page = [NSString stringWithFormat:@"%@",_page];
            
            self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];
         //   NSLog(@"---------转化后的page is %@ +1后的 page is -------%@----",page,_page);
        } failure:^(NSError *error) {
            
            NSLog(@"-------产品搜索请求失败 error is%@----------",error);
        }];

    }
}

- (IBAction)sunCancel:(id)sender {
//   [UIView animateWithDuration:0.3 animations:^{
//              self.subView.alpha = 0;
//       self.subView.hidden = YES;
//   }];
    //self.blackView.alpha = 0;
    [self editButtons];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.subView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        [self.coverView removeFromSuperview];
       // [_dressView removeFromSuperview];
    }];

    // [self loadDataSourceWithCondition];
    
   }


- (IBAction)subReset:(id)sender {

    self.conditionDic = nil;
    [self editButtons];
    
    self.jishi = [NSMutableString stringWithFormat:@"1"];
    
    self.jiafan = [NSMutableString stringWithFormat:@"1"];
    
    self.subIndicateDataArr1 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ", nil];
    
    self.subIndicateDataArr2 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ", nil];
    
    [self.subTable reloadData];
    
    [self recommond:sender];
    
}

- (IBAction)subDone:(id)sender {
   
    [self initConditionPull];
    [self editButtons];
    
    
    [UIView animateWithDuration:0.3 animations:^{
    
        self.subView.transform = CGAffineTransformIdentity;
    
    } completion:^(BOOL finished) {
    
        [self.coverView removeFromSuperview];
        
        // [_dressView removeFromSuperview];
        
        [self recommond:sender];
        
        [self.commondOutlet setSelected:YES];
        
        self.profitOutlet.selected = NO;
        
        self.cheapOutlet.selected = NO;
    }];



}


- (IBAction)subMinMax:(id)sender {
    
    
    MinMaxPriceSelectViewController *mm = [[MinMaxPriceSelectViewController alloc] init];
   
    mm.delegate = self;
    
    self.coverView.hidden = YES;
    
    [self.navigationController pushViewController:mm animated:YES];
}


- (void)loadDataSourceWithCondition
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    self.page = [NSMutableString stringWithFormat:@"1"];
    //  [dic setObject:@"10" forKey:@"Substation"];
    [dic setObject:@"10" forKey:@"PageSize"];
    [dic setObject:@1 forKey:@"PageIndex"];
    [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
    [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];
    
    [dic setObject:_pushedSearchK forKey:@"SearchKey"];
    [dic setObject:@"0" forKey:@"ProductSortingType"];
    [dic addEntriesFromDictionary:[self conditionDic]];//增加筛选条件
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    
    hudView.labelText = @"加载中...";
    
    [hudView show:YES];
 
    
    [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
        
        NSLog(@"--------------json[condition is  %@------------]",json);
        NSArray *arr = json[@"ProductList"];
        NSLog(@"------------arr.cont is %lu---------",(unsigned long)arr.count);
     //   [self.dataArr removeAllObjects];
        if (arr.count==0) {
            [self addANewFootViewWhenHaveNoProduct];
           // self.table.tableFooterView.hidden = YES;
        }else if (10>arr.count>0){
            //self.table.tableFooterView.hidden = YES;
            for (NSDictionary *dic in json[@"ProductList"]) {
                ProductModal *modal = [ProductModal modalWithDict:dic];
                [self.dataArr addObject:modal];
            }
            
        }else if (arr.count == 10){
           // self.table.tableFooterView.hidden = NO;
            for (NSDictionary *dic in json[@"ProductList"]) {
                ProductModal *modal = [ProductModal modalWithDict:dic];
                [self.dataArr addObject:modal];
            }
            
        }
        
        NSMutableArray *conArr = [NSMutableArray array];
        
        for(NSDictionary *dic in json[@"ProductConditionList"] ){
            [conArr addObject:dic];
        }
        
        
        _conditionArr = conArr;//装载筛选条件数据
        
        NSLog(@"---------!!!!!!dataArr is %@!!!!!! conditionArr is %@------",_dataArr,_conditionArr);
        
        
//        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        
        NSString *page = [NSString stringWithFormat:@"%@",_page];
        self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];
        
        if (_dataArr != nil) {
            
            
            [self.table reloadData];
            
            
            
           
            [hudView hide:YES];
            [self.table footerEndRefreshing];

            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"-------产品搜索请求失败 error is%@----------",error);
    }];
    
}



- (IBAction)jiafanSwitchAction:(id)sender {

    
}

- (IBAction)jishiSwitchAction:(id)sender {

    
}



@end
