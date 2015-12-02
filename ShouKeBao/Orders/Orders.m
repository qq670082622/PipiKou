//
//  Orders.m
//  ShouKeBao
//
//  Created by Chard on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Orders.h"
#import "MJRefresh.h"
#import "OrderCell.h"
#import "OrderModel.h"
#import "OrderTool.h"
#import "DressView.h"
#import "AreaViewController.h"
#import "MBProgressHUD+MJ.h"
#import "ButtonDetailViewController.h"
#import "OrderDetailViewController.h"
#import "DetailView.h"
#import "SKSearchBar.h"
#import "SKSearckDisplayController.h"
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "CantactView.h"
#import "WriteFileManager.h"
#import "HistoryView.h"
#import "MenuButton.h"
#import "QDMenu.h"
#import "ChooseDayViewController.h"
#import "UIImage+QD.h"
#import "ArrowBtn.h"
#import "NullContentView.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"
#import "NSString+FKTools.h"
#import "InvoiceAlertView.h"

#import "MySubscribeController.h"//分享，临时用的
#define pageSize 10
#define searchDefaultPlaceholder @"订单号/产品名称/供应商名称"
#define kScreenSize [UIScreen mainScreen].bounds.size
#define historyCount 6
typedef void (^ChangeFrameBlock)();

@interface Orders () <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,DressViewDelegate,AreaViewControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate,OrderCellDelegate,MGSwipeTableCellDelegate,MenuButtonDelegate,QDMenuDelegate,ChooseDayViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,assign) int pageIndex;// 当前页
@property (nonatomic,assign) BOOL added;
@property (nonatomic,copy) NSString *totalCount;
@property (nonatomic,copy)ChangeFrameBlock changeFrameblock;

@property (nonatomic,strong) MenuButton *menuButton;
@property (nonatomic,strong) QDMenu *qdmenu;
@property (nonatomic,assign) NSInteger LselectedIndex;
@property (nonatomic,assign) NSInteger RselectedIndex;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) NSMutableArray *chooseTime;// 所有时间
@property (nonatomic,strong) NSMutableArray *chooseStatus;// 所有状态

@property (nonatomic,copy) NSString *choosedTime;// 选择的时间
@property (nonatomic,copy) NSString *choosedStatus;// 选择的状态

@property (nonatomic,copy) NSString *goDateStart;
@property (nonatomic,copy) NSString *goDateEnd;

@property (nonatomic,copy) NSString *createDateStart;
@property (nonatomic,copy) NSString *createDateEnd;

@property (nonatomic,strong) NSMutableArray *firstAreaData;
@property (nonatomic,strong) NSDictionary *firstValue;// 选择大区以后获取值
@property (nonatomic,strong) NSDictionary *secondValue;// 选择二级区获取的值
@property (nonatomic,strong) NSDictionary *thirdValue;// 三级选择
// 区域选择的数字
@property (nonatomic,assign) NSInteger firstIndex;
@property (nonatomic,assign) NSInteger secondIndex;
@property (nonatomic,assign) NSInteger thirdIndex;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, assign)BOOL isReloadMainTabaleView;
@property (nonatomic,strong) DressView *dressView;
@property (nonatomic,weak) UIView *cover;
@property (nonatomic, assign)BOOL isNUll;

//@property (nonatomic,weak) UIView *sep1;// 开始搜索的边界线
@property (nonatomic,weak) UIView *sep2;

@property (nonatomic,strong) SKSearchBar *searchBar;
@property (nonatomic,strong) SKSearckDisplayController *searchDisplay;
@property (nonatomic,copy) NSString *searchKeyWord;
@property (nonatomic,assign) BOOL isSearch;// 判断是不是 搜索结果  因为列表空的话显示的文字不同
@property (nonatomic,strong) NSMutableArray *invoice;
@property (nonatomic,strong) DetailView *detailView;

@property (nonatomic,weak) HistoryView *historyView;

@property (nonatomic,assign) BOOL isHeadRefresh;

@property (nonatomic,strong) NullContentView *nullContentView;

@property (nonatomic,strong) UIView *guideView;
@property (nonatomic,strong) UIImageView *guideImageView;
@property (nonatomic,assign) int guideIndex;
@property (nonatomic,strong) UIButton *invoiceBtn;//开发票的button

@property (nonatomic,strong) InvoiceAlertView *invoiceAlert;//提示弹框
@property (nonatomic) NSInteger FirstOpenNav;

@end

@implementation Orders

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.title = @"理订单";
    [self.dataArr removeAllObjects];// 进来时清空数组 心情舒畅些
    self.pageIndex = 1;// 页码从1开始
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.choosedTime = @"";
    self.choosedStatus = @"0";
    self.searchKeyWord = @"";
    self.goDateStart = @"";
    self.goDateEnd = @"";
    self.createDateStart = @"";
    self.createDateEnd = @"";
    
    // 刷新控件
    [self iniHeader];

    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.menu];
    [self.view addSubview:self.menuButton];
    [self searchDisplay];
    [self.view addSubview:self.searchBar];
    
    [self loadConditionData];
    [self loadDataSuorceByConditionInvoice];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBack:) name:@"DressViewClickBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickReset:) name:@"DressViewClickReset" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickConfirm:) name:@"DressViewClickConfirm" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCellDidClickButton:) name:@"orderCellDidClickButton" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historySearch:) name:@"historysearch" object:nil];
    
    
    
    NSUserDefaults *orderGuideDefault = orderGuideDefault = [NSUserDefaults standardUserDefaults];
    NSString *orderGuide = [orderGuideDefault objectForKey:@"orderGuide"];
    NSLog(@"orderGuide = %@", orderGuide);
    if ([orderGuide integerValue] != 1) {// 是否第一次打开app
        [self Guide];
        self.FirstOpenNav = 6;
    }
    // 导航按钮
    [self customRightBarItem];

    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Orders"];
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"OrderNum" attributes:dict];

    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *appIsBack = [def objectForKey:@"appIsBack"];
    if ([appIsBack isEqualToString:@"no"]) {
        [self loadConditionData];
        NSLog(@" appIsBack = %@---", appIsBack);
    }
    [def synchronize];

    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Orders"];
    [self.invoiceArr removeAllObjects];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - loadDatasource
- (void)loadConditionData
{
    self.isNUll = NO;
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    NSDictionary *param = @{};
    [OrderTool getOrderConditionWithParam:param success:^(id json) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].delegate.window animated:YES];
        [self.chooseTime removeAllObjects];
        [self.chooseStatus removeAllObjects];
        if (json) {
            NSLog(@"----%@",json);

            if ([json[@"IsSuccess"] integerValue] == 1) {
                
                for (NSDictionary *timeDic in json[@"DateRangList"]) {
                    [self.chooseTime addObject:timeDic];
                }
                
                for (NSDictionary *statusDic in json[@"StateList"]) {
                    [self.chooseStatus addObject:statusDic];
                }
                
                for (NSDictionary *areaDic in json[@"FirstLevelArea"]) {
                    [self.firstAreaData addObject:areaDic];
                }
                // 获取筛选条件后加载默认的列表
                [self.tableView headerBeginRefreshing];
            }
        }
    } failure:^(NSError *error) {
    }];
}
#warning 这里有需求
// 根据条件加载数据
- (void)loadDataSuorceByCondition
{   self.isNUll = NO;
    self.isReloadMainTabaleView = NO;
    NSString *first = self.firstValue ? self.firstValue[@"Value"] : @"0";
    NSString *second = self.secondValue ? self.secondValue[@"Value"] : @"";
    NSString *third = self.thirdValue ? self.thirdValue[@"Value"] : @"";
    NSDictionary *param = @{@"PageIndex":[NSString stringWithFormat:@"%d",self.pageIndex],
                            @"PageSize":[NSString stringWithFormat:@"%d",pageSize],
                            @"KeyWord":self.searchKeyWord,
                            @"CreatedDateRang":self.choosedTime,
                            @"State":self.choosedStatus,
                            @"GoDateStart":self.goDateStart,
                            @"GoDateEnd":self.goDateEnd,
                            @"FirstLevelArea":first,
                            @"SecondLevelAreaID":second,
                            @"ThirdLevelAreaID":third,
                            @"CreatedDateStart":self.createDateStart,
                            @"CreatedDateEnd":self.createDateEnd,
                            @"IsRefund":[NSString stringWithFormat:@"%d",self.dressView.IsRefund.on]};
    [OrderTool getOrderListWithParam:param success:^(id json) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        self.isReloadMainTabaleView = YES;
        if (json) {
                if (self.isHeadRefresh) {
                    [self.dataArr removeAllObjects];
                }
                self.totalCount = json[@"TotalCount"];
                
                for (NSDictionary *dic in json[@"OrderList"]) {
                    OrderModel *order = [OrderModel orderModelWithDict:dic];
                    [self.dataArr addObject:order];
                }
                    self.isSearch = self.searchKeyWord.length;
                    [self setNullImage];
                    [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
// 加载可以开发票的数据
- (void)loadDataSuorceByConditionInvoice
{
    self.isNUll = NO;
    NSString *first = self.firstValue ? self.firstValue[@"Value"] : @"0";
    NSString *second = self.secondValue ? self.secondValue[@"Value"] : @"";
    NSString *third = self.thirdValue ? self.thirdValue[@"Value"] : @"";
    NSDictionary *param = @{@"PageIndex":[NSString stringWithFormat:@"%d",self.pageIndex],
                            @"PageSize":[NSString stringWithFormat:@"%d",pageSize],
                            @"KeyWord":self.searchKeyWord,
                            @"CreatedDateRang":self.choosedTime,
                            @"State":self.choosedStatus,
                            @"GoDateStart":self.goDateStart,
                            @"GoDateEnd":self.goDateEnd,
                            @"FirstLevelArea":first,
                            @"SecondLevelAreaID":second,
                            @"ThirdLevelAreaID":third,
                            @"CreatedDateStart":self.createDateStart,
                            @"CreatedDateEnd":self.createDateEnd,
                            @"IsRefund":@"0",
                            @"InvoiceFlag":@"1"};
    [OrderTool getOrderListWithParam:param success:^(id json) {
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        if (json) {
            NSLog(@"---%@",json);
                if (self.isHeadRefresh) {
                    [self.InvoicedataArr removeAllObjects];
                }
                for (NSDictionary *dic in json[@"OrderList"]) {
                    OrderModel *order = [OrderModel orderModelWithDict:dic];
                    NSLog(@"%@",order.OrderId);
                    [self.InvoicedataArr addObject:order];
                }
            if (self.tableView.editing == YES) {
                [self.tableView reloadData];
            }
            NSLog(@"%@",self.InvoicedataArr);
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - private

//第一次开机引导
-(void)Guide
{
    self.guideView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _guideView.backgroundColor = [UIColor clearColor];
    self.guideImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_guideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)]];
    self.guideImageView.image = [UIImage imageNamed:@"orderSwipLeftGuide"];
    
    NSUserDefaults *guideDefault = [NSUserDefaults standardUserDefaults];
    [guideDefault setObject:@"1" forKey:@"orderGuide"];
    [guideDefault synchronize];
    
    [self.guideView addSubview:_guideImageView];
    [[[UIApplication sharedApplication].delegate window] addSubview:_guideView];
}
-(void)click
{
    CATransition *an1 = [CATransition animation];
    an1.type = @"rippleEffect";
    an1.subtype = kCATransitionFromRight;//用kcatransition的类别确定cube翻转方向
    an1.duration = 0.2;
    [self.guideImageView.layer addAnimation:an1 forKey:nil];    [self.guideView removeFromSuperview];
    NSLog(@"被店家－－－－－－－－－－－－－indexi is %d－－",_guideIndex);
    
}

- (void)setNullImage
{
    
    self.nullContentView.hidden = self.dataArr.count;
    if (!self.nullContentView.hidden) {
        self.isNUll = YES;
        [self.nullContentView setNullContentIsSearch:self.isSearch];
    }
}

- (NSInteger)getEndPage
{
    NSInteger cos = [self.totalCount integerValue] % pageSize;
    if (cos == 0) {
        return [self.totalCount integerValue] / pageSize;
    }else{
        return [self.totalCount integerValue] / pageSize + 1;
        
    }
}

// 自定义导航按钮
-(void)customRightBarItem
{
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
//    [button setImage:[UIImage imageNamed:@"APPsaixuan"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(selectAction)forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = barItem;
//    
//    UIButton * button1 = [[UIButton alloc]initWithFrame:CGRectMake(-30, -17, 65, 48)];
//    button1.backgroundColor = [UIColor redColor];
//    [button1 addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem.rightBarButtonItem.customView addSubview:button1];
        //筛选
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 22, 22)];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0,3,20,20)];
        button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"APPsaixuan"]];
        image.image = [UIImage imageNamed:@"APPsaixuan"];
        button.tag = 1100;
        [button addTarget:self action:@selector(selectAction:)forControlEvents:UIControlEventTouchUpInside];
        _barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        [button addSubview:image];
        
        [_barItem.customView addSubview:image];
        self.navigationItem.rightBarButtonItem = _barItem;
    

        if (self.FirstOpenNav == 6) {// 是否第一次打开app
            self.invoiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
            self.invoiceBtn.tag = 1200;
            [self.invoiceBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.invoiceBtn setTitle:@"开发票" forState:UIControlStateNormal];
            self.invoiceBtn.titleEdgeInsets = UIEdgeInsetsMake(3, -20, 0, 0);
            [self.invoiceBtn setImage:[UIImage imageNamed:@"hongdian"] forState:UIControlStateNormal];
            self.invoiceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.invoiceBtn setTitle:@"取消" forState:UIControlStateSelected];
            self.invoiceBtn.imageEdgeInsets = UIEdgeInsetsMake(-3, 47, 0, 0);
            _barItem2 = [[UIBarButtonItem alloc] initWithCustomView:self.invoiceBtn];
            self.navigationItem.leftBarButtonItem = _barItem2;
    

        }else{
            //开发票
            self.invoiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            self.invoiceBtn.tag = 1200;
            [self.invoiceBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.invoiceBtn setTitle:@"开发票" forState:UIControlStateNormal];
            self.invoiceBtn.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
            self.invoiceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.invoiceBtn setTitle:@"取消" forState:UIControlStateSelected];
            _barItem2 = [[UIBarButtonItem alloc] initWithCustomView:self.invoiceBtn];
            
            self.navigationItem.leftBarButtonItem = _barItem2;

        }
}


- (void)selectAction:(UIButton *)button
{
    if (button.tag == 1100) {//点击筛选
        UIView *cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dressTapHandle:)];
        tap.delegate = self;
        [cover addGestureRecognizer:tap];
        self.cover = cover;
        // 筛选视图
        [cover addSubview:self.dressView];
        [self.view.window addSubview:cover];
        [UIView animateWithDuration:0.3 animations:^{
            self.dressView.transform = CGAffineTransformMakeTranslation(- self.dressView.frame.size.width, 0);
        }];
    }else if(button.tag == 1200){//点击开发票
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
   
//        MySubscribeController *controller = [[MySubscribeController alloc] init];
//        [self.navigationController pushViewController:controller animated:YES];
        //下面是跳转的地方
        NSLog(@"----%ld",self.InvoicedataArr.count);
        [self.invoiceArr removeAllObjects];
        if (self.invoiceBtn.imageView.image != nil) {
            NSLog(@"检测到有图片");
            [self.invoiceBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        
        if (self.InvoicedataArr.count == 0) {
            NSLog(@"没有数据");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有可以开发票的订单" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
            [alert show];
        }else{

            NSUserDefaults *showAlert = [NSUserDefaults standardUserDefaults];
            NSString *orderGuide = [showAlert objectForKey:@"goAlertView"];
            if ([orderGuide integerValue] == 1) {
                [self notgoAlert];
            }else{
                if (self.invoiceBtn.selected == NO) {
                    UIAlertView *alertvie = [[UIAlertView alloc] initWithTitle:nil message:@"可对已经付全款（台湾产品除外）的非单团订单提交开发票申请，并可多张订单合并开票。" delegate:self cancelButtonTitle:@"不再提醒" otherButtonTitles: @"好的", nil];
                    alertvie.tag = 1001;
                    [alertvie show];
                }else{
                 [self notgoAlert];
                }
               
            }
        }
       
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"调用了");
    if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            NSUserDefaults *guideDefault = [NSUserDefaults standardUserDefaults];
            [guideDefault setObject:@"1" forKey:@"goAlertView"];
            [guideDefault synchronize];
            
            [self notgoAlert];
            
        }else{
            NSLog(@"直接取消");
            [self notgoAlert];
        }

    }
}
//不需要走警告框调用的方法
-(void)notgoAlert{
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"OrdersTackInvoiceClick" attributes:dict];
    
    if (self.invoiceBtn.selected == YES) {
        self.invoiceBtn.selected = NO;
        [self.tableView setEditing:NO animated:YES];
        if (self.isReloadMainTabaleView) {
            [self.tableView reloadData];
        }
        if ([[[UIApplication sharedApplication].delegate window] viewWithTag:110] != nil) {
            //改变tableview的frame
            UITableView *mytab = (UITableView *)[self.view viewWithTag:2020];
            mytab.frame = CGRectMake(0, 89, kScreenSize.width,kScreenSize.height-202);
            [[[[UIApplication sharedApplication].delegate window] viewWithTag:110] removeFromSuperview];
        }
    }else if(self.invoiceBtn.selected == NO){
        self.invoiceBtn.selected = YES;
        InvoiceLowView *InvoiceLow = [[[NSBundle mainBundle] loadNibNamed:@"InvoiceLowView" owner:self options:nil] lastObject];
        InvoiceLow.tag = 110;
        InvoiceLow.LowNav = self.navigationController;
        InvoiceLow.ViewCont = self;
        InvoiceLow.InvoiceAllBtn = YES;
        InvoiceLow.ord.InoicelowView = InvoiceLow;
        InvoiceLow.orderNumLabel.text = [NSString stringWithFormat:@"已经选择%ld张订单",InvoiceLow.ord.invoiceArr.count];
        InvoiceLow.frame = CGRectMake(0,kScreenSize.height-89,kScreenSize.width ,40);
        //改变tableview的frame
        UITableView *mytab = (UITableView *)[self.view viewWithTag:2020];
        mytab.frame = CGRectMake(0, 89, kScreenSize.width,kScreenSize.height-241);//202
        
        [[[UIApplication sharedApplication].delegate window] addSubview:InvoiceLow];
        
        [self.tableView setEditing:YES animated:YES];
        if (self.isReloadMainTabaleView) {
            [self.tableView reloadData];
        }
        
    }

}

//block改变tableview的frame
//-(void)ChangeFrame{
//    
////    CGFloat ppt = _tableView.frame.size.height;
////    self.bb = 1;
////    _tableView.frame = CGRectMake(0, 89, self.view.bounds.size.width, ppt - 100);
////    
//    //NSLog(@"---%f",self.tableView.frame.size.height);
//    NSLog(@"这里空了一个改变tableview的frame");
//}
// 去除筛选界面
- (void)dressTapHandle:(UITapGestureRecognizer *)ges
{
    [UIView animateWithDuration:0.3 animations:^{
        self.dressView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [ges.view removeFromSuperview];
        [_dressView removeFromSuperview];
        
        //当界面消失的时候弹出开发票的规则图片
//        [NSString showbackgroundgray];
//        //if (!self.invoiceAlert) {
//            self.invoiceAlert = [[[NSBundle mainBundle] loadNibNamed:@"InvoiceAlertView" owner:self options:nil] lastObject];
//            self.invoiceAlert.tag = 107;
//            self.invoiceAlert.AlertNav = self.navigationController;
//            self.invoiceAlert.layer.masksToBounds = YES;
//            self.invoiceAlert.layer.cornerRadius = 6.0;
//            self.invoiceAlert.frame = CGRectMake(60,kScreenSize.height/4,kScreenSize.width-120 ,150);
//            [[[UIApplication sharedApplication].delegate window] addSubview:self.invoiceAlert];
//            self.invoiceBtn.selected = YES;
//            [self.tableView setEditing:YES animated:YES];
        //}
     
        
    }];
}

-(void)iniHeader
{    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headRefresh) dateKey:nil];
    //上拉刷新
    [self.tableView addFooterWithTarget:self action:@selector(footRefresh)];
    //设置文字
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerRefreshingText = @"正在刷新中";
    
    self.tableView.footerPullToRefreshText = @"上拉刷新";
    self.tableView.footerRefreshingText = @"正在刷新";
}


-(void)headRefresh
{
    if (self.isNUll) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DressViewClickReset" object:nil];
        
        self.searchKeyWord = @"";
        self.searchBar.placeholder = searchDefaultPlaceholder;
        self.choosedTime = @"";
        self.choosedStatus = @"0";
        self.menuButton.rightBtn.text = @"全部";
        self.menuButton.leftBtn.text = @"不限";
        self.LselectedIndex = 0;
        self.RselectedIndex = 0;

    }
    self.pageIndex = 1;
    self.isHeadRefresh = YES;
    if (self.tableView.editing == YES) {
        [self loadDataSuorceByConditionInvoice];
    }else{
        [self loadDataSuorceByCondition];
    }
    
}
-(void)footRefresh
{
    self.pageIndex ++;
    self.isHeadRefresh = NO;
//    if (self.pageIndex < [self getEndPage]) {
//        [self loadDataSuorceByCondition];
//    }else{
//        [self.tableView footerEndRefreshing];
//    }

    if (self.pageIndex  > [self getEndPage]) {
        [self.tableView footerEndRefreshing];
    }else{
        if (self.tableView.editing == YES) {
            [self loadDataSuorceByConditionInvoice];
        }else{
            [self loadDataSuorceByCondition];
        }
    }
    
    
}

// 右边滑动的按钮
- (NSArray *)createRightButtons:(OrderModel *)model
{
    NSMutableArray * result = [NSMutableArray array];
    UIColor * color = [UIColor whiteColor];
    
    MGSwipeButton *button = [MGSwipeButton buttonWithTitle:nil icon:nil backgroundColor:color callback:^BOOL(MGSwipeTableCell * sender){
        NSLog(@"Convenience callback received (right).");
        return YES;
    }];
    CGRect frame = button.frame;
    frame.size.width = 230;
    button.frame = frame;
    [result addObject:button];
    button.enabled = YES;
    
    CantactView *contact = [[CantactView alloc] initWithFrame:button.frame];
    contact.userInteractionEnabled = YES;
    contact.model = model;
    
    [button addSubview:contact];
    
    return result;
}

/**
 *  创建菜单
 */
- (void)createMenuWithSelectedIndex:(NSInteger)SelectedIndex frame:(CGRect)frame dataSource:(NSMutableArray *)dataSource direct:(NSInteger)direct
{
    
    NSLog(@"fffff");
    self.qdmenu = [[QDMenu alloc] init];
    self.qdmenu.direct = direct;
    self.qdmenu.currentIndex = SelectedIndex;
    self.qdmenu.delegate = self;
    self.qdmenu.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    self.qdmenu.frame = frame;
    self.qdmenu.dataSource = dataSource;
    if (direct == 1) {
        self.qdmenu.layer.anchorPoint = CGPointMake(1, 0);
        UIImage *image = [UIImage imageNamed:@"bubble"];
        CGFloat w = image.size.width;
        CGFloat h = image.size.height;
        self.qdmenu.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(h * 0.5, w * 0.2, h * 0.5, w * 0.8)];
//        self.qdmenu.image = [UIImage resizedImageWithName:@"bubble" left:0.2 top:0.5];
    }
    [self.coverView addSubview:self.qdmenu];
    
    [self.view.window addSubview:self.coverView];
}

/**
 *  删除出现的列表
 */
- (void)removeMenu:(UITapGestureRecognizer *)ges
{
    NSLog(@"aaa");
    [self removeMenuFunc];
}

- (void)removeMenuFunc
{
    [_qdmenu removeFromSuperview];
    self.qdmenu = nil;
    self.qdmenu.delegate = nil;
    
    // 等待渐变动画执行完
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_coverView removeFromSuperview];
    });
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.cover || touch.view == self.coverView) {
        return YES;
    }
    return NO;
}

#pragma mark - getter
- (NullContentView *)nullContentView
{
    if (!_nullContentView) {
        _nullContentView = [[NullContentView alloc] init];
        CGFloat viewW = self.view.frame.size.width;
        CGFloat viewH = self.tableView.frame.size.height - 54 - 50;
        CGFloat viewY = 25;
        _nullContentView.frame = CGRectMake(0, viewY, viewW, viewH);
        _nullContentView.hidden = YES;
        [self.tableView addSubview:_nullContentView];
    }
    return _nullContentView;
}

- (MenuButton *)menuButton
{
    if (!_menuButton) {
        _menuButton = [[MenuButton alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 45)];
        _menuButton.delegate = self;
    }
    return _menuButton;
}

- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMenu:)];
        tap.delegate = self;
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

//点击查看客户详情信息的弹出框内容
- (DetailView *)detailView
{
    if (!_detailView) {
        _detailView = [[DetailView alloc] init];
        _detailView.center = self.view.window.center;
        _detailView.bounds = CGRectMake(0, 0, self.view.frame.size.width * 0.8, 272);
//        _detailView.backgroundColor = [UIColor yellowColor];
    }
    return _detailView;
}

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)InvoicedataArr{
    if (_InvoicedataArr == nil) {
        _InvoicedataArr = [[NSMutableArray alloc] init];
    }
    return _InvoicedataArr;
}
- (NSMutableArray *)chooseTime
{
    if (!_chooseTime) {
        _chooseTime = [NSMutableArray array];
    }
    return _chooseTime;
}

- (NSMutableArray *)chooseStatus
{
    if (!_chooseStatus) {
        _chooseStatus = [NSMutableArray array];
    }
    return _chooseStatus;
}
-(NSMutableArray *)invoiceArr{
    if (!_invoiceArr) {
        _invoiceArr = [NSMutableArray array];
    }
    return _invoiceArr;
}
- (NSMutableArray *)firstAreaData
{
    if (!_firstAreaData) {
        _firstAreaData = [NSMutableArray array];
    }
    return _firstAreaData;
}

- (DressView *)dressView
{
    if (!_dressView) {

        CGFloat W = self.view.frame.size.width * 0.8;
        _dressView = [[DressView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, W, self.view.window.bounds.size.height)];
        _dressView.delegate = self;
    }
    return _dressView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
         _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 89, self.view.frame.size.width, self.view.frame.size.height - 202) style:UITableViewStyleGrouped];
        _tableView.tag = 2020;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:238/255.0 alpha:1];
    }
    return _tableView;
}

- (SKSearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[SKSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
        _searchBar.delegate = self;
        _searchBar.barStyle = UISearchBarStyleDefault;
        _searchBar.translucent = NO;
        _searchBar.placeholder = searchDefaultPlaceholder;
        _searchBar.barTintColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    
    return _searchBar;
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

#pragma mark - MenuButtonDelegate
/**
 *  点击选择左菜单
 */
- (void)menuDidSelectLeftBtn:(UIButton *)leftBtn
{
    
    CGFloat menuX = self.view.frame.size.width * 0.25 - 30;
    CGRect frame = CGRectMake(menuX, 153, 135, 45 * 6);
    [self createMenuWithSelectedIndex:self.LselectedIndex frame:frame dataSource:self.chooseTime direct:0];
}

/**
 *  点击选择右菜单
 */
- (void)menuDidSelectRightBtn:(UIButton *)RightBtn
{
    CGFloat menuX = self.view.frame.size.width * 0.75 + 30;
    CGRect frame = CGRectMake(menuX, 153, 135, 45 * 7);
    [self createMenuWithSelectedIndex:self.RselectedIndex frame:frame dataSource:self.chooseStatus direct:1];
}

#pragma mark - QDMenuDelegate
- (void)menu:(QDMenu *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        self.isNUll = NO;
        if (menu.direct == 0) {// 时间筛选
        NSString *title = menu.dataSource[indexPath.row][@"Text"];
        self.menuButton.leftBtn.text = title;
        
        self.choosedTime = menu.dataSource[indexPath.row][@"Value"];
        [self removeMenuFunc];
        self.LselectedIndex = indexPath.row;
        [self.tableView headerBeginRefreshing];
    
       
    }else{// 状态筛选
         NSString *title = menu.dataSource[indexPath.row][@"Text"];
        self.menuButton.rightBtn.text = title;
        
        self.choosedStatus = menu.dataSource[indexPath.row][@"Value"];
        [self removeMenuFunc];
        self.RselectedIndex = indexPath.row;
        
        [self.tableView headerBeginRefreshing];
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.editing == YES) {
        return self.InvoicedataArr.count;
    }else{
        return self.dataArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell *cell = [OrderCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.orderDelegate = self;
    cell.indexPath = indexPath;
    NSLog(@"%f",cell.frame.size.height);
    OrderModel *order;//这只是一个bug ,后期还需要改进
    if (tableView.editing == YES) {
        order = self.InvoicedataArr[indexPath.section];
    }else{
        order = self.dataArr[indexPath.section];
    }
    // 取出模型
    //order = self.dataArr[indexPath.section];

    cell.model = order;
    
    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    cell.rightButtons = [self createRightButtons:order];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIButton *invoicebu = (UIButton *)[self.view viewWithTag:1200];
//    [invoicebu setImage:[UIImage imageNamed:@"hongdian"] forState:UIControlStateNormal];
//    invoicebu.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);

    if (self.tableView.editing == YES) {
        OrderModel *order = self.InvoicedataArr[indexPath.section];
        [self.invoiceArr addObject:order.OrderId];
        [self.InoicelowView reloadLowView:nil];
        NSLog(@"=======%ld----%@",self.invoiceArr.count,order.OrderId);
        
    }else if(self.tableView.editing == NO){
        NSLog(@"现在已经退出编辑模式");
        // 取出模型
        OrderModel *order = self.dataArr[indexPath.section];
        //    order.StateText订单状态 和 DetailLinkUrl进入详情界面的url
        NSLog(@"%@22%@", order.StateText, order.DetailLinkUrl);
        OrderDetailViewController *detail = [[OrderDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detail.url = order.DetailLinkUrl;
        NSLog(@"url = %@", order.DetailLinkUrl);
        detail.title = @"订单详情";
        [self.navigationController pushViewController:detail animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *order = self.InvoicedataArr[indexPath.section];
    [self.invoiceArr removeObject:order.OrderId];
     [self.InoicelowView reloadLowView:nil];
    NSLog(@"==%ld",self.invoiceArr.count);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *order;
    
    //if (self.tableView.editing) {
      //  order = self.invoiceArr[indexPath.section];
    //}else{
        order = self.dataArr[indexPath.section];
    //}
    if (order.buttonList.count) {
        return 202;
    }else{
        return 172;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - OrderCellDelegate
- (void)checkDetailAtIndex:(NSInteger)index
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIView *cover = [[UIView alloc] initWithFrame:window.bounds];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [window addSubview:cover];
    
    [cover addSubview:self.detailView];
//    [UIView animateWithDuration:0.5 animations:^{
//        _detailView.bounds = CGRectMake(0, 0, self.view.frame.size.width * 0.8, 272);
//     [button setBackgroundColor:[UIColor clearColor]];
//    } completion:^(BOOL finished) {
//        
//    }];

    // 取出模型
    OrderModel *order = self.dataArr[index];
//    self.detailView.data = order.SKBOrder;
    self.detailView.orderId = order.OrderId;

}

#pragma mark - MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction
{
    if (direction == MGSwipeDirectionRightToLeft) {
        return YES;
    }
    return NO;
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    return YES;
}

- (NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    return [NSArray array];
}
#warning 此处需要修改   下面两个方法
-(void)ClickAllBtn{
    NSLog(@"调用了");
    if(self.invoiceArr.count < self.InvoicedataArr.count){
        [self.invoiceArr removeAllObjects];
        for (NSInteger i = 0; i < self.InvoicedataArr.count;i++) {
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:i];
            OrderModel *order = self.InvoicedataArr[indexPath.section];
            [self.invoiceArr addObject:order.OrderId];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }

    }else{
        [self.invoiceArr removeAllObjects];
        [self.tableView reloadData];
    }
        [self.InoicelowView reloadLowView:nil];
}
#pragma mark - DressViewDelegate
- (void)wantToPushAreaWithType:(areaType)type
{
    AreaViewController *area = [[AreaViewController alloc] init];
    area.delegate = self;
    
    if (type == firstArea){
        // 选择大区
        self.cover.hidden = YES;
        area.type = firstArea;
        area.dataSource = self.firstAreaData;
        area.title = @"大区";
        area.chooseIndex = self.firstIndex;
        area.chooseDic = self.firstValue;
        [self.navigationController pushViewController:area animated:YES];
        
    }else if (type == secondArea){
        if (self.firstValue && ![self.firstValue[@"Value"] isEqualToString:@"0"]) {
            // 获取二级列表
            NSDictionary *param = @{@"FirstLevelArea":self.firstValue[@"Value"]};
            self.cover.hidden = YES;
            area.type = secondArea;
            area.param = param;
            area.title = @"线路区域";
            area.chooseIndex = self.secondIndex;
            area.chooseDic = self.secondValue;
            [self.navigationController pushViewController:area animated:YES];
        }
    }else{// 点击三级区域
        if (self.secondValue) {
            // 获取三级级列表
            NSDictionary *param = @{@"SecondLevelAreaID":self.secondValue[@"Value"]};
            self.cover.hidden = YES;
            area.type = thirdArea;
            area.param = param;
            area.title = @"国家/省份";
            area.chooseIndex = self.thirdIndex;
            area.chooseDic = self.thirdValue;
            [self.navigationController pushViewController:area animated:YES];
        }
    }
}

- (void)didSelectedTimeWithType:(timeType)type
{
    ChooseDayViewController *choose = [[ChooseDayViewController alloc] init];
    choose.type = type;
    choose.delegate = self;
    self.cover.hidden = YES;
    [self.navigationController pushViewController:choose animated:YES];
}

#pragma mark - ChooseDayViewControllerDelegate
- (void)finishChoosedTimeArr:(NSArray *)timeArr andType:(timeType)type
{
    self.cover.hidden = NO;
    if (type == timePick) {
        self.goDateStart = timeArr[0];
        self.goDateEnd = timeArr[1];
        self.dressView.goDateText = [NSString stringWithFormat:@"%@~%@",self.goDateStart,self.goDateEnd];
    }else{
        self.createDateStart = timeArr[0];
        self.createDateEnd = timeArr[1];
        self.dressView.createDateText = [NSString stringWithFormat:@"%@~%@",self.createDateStart,self.createDateEnd];
    }
    [self.dressView.tableView reloadData];
}

- (void)backToDress
{
    self.cover.hidden = NO;
}

#pragma mark - Notification
- (void)clickBack:(NSNotification *)noty
{
    [UIView animateWithDuration:0.3 animations:^{
        self.dressView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_dressView removeFromSuperview];
        [self.cover removeFromSuperview];
    }];
    
}

- (void)clickReset:(NSNotification *)noty
{
//    [self.firstAreaData removeAllObjects];
    self.firstValue = nil;
    self.secondValue = nil;
    self.thirdValue = nil;
    self.firstIndex = 0;
    self.goDateStart = @"";
    self.goDateEnd = @"";
    self.createDateStart = @"";
    self.createDateEnd = @"";
    
    self.dressView.firstText = nil;
    self.dressView.secondText = nil;
    self.dressView.thirdText = nil;
    self.dressView.goDateText = @"不限";
    self.dressView.createDateText = @"不限";
    [self.dressView.IsRefund setOn:NO animated:YES];
    [self.dressView.tableView reloadData];
}

- (void)clickConfirm:(NSNotification *)noty
{
    self.isNUll = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.dressView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [_dressView removeFromSuperview];
        [self.cover removeFromSuperview];
        [self.tableView headerBeginRefreshing];
    }];
}

- (void)orderCellDidClickButton:(NSNotification *)noty
{
    NSString *url = noty.userInfo[@"linkUrl"];
    NSString *title = noty.userInfo[@"title"];
    ButtonDetailViewController *detail = [[ButtonDetailViewController alloc] init];
    detail.linkUrl = url;
    detail.title = title;
    NSLog(@"detail.title = %@", detail.title);
    if ([detail.title isEqualToString:@"填写游客信息"]) {
        detail.isWriteVisitorsInfo = YES;
    }
    if ([title isEqualToString:@"订单催办"]) {
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"OrderListUrges" attributes:dict];

    }else if([title isEqualToString:@"提交游客信息"]){
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"OrderListSubmitVisitorInfo" attributes:dict];

    }else if([title isEqualToString:@"查看客户订单信息"]){
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"OrderListCheckOrderInfo" attributes:dict];

    }else if([title isEqualToString:@"立即采购"]){
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"OrderListPurchasAtOnce" attributes:dict];

    }else if([title isEqualToString:@"付款"]){
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"OrderListPayFor" attributes:dict];

    }
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)historySearch:(NSNotification *)noty
{
    self.searchKeyWord = noty.userInfo[@"historykey"];
    [self.searchDisplayController setActive:NO animated:YES];
    [self.tableView headerBeginRefreshing];
}

#pragma mark - AreaViewControllerDelegate
// 选择之后把值返回过来
- (void)didSelectAreaWithValue:(NSDictionary *)value Type:(areaType)type atIndex:(NSInteger)index isSelected:(BOOL)isSelected
{
    if (type == firstArea) {
        self.firstValue = value;
        self.dressView.firstText = value[@"Text"];
        self.firstIndex = index;
        
        // 每次选过大区都要清空一次
        self.secondValue = nil;
        self.thirdValue = nil;
        self.dressView.secondText = nil;
        self.dressView.thirdText = nil;
        
    }else if(type == secondArea){
        self.secondValue = value;
        self.dressView.secondText = value[@"Text"];
        self.secondIndex = index;
    }else{
        self.thirdValue = value;
        self.dressView.thirdText = value[@"Text"];
        self.thirdIndex = index;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.hidden = NO;
    }];
    
    // 如果有选择过再刷新
    if (isSelected) {
        [self.dressView.tableView reloadData];
    }
    
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

// 这个方法里面纯粹调样式
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    for (UIView *searchbuttons in [[searchBar.subviews objectAtIndex:0] subviews])
    {
        if ([searchbuttons isKindOfClass:[UIButton class]])
        {
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *trimStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.searchKeyWord = trimStr;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"OrderSearchClick" attributes:dict];

    
      [self.searchDisplayController setActive:NO animated:YES];
    
    if (self.searchKeyWord.length) {
        [searchBar endEditing:YES];
        
        NSMutableArray *tmp = [NSMutableArray array];
        
        // 先取出原来的记录
        NSArray *arr = [WriteFileManager readFielWithName:@"historysearch"];
        [tmp addObjectsFromArray:arr];
        
        // 再加上新的搜索记录
        [tmp addObject:self.searchKeyWord];
        
        // 判断超出了6个的话把最早的去掉
        if (tmp.count > historyCount) {
            [tmp removeObjectAtIndex:0];
        }
        // 并保存
        [WriteFileManager saveFileWithArray:tmp Name:@"historysearch"];
        
        [self.tableView headerBeginRefreshing];
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
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
//        [UIView animateWithDuration:0.25 animations:^{
//            for (UIView *subview in self.view.subviews)
//                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
//        }];
//    }
    
    // 纯粹调节样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
     self.searchBar.barTintColor = [UIColor whiteColor];
    
    // 历史记录的界面
    HistoryView *historyView = [[HistoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height + 49)];
    historyView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    [self.view.window addSubview:historyView];
    self.historyView = historyView;
    
    self.searchBar.placeholder = searchDefaultPlaceholder;
    self.searchBar.text = self.searchKeyWord;
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    //        [UIView animateWithDuration:0.25 animations:^{
    //            for (UIView *subview in self.view.subviews)
    //                subview.transform = CGAffineTransformIdentity;
    //        }];
    //    }
    NSLog(@"%f--%d",self.sep2.frame.origin.y,self.navigationController.navigationBarHidden);
    [self.sep2 removeFromSuperview];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.searchBar.barTintColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    
    [self.historyView removeFromSuperview];
    
    if (self.searchKeyWord.length){
        self.searchBar.placeholder = self.searchKeyWord;
    }else{
        self.searchBar.placeholder = searchDefaultPlaceholder;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.tableView.editing) {
        self.invoiceBtn.selected = NO;
        [self.tableView setEditing:NO animated:YES];
    }
    if ([[[UIApplication sharedApplication].delegate window] viewWithTag:110] != nil) {
        [[[[UIApplication sharedApplication].delegate window] viewWithTag:110] removeFromSuperview];
    }
}
// 眼神好的人测试 就需要这个代码了~~ 哈哈哈
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.hidden = YES;
}






@end
