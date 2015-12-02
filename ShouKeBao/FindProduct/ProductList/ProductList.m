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
#import "WriteFileManager.h"
#import "UIImageView+LBBlurredImage.h"
#import "ChooseDayViewController.h"
#import "MobClick.h"
#import "ShaiXuanViewController.h"
#import "BaseClickAttribute.h"

#import <ShareSDK/ShareSDK.h>
#import "SwipeView.h"
#import "ShareView.h"

#define kScreenSize [UIScreen mainScreen].bounds.size
@interface ProductList ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate,passValue,passSearchKey,UITextFieldDelegate,passThePrice,ChooseDayViewControllerDelegate>
{
    ShaiXuanViewController *ShaiXuan;
    //定时器
    NSTimer *_timer;
}
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

@property (weak, nonatomic) IBOutlet UIButton *backToTopBtn;
- (IBAction)backToTop:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *pageCountBtn;
@property (weak, nonatomic) IBOutlet UIView *gaosimohuView;
@property (nonatomic, strong) UIButton *pageCountBtn;
@property (nonatomic) BOOL isAnimation;
@property (nonatomic,assign)  CGFloat oldOffset;
@property (nonatomic)NSInteger primaryNu;//传过来的价格区间预选值

//@property (weak, nonatomic) IBOutlet UIView *blackView;

//@property (copy , nonatomic) NSMutableString *ProductSortingType;//推荐:”0",利润（从低往高）:”1"利润（从高往低:”2"
//同行价（从低往高）:”3,同行价（从高往低）:"4"
- (void)recommond;
- (void)profits:(NSInteger)sender;
- (void)cheapPrice:(NSInteger)sender;
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
@property(copy,nonatomic) NSMutableString *goDateStart;
@property(copy,nonatomic) NSMutableString *goDateEnd;

@property (weak, nonatomic) IBOutlet UIView *subSubView;
@property (weak,nonatomic) UIView *coverView;

@property (nonatomic,strong) UIView *guideView;
@property (nonatomic,strong) UIImageView *guideImageView;
@property (nonatomic,assign) int guideIndex;
@property(nonatomic,copy) NSMutableString *month;

@property (weak, nonatomic) IBOutlet UIView *noProductView;


@property(weak,nonatomic) UILabel *noProductWarnLab;

@property(nonatomic,assign) BOOL subDoneToFreshCommendBtn;

@property(nonatomic,assign) long productCount;

@property(nonatomic,copy) NSMutableString *selectIndex;
//产品筛选
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
//筛选界面 的滑轮数据
@property (strong, nonatomic) IBOutlet UIButton *paixuBtn;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (nonatomic)NSDictionary *siftDic;

//产品筛选
- (IBAction)chooseConditions:(id)sender;
//顺序tableView和顺序点击按钮
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
//产品排序
- (IBAction)listButton:(id)sender;
//产品分享
- (IBAction)sharebutton:(id)sender;


@property (copy, nonatomic)NSArray *listArray;
@property (strong, nonatomic) UIView *shadeView;
@property (nonatomic, assign)BOOL flag;
@property (nonatomic, assign)BOOL shareFlag;
@property (nonatomic, assign)NSInteger zzm;
@property (nonatomic, strong)NSMutableDictionary * shareInfo;

@end

@implementation ProductList
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ShaiXuan = [[ShaiXuanViewController alloc] init];
    //判断能否执行动画
    self.isAnimation = NO;
    [self initPull];
    [self editButtons];
    //    [self customRightBarItem];
    //筛选界面返回调用刷新传值
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"refresh"
                                               object:nil];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.subTable.delegate = self;
    self.subTable.dataSource = self;
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listArray = @[@"推荐", @"利润从高到低", @"利润从低到高", @"同行价从高到低", @"同行价从低到高"];
    self.conditionDic = [[NSMutableDictionary alloc] init];
    self.page = [NSMutableString stringWithFormat:@"1"];

    self.pageCountBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.pageCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.pageCountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.pageCountBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    //self.pageCountBtn.titleEdgeInsets = UIEdgeInsetsMake(-10, 7, 0, 0);
    self.pageCountBtn.userInteractionEnabled = NO;
    //self.pageCountBtn.frame = CGRectMake(0,self.backToTopBtn.frame.size.height*2/3, self.backToTopBtn.frame.size.width, self.backToTopBtn.frame.size.height/3);
    self.pageCountBtn.frame = CGRectMake(0,self.backToTopBtn.frame.size.height/2+3, self.backToTopBtn.frame.size.width, self.backToTopBtn.frame.size.height/3);
    [self.backToTopBtn setImage:[UIImage imageNamed:@"shangjiana"] forState:UIControlStateNormal];
    [self.backToTopBtn addSubview:self.pageCountBtn];
    
    [self.commondOutlet setSelected:YES];
    
    [self.profitOutlet setTitle:@"利润 ↑" forState:UIControlStateNormal ];
    [self.cheapOutlet setTitle:@"同行价 ↑" forState:UIControlStateNormal ];
    self.subTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.subDataArr1 = [NSArray arrayWithObjects:@"目的地      ",@"出发城市      ",@"出发日期      ",@"行程天数      ",@"游览线路      ",@"供应商      ", nil];//6
    self.subDataArr2 = [NSArray arrayWithObjects:@"主题推荐      ",@"酒店类型      ",@"出行方式      ",@"邮轮公司      ", nil];//4
    //self.subDataArr1 = @[@"目的地      ",@"出发城市      ",@"出发日期      ",@"行程天数      ",@"游览线路      ",@"供应商      ",@"主题推荐      ",@"酒店类型      ",@"出行方式      ",@"邮轮公司      "];
    self.subIndicateDataArr1 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ",@" ", nil];
    self.subIndicateDataArr2 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ", nil];
    self.turn = [NSMutableString stringWithFormat:@"Off"];
    
    //高斯模糊效果
    //    UIImageView *gsimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+60, self.view.bounds.size.width, 80)];
    //    gsimageView.image = [UIImage imageNamed:@"gaosimohu"];
    //    gsimageView.alpha = 0.8;
    //    gsimageView.contentMode = UIViewContentModeScaleAspectFill;
    //    [gsimageView setImageToBlur:[UIImage imageNamed:@"gaosimohuc"] blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
    
    //[self.view addSubview:gsimageView];
    //[self.view addSubview:self.chooseButton];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*titleWid, 34)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];//215 237 244
    btn.frame = CGRectMake(0, 0, self.view.frame.size.width*titleWid, 34);
    [btn setBackgroundImage:[UIImage imageNamed:@"sousuoBackView"] forState:UIControlStateNormal];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"fdjBtn"] forState:UIControlStateNormal];
    
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
    
    self.navigationItem.titleView = titleView;
    
    SearchProductViewController *searchVC = [[SearchProductViewController alloc] init];
    
    searchVC.delegate = self;
    
    //    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
    //    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    //    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //
    //    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    //
    //    self.navigationItem.leftBarButtonItem= leftItem;
    self.navigationItem.leftBarButtonItem = leftItem;
    NSUserDefaults *guideDefault = [NSUserDefaults standardUserDefaults];
    NSString *productListGuide = [guideDefault objectForKey:@"productListGuide"];
    //    if ([productListGuide integerValue] != 1) {// 是否第一次打开app
    //        [self Guide];
    //    }
    // [self Guide];
    
}
- (void)receiveNotification:(NSNotification *)noti
{
    //    NSLog(@"noti.object.Name = %@, %@", [noti.object valueForKey:@"Name"], [noti.object valueForKey:@"Mobile"]);
    self.primaryNu = noti.object;
    NSLog(@"%@",noti.object);
    self.conditionDic = (NSMutableDictionary *)noti.userInfo;
    NSLog(@"%@",self.conditionDic);
    //NSLog(@"%@",self.primaryNu);
    [self initPull];
    
}
#pragma -mark VClife
//    //高斯模糊效果
//    [super viewDidAppear:animated];
//    UIImageView *gsimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-70, self.view.bounds.size.width, 70)];
//    gsimageView.image = [UIImage imageNamed:@"ip6"];
//    [gsimageView setImageToBlur:[UIImage imageNamed:@"gaosimohu"] blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:^(NSError *error) {
//        NSLog(@"高斯模糊实现错误－－error:%@",error);
//    }];
//    
//    [self.view addSubview:gsimageView];
-(void)viewWillAppear:(BOOL)animated
{  [super viewWillAppear:animated];
    NSIndexPath *selected = [self.subTable indexPathForSelectedRow];
    if(selected) [self.subTable deselectRowAtIndexPath:selected animated:NO];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:175/255.f green:175/255.f blue:175/255.f alpha:1];
    self.table.tableFooterView = line;
    
    // [self loadDataSource];
}

//停止滚动的时候调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"停止滚动");
    /*//首尾式动画
     31     [UIView beginAnimations:nil context:nil];
     32     //执行动画
     33     //设置动画执行时间
     34     [UIView setAnimationDuration:2.0];
     35     //设置代理
     36     [UIView setAnimationDelegate:self];
     37     //设置动画执行完毕调用的事件
     38     [UIView setAnimationDidStopSelector:@selector(didStopAnimation)];
     39     self.customView.center=CGPointMake(200, 300);
     40     [UIView commitAnimations];*/
    if (_timer) {
        [_timer invalidate];//销毁
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
   // [_timer invalidate];
}
-(void)timerClick{
    NSLog(@"3秒了");
    if (self.isAnimation) {
        [UIView animateWithDuration:0.6 animations:^{
//            CGPoint gaosi = self.gaosimohuView.center;
//            CGPoint choose = self.chooseButton.center;
            
            //gaosi.y = kScreenSize.height-self.gaosimohuView.frame.size.height/2;
            //NSLog(@"%f",gaosi.y);
            //choose.y = kScreenSize.height-self.chooseButton.frame.size.height/2;
            //NSLog(@"%f",choose.y);
//            gaosi.y -=60;
            //NSLog(@"%f,%f,%f",self.chooseButton.bounds.size.height,self.chooseButton.alpha,gaosi.y);
            
//            choose.y -= 60;
//            self.gaosimohuView.center = gaosi;
//            self.chooseButton.center = choose;
//            NSLog(@"%f---%f",gaosi.y,choose.y);
        } completion:^(BOOL finished) {
            NSLog(@"执行动画完毕");
        }];
        self.isAnimation = NO;
    }
   
    [_timer invalidate];
}
-(void)targetMethod{
    //self.chooseButton.alpha = 1;
    self.isAnimation = NO;
}
-(void)targetMethod2{
 self.isAnimation = NO;
   // self.gaosimohuView.alpha = 0.8;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma -mark private
//第一次开机引导
-(void)Guide
{
    self.guideView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _guideView.backgroundColor = [UIColor clearColor];
    self.guideImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_guideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)]];
    self.guideImageView.image = [UIImage imageNamed:@"detail1"];
    
    NSUserDefaults *guideDefault = [NSUserDefaults standardUserDefaults];
    [guideDefault setObject:@"1" forKey:@"productListGuide"];
    [guideDefault synchronize];
    [self.guideView addSubview:_guideImageView];
    [[[UIApplication sharedApplication].delegate window] addSubview:_guideView];
}
-(void)click
{
    self.guideIndex++;
    NSString *str = [NSString stringWithFormat:@"detail%d",self.guideIndex+1];
    self.guideImageView.image = [UIImage imageNamed:str];
    
    CATransition *an1 = [CATransition animation];
    an1.type = @"rippleEffect";
    an1.subtype = kCATransitionFromRight;//用kcatransition的类别确定cube翻转方向
    an1.duration = 0.4;
    [self.guideImageView.layer addAnimation:an1 forKey:nil];
    
    if (self.guideIndex == 2) {
        [self.guideView removeFromSuperview];
    }
    NSLog(@"被店家－－－－－－－－－－－－－indexi is %d－－",_guideIndex);
}
-(void)back
{
    [self refereshSelectData];
    [self.pushedArr removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refereshSelectData
{
    NSArray *priceData = [NSArray arrayWithObject:@"价格区间"];
    [WriteFileManager saveData:priceData name:@"priceData"];
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@{@"123":@"456"} ,nil];
    [WriteFileManager WMsaveData:arr name:@"conditionSelect"];
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
#pragma  -mark getter
-(UIView *)subView
{
    if (_subView == nil) {
        self.subView = [[[NSBundle mainBundle] loadNibNamed:@"ProductList" owner:self options:nil] lastObject];
        //self.subTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 71, self.view.bounds.size.width, self.view.bounds.size.height-71)];
        //[self.subView addSubview:self.subTable];

    }
    return _subView;
}
- (NSArray *)listArray
{
    if (_listArray == nil) {
        self.listArray = [NSArray array];
    }
    return _listArray;
}

-(NSMutableString *)jishi
{
    if (_jishi == nil) {
        self.jishi = [NSMutableString stringWithFormat:@"0"];
    }
    return _jishi
    ;
}
-(void)changeJishi
{
    if (_jishi && self.jishiSwitch.on == YES){
        self.jishi = [NSMutableString stringWithFormat:@"1"];
    }else if (_jishi && self.jishiSwitch.on == NO){
        self.jishi = [NSMutableString stringWithFormat:@"0"];
    }
}
-(void)changeJiaFan
{
    if (_jiafan && self.jiafanSwitch.on == YES){
        self.jiafan = [NSMutableString stringWithFormat:@"1"];
        
    }else if (_jiafan && self.jiafanSwitch.on == NO){
        self.jiafan = [NSMutableString stringWithFormat:@"0"];
    }
}

-(NSMutableString *)jiafan
{
    if (_jiafan == nil) {
        
        self.jiafan = [NSMutableString stringWithFormat:@"0"];
    }
    return _jiafan;
}
-(NSDictionary *)siftDic{
    if (_siftDic == nil) {
        self.siftDic = [[NSDictionary alloc] init];
    }
    return _siftDic;
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

- (NSMutableDictionary *)shareInfo{
    if (!_shareInfo) {
        self.shareInfo = [NSMutableDictionary dictionary];
    }
    return _shareInfo;
}
#pragma - mark stationSelect delegate
-(void)passStation:(NSString *)stationName andStationNum:(NSNumber *)stationNum
{
    
}
-(void)passSearchKeyFromSearchVC:(NSString *)searchKey
{
    self.pushedSearchK = [NSMutableString stringWithFormat:@"%@",searchKey];
}

-(void)clickPush
{
    //    NSDictionary *dic = [NSDictionary dictionary];
    //    dic = [_pushedArr firstObject];
    //    if ([dic[@"Text"] isEqualToString:@"暂无"]) {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }else{
    //        [self.navigationController pushViewController:[[SearchProductViewController alloc] init] animated:NO];
    //    }
    if (_isFromSearch == YES) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        SearchProductViewController * SPVC = [[SearchProductViewController alloc] init];
        SPVC.isFromFindProduct = NO;
        [self.navigationController pushViewController:SPVC animated:NO];
    }
}


#pragma  mark - conditionDetail delegate//key 指大字典的key value指字典中某一子value的值
-(void)passKey:(NSString *)key andValue:(NSString *)value andSelectIndexPath:(NSArray *)selectIndexPath andSelectValue:(NSString *)selectValue
{
    //确认列表选择值
    // self.conditionDic = [NSMutableDictionary dictionary];
    if (value) {
        [self.conditionDic setObject:value forKey:key];
        
        NSLog(@"-------------传过来的key is %@------------",key);
        if ([selectIndexPath[0]isEqualToString:@"0"]) {
            
            NSInteger a = [selectIndexPath[1] integerValue];//分析selected IndexPath.row的值
            
            self.subIndicateDataArr1[a] = selectValue;
            
        }else if ([selectIndexPath[0] isEqualToString:@"1"]){
            
            NSInteger a = [selectIndexPath[1] integerValue];
            
            self.subIndicateDataArr2[a] = selectValue;
        }
        self.subView.hidden = NO;
        NSLog(@"subindicateArr 1 :------------%@------------- 2:%@--------------- ",_subIndicateDataArr1,_subIndicateDataArr2);
        [self.subTable reloadData];
        //[self loadDataSourceWithCondition];
        
    }else if (!value){
        self.subView.hidden = NO;
    }
    NSLog(@"-----------conditionDic is %@--------",self.conditionDic);
}


#pragma  mark -priceDelegate
-(void)passTheMinPrice:(NSString *)min AndMaxPrice:(NSString *)max
{
    NSLog(@"价格筛选--------%@------------%@------",min,max);
    self.subView.hidden = NO;
    if (![max  isEqual: @""]) {
        [self.conditionDic setObject:min forKey:@"MinPrice"];
        [self.conditionDic setObject:max forKey:@"MaxPrice"];
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"价格区间：%@元－%@元",min,max]];
        
        [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(5, attriString.length - 5)];
        [self.priceBtnOutlet setAttributedTitle:attriString forState:UIControlStateNormal];
        
        NSArray *priceData = [NSArray arrayWithObjects:min,max,self.priceBtnOutlet.titleLabel.text ,nil];
        [WriteFileManager saveData:priceData name:@"priceData"];
        
    }else if ([max isEqualToString:@"0"]){
        
        [self.priceBtnOutlet setTitle:@"价格区间" forState:UIControlStateNormal];
        [self.conditionDic setObject:@"" forKey:@"MinPrice"];
        [self.conditionDic setObject:@"" forKey:@"MaxPrice"];
        
    }else if ([max  isEqual: @""]){
        
        [self.priceBtnOutlet setTitle:@"价格区间" forState:UIControlStateNormal];
        [self.conditionDic setObject:@"" forKey:@"MinPrice"];
        [self.conditionDic setObject:@"" forKey:@"MaxPrice"];
    }
}

#pragma mark - ChooseDayViewControllerDelegate
- (void)finishChoosedTimeArr:(NSArray *)timeArr andType:(timeType)type
{
    self.subView.hidden = NO;
    if (type == timePick) {
        self.goDateStart = timeArr[0];
        self.goDateEnd = timeArr[1];
        // self.dressView.goDateText = [NSString stringWithFormat:@"%@~%@",self.goDateStart,self.goDateEnd];
    }else{
        self.goDateStart = timeArr[0];
        self.goDateEnd = timeArr[1];
        // self.createDateStart = timeArr[0];
        // self.createDateEnd = timeArr[1];
        // self.dressView.createDateText = [NSString stringWithFormat:@"%@~%@",self.createDateStart,self.createDateEnd];
    }
    [self.conditionDic setObject:_goDateStart forKey:@"StartDate"];
    [self.conditionDic setObject:_goDateEnd forKey:@"EndDate"];
    [self.subTable reloadData];
}
- (void)backToDress
{
    self.subView.hidden = NO;
}

-(void)passTheButtonValue:(NSString *)value andName:(NSString *)name
{
    self.subView.hidden = NO;
    [self.conditionDic setObject:value forKey:@"GoDate"];
    self.month = [NSMutableString stringWithFormat:@"%@",name];
    NSLog(@"-----------------productList 获得的name is %@ value is %@",name,value);
    [self.subTable reloadData];
}

-(void)initPull
{
    //上啦刷新
    [self.table addFooterWithTarget:self action:@selector(footLoad)];
    //设置文字
    self.table.footerPullToRefreshText = @"加载更多";
    self.table.footerRefreshingText = @"正在刷新";
    //下拉
    [self.table addHeaderWithTarget:self action:@selector(headerPull)];
    [self.table headerBeginRefreshing];
    
    self.table.headerPullToRefreshText =@"刷新内容";
    self.table.headerRefreshingText = @"正在刷新";
}

//-(void)initConditionPull
//{
//    //上啦刷新
//    [self.dataArr removeAllObjects];
//    [self.table addFooterWithTarget:self action:@selector(loadDataSourceWithCondition)];
//    //设置文字
//    self.table.footerPullToRefreshText = @"更新列表";
//    self.table.footerRefreshingText = @"正在刷新";
//}



#pragma  -mark 下来刷新数据
-(void)headerPull
{
    [self loadDataSource];
}



#pragma footView - delegate上拉加载更多
-(void)footLoad
{//推荐:”0",利润（从低往高）:”1"利润（从高往低:”2"
    //同行价（从低往高）:”3,同行价（从高往低）:"4"
    [self.noProductWarnLab removeFromSuperview];
    [self editButtons ];
    NSString *type = [NSString string];
    
    if (_selectIndex == nil) {
        self.selectIndex = [NSMutableString stringWithFormat:@"0"];
        type = [NSString stringWithFormat:@"%@",_selectIndex];
    }else{
        type = [NSString stringWithFormat:@"%@",_selectIndex];
    }
    
    if ([type isEqualToString:@"0"]) {
        [self.commondOutlet setSelected:YES];
    }
    if ( [type isEqualToString:@"1"]) {
        
        [self.profitOutlet setSelected:YES];
        [self.profitOutlet setTitle:@"利润 ↑" forState:UIControlStateNormal];
        
    }else if (    [type isEqualToString: @"2"]){
        [self.profitOutlet setSelected: YES];
        [self.profitOutlet setTitle: @"利润 ↓" forState:UIControlStateNormal];
    }
    if ( [type isEqualToString: @"3"]) {
        
        [self.cheapOutlet setSelected: YES];
        [self.cheapOutlet setTitle:@"同行价 ↑" forState:UIControlStateNormal ];
    }else if ([type isEqualToString: @"4"])
    {
        
        [self.cheapOutlet setSelected: YES];
        [self.cheapOutlet setTitle:@"同行价 ↓" forState:UIControlStateNormal ];
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   
    //  [dic setObject:@"10" forKey:@"Substation"];
    [dic setObject:@"10" forKey:@"PageSize"];
    [dic setObject:self.pushedSearchK forKey:@"SearchKey"];
    [dic setObject:_page forKey:@"PageIndex"];
    [dic setObject:type forKey:@"ProductSortingType"];
    [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
    [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];
    NSLog(@"%@", self.conditionDic);
    [dic addEntriesFromDictionary:[self conditionDic]];//增加筛选条件
    NSLog(@"-----------------footLoad 请求的 dic  is %@-----------------",dic);
    [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
        NSLog(@"----------footLoad返回json is %@--------------",json);
        NSArray *arr = json[@"ProductList"];
        if (arr.count == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, 20)];
            label.text = @"抱歉，没有更多产品了😢";
            label.textColor = [UIColor orangeColor];
            label.textAlignment = NSTextAlignmentCenter;
            
            self.table.tableFooterView = label;
            self.noProductWarnLab = label;
        }else if (arr.count>0){
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

- (IBAction)chooseConditions:(id)sender {
    if (self.flag ) {
        [self close];
    }
    [self setBtnStateWith:1];

    if (self.shareFlag) {
        [ShareView cancleBtnClick];
        self.shareFlag = !self.shareFlag;
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ShaiXuan];
    if (self.dataArr.count > 1) {
        if (self.conditionDic.count != 0) {
            
            ShaiXuan.MinPricecondition = self.conditionDic[@"MinPrice"];
            ShaiXuan.MaxPricecondition = self.conditionDic[@"MaxPrice"];
            //ShaiXuan.primaryNum = self.primaryNu;
        }
        ShaiXuan.siftHLDic = self.siftDic;
        [self presentViewController:nav animated:YES completion:nil];
        [self setBtnStateWith:0];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"当前没有可供筛选的条件" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
    }
    
        
    //[self setSubViewHideNo];
//        CATransition *transition = [CATransition animation];
//        [transition setDuration:0.5];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromTop;
//        [transition setFillMode:kCAFillModeBoth];
//        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        [self.subView.layer addAnimation:transition forKey:nil];

//    }];
  
    
//  [UIView animateWithDuration:1 delay:0.0 options:0 animations:^{
//      [self.subView setFrame:CGRectMake(0, 0, 375, 667)];
//  } completion:^(BOOL finished) {
//      [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
////          [self.subView setFrame:CGRectMake(0, 0, 320, 0)];
//      } completion:^(BOOL finished) {
//           [self setSubViewHideNo];
//          
//      }];
//  }];
   
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
    //推荐:”0",利润（从低往高）:”1"利润（从高往低:”2"
    //同行价（从低往高）:”3,同行价（从高往低）:"4"
    [self editButtons];
    [self.noProductWarnLab removeFromSuperview];
    self.table.tableFooterView = nil;
    self.table.tableFooterView.hidden = YES;
    
    NSString *type = [NSString string];
    if (_selectIndex == nil) {
        self.selectIndex = [NSMutableString stringWithFormat:@"0"];
        type = [NSString stringWithFormat:@"%@",_selectIndex];
    }else{
        type = [NSString stringWithFormat:@"%@",_selectIndex];
    }
    
    if ([type isEqualToString:@"0"]) {
        [self.commondOutlet setSelected:YES];
    }
    if ( [type isEqualToString:@"1"]) {
        
        [self.profitOutlet setSelected:YES];
        [self.profitOutlet setTitle:@"利润 ↑" forState:UIControlStateNormal];
        
    }else if (    [type isEqualToString: @"2"]){
        [self.profitOutlet setSelected: YES];
        [self.profitOutlet setTitle: @"利润 ↓" forState:UIControlStateNormal];
    }
    if ( [type isEqualToString: @"3"]) {
        
        [self.cheapOutlet setSelected: YES];
        [self.cheapOutlet setTitle:@"同行价 ↑" forState:UIControlStateNormal ];
    }else if ([type isEqualToString: @"4"])
    {
        
        [self.cheapOutlet setSelected: YES];
        [self.cheapOutlet setTitle:@"同行价 ↓" forState:UIControlStateNormal ];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    self.page = [NSMutableString stringWithFormat:@"1"];
    //  [dic setObject:@"10" forKey:@"Substation"];
    [dic setObject:@"10" forKey:@"PageSize"];
    [dic setObject:@1 forKey:@"PageIndex"];
    [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
    [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];
    
    [dic setObject:_pushedSearchK forKey:@"SearchKey"];
    [dic setObject:type forKey:@"ProductSortingType"];
    [dic setObject:[NSString stringWithFormat:@"%d",self.productListFrom+1] forKey:@"SearchSource"];
    NSLog(@"%d", self.productListFrom+1);
    NSLog(@"SearchSource = %@",dic[@"SearchSource"]);
    [dic addEntriesFromDictionary:self.conditionDic];//增加筛选条件
    
    NSLog(@"%@",dic);
    NSLog(@"--------------productList load dic  is %@--------------",[StrToDic jsonStringWithDicL:dic] );
    [IWHttpTool WMpostWithURL:@"Product/GetProductList_V2" params:dic success:^(id json) {
        
       NSLog(@"--------------productList load json is   %@------------]",json);
        self.shareInfo = json[@"ShareInfo"];
        
        NSArray *arr = json[@"ProductList"];
        [self.dataArr removeAllObjects];
        NSLog(@"arr = %@", arr);
        if (arr.count==0) {
            self.noProductView.hidden = NO;
            [self.pageCountBtn setTitle:@"没有产品" forState:UIControlStateNormal];
            self.cheapOutlet.userInteractionEnabled = NO;
            self.profitOutlet.userInteractionEnabled = NO;
            self.commondOutlet.userInteractionEnabled = NO;
            
        }else if (arr.count>0){
            //self.table.tableFooterView.hidden = YES;
            self.noProductView.hidden = YES;
            for (NSDictionary *dic in json[@"ProductList"]) {
                ProductModal *modal = [ProductModal modalWithDict:dic];
                [self.dataArr addObject:modal];
            }
            NSString *str = json[@"TotalCount"];
            self.productCount = [str integerValue];
        }
        
        NSMutableArray *conArr = [NSMutableArray array];
//        if (!_isFromSearch && arr.count>0){//走正常进入，需要从找产品取出三级条件
//            NSDictionary *dicNew = [NSDictionary dictionaryWithObject:_pushedArr forKey:@"destination"];
//            [conArr addObject:dicNew];
//            for(NSDictionary *dic in json[@"ProductConditionList"] ){
//                [conArr addObject:dic];
//            }
//            
//        }else if(_isFromSearch && arr.count>0){
            //走搜索进入，后台直接提供目的地，不过位置被放最后一位，一下操作便是调整位置

//************** ??????没明白这段代码啥意思 注掉不影响信息也不崩了
//            for(NSDictionary *dic in json[@"ProductConditionList"] ){
//                [conArr addObject:dic];
//            }
//            NSDictionary *dic2 = [conArr lastObject];//取出被小宝放在最后面的destination
//            [conArr removeAllObjects];
//            [conArr addObject:dic2];//将destination加在头部
//      
        
            for(NSDictionary *dic in json[@"ProductConditionList"] ){
                [conArr addObject:dic];
            }//将其余的条件添加进来
        self.siftDic = json[@"ProductCondition"];
//        }
        
        [self.conditionArr removeAllObjects];
        self.conditionArr = conArr;//装载筛选条件数据
        ShaiXuan.conditionArr =self.conditionArr;
        NSLog(@"_+++%@",ShaiXuan.conditionArr);
        //NSLog(@"________ dic2 = , dic = %@",  dic),
        //NSLog(@"---------!!!!!!dataArr is %@!!!!!! conditionArr is %@------",_dataArr,_conditionArr);
        
        //        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
        
        NSString *page = [NSString stringWithFormat:@"%@",_page];
        self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];
        
        if (_dataArr != nil) {
            [self.table reloadData];
            [self.subTable reloadData];
            [self.table headerEndRefreshing];
            [self scrollViewDidScroll:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"-------产品搜索请求失败 error is%@----------",error);
    }];
}

#pragma 筛选navitem
-(void)setSubViewHideNo
{
    if (self.dataArr.count>0) {
//        UIView *cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        CGFloat W = self.view.frame.size.width;
        
        self.subView.frame = CGRectMake(0, self.view.window.bounds.size.height, W, self.view.window.bounds.size.height);
//        [cover addSubview:self.subView];
//        self.coverView = cover;
        [self.view.window addSubview:self.subView];

        NSArray *priceData = [WriteFileManager readData:@"priceData"];
        if (priceData.count == 3) {
            [self.priceBtnOutlet setTitle:priceData[2] forState:UIControlStateNormal];
        }
        
        
//        UIView *gestureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cover.frame.size.width-self.subView.frame.size.width, cover.frame.size.height)];
//        [self.coverView addSubview:gestureView];
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBlackViewToHide)];
//        [gestureView addGestureRecognizer:tap];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.subView.transform = CGAffineTransformMakeTranslation(0, -self.subView.frame.size.height);
            //  NSString *str = [_pushedArr firstObject][@"Text"];
            if (_pushedArr.count == 0) {
                
                self.subTable.transform = CGAffineTransformMakeTranslation(0, -60);
            }
            
        }];
        
        NSLog(@"-------------------初始化时加返：%@及时:%@------------",_jiafan,_jishi);
        if ([_jiafan  isEqual: @"0"]) {
            self.jiafanSwitch.on = NO;
            
        }else if ([_jiafan isEqual:@"1"]){
            self.jiafanSwitch.on = YES;
        }
        if ([_jishi isEqual:@"0"]) {
            self.jishiSwitch.on = NO;
        }else if ([_jishi isEqual:@"1"]){
            self.jishiSwitch.on = YES;
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"当前没有可供筛选的条件" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
    }
  
}

-(void)clickBlackViewToHide
{
    [UIView animateWithDuration:5 animations:^{
        
        self.subView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
         NSLog(@"hhhhhhh  ");
        [self.subView removeFromSuperview];
    }];
    NSLog(@"dffff");

//    [UIView transitionFromView:self.subView toView:nil duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
//        self.subView.transform = CGAffineTransformIdentity;
//        
//    }];
//    
  
}

// 右边滑动的按钮
- (NSArray *)createRightButtons:(ProductModal *)model
{
    NSMutableArray * result = [NSMutableArray array];
    //    NSString *add = [NSString stringWithFormat:@"最近班期:%@\n\n供应商:%@",model.LastScheduleDate,model.SupplierName];
    //    NSString* titles[2] = {@"", add};
    UIColor * colors[2] = {[UIColor clearColor], [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1]};
    for (int i = 0; i < 2; i ++)
    {
        MGSwipeButton *button = [MGSwipeButton buttonWithTitle:nil backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            NSLog(@"Convenience callback received (right). %d",i);
            return YES;
        }];
        
        if (i == 0) {
            NSString *img = [model.IsFavorites isEqualToString:@"1"] ? @"uncollection_icon" : @"collection_icon";
            [button setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        }else{
            //            button.titleLabel.numberOfLines = 0;
            button.enabled = NO;
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        //        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:[UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1] forState:UIControlStateNormal];
        CGRect frame = button.frame;
        frame.size.height = 120;
        frame.size.width = i == 1 ? 140 : 42;
        button.frame = frame;
        if (i == 1) {
            SwipeView *swipe = [SwipeView addSubViewLable:button Model:model];
            [button addSubview:swipe];
        }
        
        [result addObject:button];
    }
    return result;
}


#pragma mark - tableviewdatasource& tableviewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 120;
    }else if (tableView.tag == 7){
        CGFloat listViewH = self.listTableView.frame.size.height;
        return listViewH/self.listArray.count;
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
            //   return _isFromSearch?_subDataArr1.count-1:_subDataArr1.count ;
        }
        if (section == 1 && [_turn isEqualToString:@"On" ]) {
            NSLog(@"-------%lu",(unsigned long)_subDataArr2.count);
            return _subDataArr2.count;
        }
    }
    if (tableView.tag == 7) {
        return self.listArray.count;
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


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if(tableView.tag == 2){
//        if (section == 1) {
//            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.subTable.frame.size.width, 50)];
//            headView.backgroundColor = [UIColor whiteColor];
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.frame = CGRectMake(15, 10, 40, 30);
//            btn.titleLabel.font = [UIFont systemFontOfSize:14];
//            [btn setTitle:@"目的地" forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//        }
//
//    }
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
   
            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.subTable.frame.size.width, 210)];
            
            UIView *subLine = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.subTable.frame.size.width, 20)];
            
            subLine.backgroundColor = [UIColor colorWithRed:237/255.f green:238/255.f blue:239/255.f alpha:1];
            
            UIView *sublineSub = [[UIView alloc] initWithFrame:CGRectMake(0,49.5, subLine.frame.size.width,0.5)];
            
            sublineSub.backgroundColor = [UIColor colorWithRed:203/255.f green:204/255.f blue:205/255.f alpha:1];
            
            [subLine addSubview:sublineSub];
            
            [footView addSubview:subLine];
            
            self.subSubView.frame = CGRectMake(0, 50, self.subTable.frame.size.width, 160);
            
            //  self.subTable.contentOffset = CGPointMake(0, 250);
            
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
    [self scrollTableToFoot:YES];
}

//自动滚动到最底部
- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [self.subTable numberOfSections];
    if (s<1) return;
    NSInteger r = [self.subTable numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.subTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
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

#pragma -mark -  控制返回顶部按钮的隐藏和显示
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{/*
 CIContext *context = [CIContext contextWithOptions:nil];
 CIImage *image = [CIImage imageWithContentsOfURL:imageURL];
 CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
 [filter setValue:image forKey:kCIInputImageKey];
 [filter setValue:@2.0f forKey: @"inputRadius"];
 CIImage *result = [filter valueForKey:kCIOutputImageKey];
 CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
 UIImage * blurImage = [UIImage imageWithCGImage:outImage];
 */
    
//    if (self.table.contentOffset.y>300) {
//        self.backToTopBtn.hidden = NO;
//    }else if (self.table.contentOffset.y <300){
//        self.backToTopBtn.hidden = YES;
//    }

    
    NSInteger count = self.table.contentOffset.y/(120*10);
    int totalCount = (int)self.productCount/10;
    if (self.productCount%10>0) {//如果／10还有余数总页码＋1
        totalCount++;
    }
    //    long pageCount;
    //    if ([_page integerValue] <= 1) {
    //        pageCount = 1;
    //    }else if ([_page integerValue] > 1){
    //        pageCount = [_page integerValue] - 1;
    //    }
    if (count+1 == 1) {
        self.backToTopBtn.alpha = 0;
    }else{
        self.backToTopBtn.alpha = 1;
    }
    //页码在第一页不能显示
    
    if (scrollView.contentOffset.y > self.oldOffset){
        NSLog(@"向上滚动，应该隐藏");
        if (count+1 == 1){
//            if (self.isAnimation) {
//                [UIView animateWithDuration:0.6 animations:^{
//                    CGPoint gaosi = self.gaosimohuView.center;
//                    CGPoint choose = self.chooseButton.center;
//                    gaosi.y -= 60;
//                    choose.y -= 60;
//                    self.gaosimohuView.center = gaosi;
//                    self.chooseButton.center = choose;
//                    NSLog(@"%f---%f",gaosi.y,choose.y);
//                } completion:^(BOOL finished) {
//                    NSLog(@"执行动画完毕");
//                }];
//                self.isAnimation = NO;
//            }
            
        }else{
            if (self.isAnimation == NO) {
            [UIView animateWithDuration:0.6 animations:^{
//                CGPoint gaosi = self.gaosimohuView.center;
//                CGPoint choose = self.chooseButton.center;
//                gaosi.y +=60;
//                choose.y +=60;
//                self.gaosimohuView.center = gaosi;
//                self.chooseButton.center = choose;
//                NSLog(@"%f---%f",gaosi.y,choose.y);
            } completion:^(BOOL finished) {
                NSLog(@"执行动画完毕");
            }];
            self.isAnimation = YES;
            }
        }
        
    }else{
        NSLog(@"向下滚动,应该显示");
            if (self.isAnimation) {
                [UIView animateWithDuration:0.6 animations:^{
//                    CGPoint gaosi = self.gaosimohuView.center;
//                    CGPoint choose = self.chooseButton.center;
//                    gaosi.y -=60;
//                    choose.y -= 60;
//                    self.gaosimohuView.center = gaosi;
//                    NSLog(@"%f",self.view.center.y);
//                    self.chooseButton.center = choose;
//                    NSLog(@"%f---%f",gaosi.y,choose.y);
                } completion:^(BOOL finished) {
                    NSLog(@"执行动画完毕");
                }];
                self.isAnimation = NO;
            }
    }
    self.oldOffset = scrollView.contentOffset.y;
    [self.pageCountBtn setTitle:[NSString stringWithFormat:@"%d/%d",count+1,totalCount] forState:UIControlStateNormal];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始滚动%f",scrollView.contentOffset.y);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        
        ProductModal *model = _dataArr[indexPath.row];
        
        NSString *productUrl = model.LinkUrl;
        
        NSString *productName = model.Name;
        ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
        
        detail.produceUrl = productUrl;
        detail.shareInfo = model.ShareInfo;
        NSLog(@"%@---%@----%@", detail.shareInfo,detail.produceUrl,productName);
        detail.productName = productName;
        if (self.isFromSearch) {
            detail.fromType = FromProductSearch;
        }else{
            detail.fromType = FromFindProduct;
        }
        [self.navigationController pushViewController:detail animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (tableView.tag == 2) {
        if (indexPath.section == 0 && indexPath.row == 2) {
            ChooseDayViewController *choose = [[ChooseDayViewController alloc]init];
            choose.delegate = self;
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"FindProductStartTimeSX" attributes:dict];
            
            NSInteger a = (6*(indexPath.section)) + (indexPath.row);//获得当前点击的row行数
            NSDictionary *conditionDic = _conditionArr[a];
            choose.buttons = conditionDic;
            choose.needMonth = @"1";
            self.subView.hidden = YES;
            NSLog(@"---%@",conditionDic);
            [self.navigationController pushViewController:choose animated:YES];
        }else if (!(indexPath.section == 0 && indexPath.row == 2)){
            if (indexPath.section == 0) {
                switch (indexPath.row) {
                    case 0:{
                        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                        [MobClick event:@"FindProductDestinationSX" attributes:dict];
                    }
                        break;
                    case 1:
                    {
                        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                        [MobClick event:@"FindProductStartCitySX" attributes:dict];
                        
                    }
                        break;
                    case 3:
                    {
                        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                        [MobClick event:@"FindProductDayNumberSX" attributes:dict];
                        
                    }
                        break;
                    case 4:
                    {
                        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                        [MobClick event:@"FindProductVisitLineSX" attributes:dict];
                        
                    }
                        break;
                    case 5:
                    {
                        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                        [MobClick event:@"FindProductSupplierSX" attributes:dict];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
            if (indexPath.section == 1) {
                switch (indexPath.row) {
                    case 0:
                    {
                        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                        [MobClick event:@"FindProductThemeSX" attributes:dict];
                        
                    }
                        break;
                    case 1:
                    {
                        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                        [MobClick event:@"FindProductHotelTypeSX" attributes:dict];
                        
                    }
                        break;
                    case 2:
                    {
                        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                        [MobClick event:@"FindProductTripModeSX" attributes:dict];
                        
                    }
                        break;
                    case 3:
                    {
                        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                        [MobClick event:@"FindProductShipCompanySX" attributes:dict];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
//            NSLog(@"%d", indexPath.row);
            NSInteger a = (6*(indexPath.section)) + (indexPath.row);//获得当前点击的row行数
            
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
            self.subView.hidden = YES;
            [self.navigationController pushViewController:conditionVC animated:YES];
        }
    }
    if (tableView.tag == 7) {
        NSLog(@"7700000000");
        if (indexPath.section == 0) {
            if (indexPath.row == 0){
                //                NSLog(@"00000000");
                [self recommond];
            }else if (indexPath.row == 1){
                [self profits:indexPath.row];
                NSLog(@"利润高 －》 低");
            }else if (indexPath.row == 2){
                [self profits:indexPath.row];
                NSLog(@"利润低 －》 高");//
            }else if (indexPath.row == 3){
                 NSLog(@"同行价 高 －－－低");
                [self cheap:indexPath.row];
                
            }else if (indexPath.row == 4){
                 NSLog(@"同行价低 －》 高");//
                [self cheap:indexPath.row];
            }
            
            [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
            [self close];
        }
    }
}
    
- (void)deselect
{
 [self.listTableView deselectRowAtIndexPath:[self.listTableView indexPathForSelectedRow] animated:YES];
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
        //            cell.leftSwipeSettings.transition = MGSwipeTransitionStatic;
        
        cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
        
        //            cell.leftButtons = [self createLeftButtons:model];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.rightButtons = [self createRightButtons:model];
        return cell;
        
        //        }
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"没有找到符合要求的产品" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
        //        [alert show];
    }
    
    if (tableView.tag == 2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, self.subTable.frame.size.width, 0.5)];
            
            line.backgroundColor = [UIColor colorWithRed:203/255.f green:204/255.f blue:205/255.f alpha:1];
            
            [cell addSubview:line];
        }
        
        if (indexPath.section == 0) {
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            NSLog(@"%@", self.subDataArr1[indexPath.row]);
            cell.textLabel.text =  [NSString stringWithFormat:@"%@",self.subDataArr1[indexPath.row]];
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
            
            cell.detailTextLabel.textColor = [UIColor orangeColor];
            
            if (indexPath.row == 2){
                if (_goDateEnd.length>3) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@~%@",_goDateStart,_goDateEnd];
                }else if (_goDateEnd.length<=2){
                    cell.detailTextLabel.text = @"不限";
                }
                if (_month.length>1) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_month];
                }
                
            } else if (indexPath.row != 2) {
                
           cell.detailTextLabel.text = self.subIndicateDataArr1[indexPath.row];
           NSString *detailStr = self.subIndicateDataArr1[indexPath.row];
           if (!detailStr.length || [detailStr isEqualToString:@" "]) {
                 cell.detailTextLabel.text = @"不限";
           }else{
               cell.detailTextLabel.text = self.subIndicateDataArr1[indexPath.row];
           }
                
                //               if (indexPath.row == 0 && _isFromSearch == YES)
                //                if (indexPath.row == 0 && self.pushedArr.count == 0)   { //当是从搜索进来时,掩盖第一个cell
                //
                //                    UIView *coverView = [[UIView alloc] initWithFrame:cell.contentView.frame];
                //                    coverView.backgroundColor = [UIColor whiteColor];
                //                    [cell.contentView addSubview:coverView];
                //                    cell.accessoryType = UITableViewCellAccessoryNone;
                //                    cell.detailTextLabel.text = @"";
                //                }
                
            }
            
            NSRange range = [cell.detailTextLabel.text rangeOfString:@"不限"];
            if( range.location == NSNotFound){
                cell.detailTextLabel.textColor = [UIColor orangeColor];
            }else{
                cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            }
            
            
        }else {
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",self.subDataArr2[indexPath.row]];
            
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            
            cell.textLabel.text =  [NSString stringWithFormat:@"%@",self.subDataArr2[indexPath.row]];
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
            
            NSString *detailStr = self.subIndicateDataArr2[indexPath.row];
            if (detailStr.length>=2) {
                
                cell.detailTextLabel.text = self.subIndicateDataArr2[indexPath.row];
                
            }
            
            NSString *detailStr2 = self.subIndicateDataArr2[indexPath.row];
            if (detailStr2.length<2) {
                cell.detailTextLabel.text = @"不限";
            }
            
            NSRange range = [cell.detailTextLabel.text rangeOfString:@"不限"];
            if( range.location == NSNotFound){
                cell.detailTextLabel.textColor = [UIColor orangeColor];
            }else{
                cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            }
            
            
        }
        return cell;
    }
    if (tableView.tag == 7) {
        static NSString *reuct = @"77";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuct];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuct];
        }
        cell.textLabel.text = [self.listArray objectAtIndex:indexPath.row];
        NSLog(@"cell.textLabel.text = %@, %@", cell.textLabel.text, [self.listArray objectAtIndex:indexPath.row]);
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
    
    NSString *result = [NSString stringWithFormat:@"%d",![model.IsFavorites integerValue]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:model.ID forKey:@"ProductID"];
    
    [dic setObject:result forKey:@"IsFavorites"];///Product/ SetProductFavorites
    
    [IWHttpTool WMpostWithURL:@"/Product/SetProductFavorites" params:dic success:^(id json) {
        if ([model.IsFavorites isEqualToString:@"0"]) {
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"FindProductListStoreClick" attributes:dict];
            
        }
        if ([json[@"IsSuccess"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"操作成功"];
            model.IsFavorites = [NSString stringWithFormat:@"%d",![model.IsFavorites integerValue]];
            [self.dataArr replaceObjectAtIndex:indexPath.row withObject:model];
            [self.table reloadData];
        }else{
            [MBProgressHUD showError:json[@"ErrorMsg"]];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"产品收藏网络请求失败");
        
    }];
    
    return YES;
}





#pragma mark - 控件Action
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)recommond{//推荐
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"FindProductRecommondClick" attributes:dict];
    
    // [self backToTop:nil];
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    
    hudView.labelText = @"加载中...";
    
    [hudView show:YES];
    
    
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
    self.selectIndex = [NSMutableString stringWithFormat:@"0"];
    // [self ProductSortingTypeWith:@"0"];
    
    [dic setObject:self.pushedSearchK forKey:@"SearchKey"];
    // NSLog(@"-------page2 请求的 dic  is %@-----",dic);
    [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
        //[self backToTop:nil];
        [self.dataArr removeAllObjects];//移除
        
        NSMutableArray *dicArr = [NSMutableArray array];
        
        for (NSDictionary *dic in json[@"ProductList"]) {
            
            ProductModal *modal = [ProductModal modalWithDict:dic];
            
            [dicArr addObject:modal];
            
        }
        
        _dataArr = dicArr;
        
        
        [self.table reloadData];
        [self backToTop:nil];
        NSString *page = [NSString stringWithFormat:@"%@",_page];
        
        self.page = [NSMutableString stringWithFormat:@"%d",2];
        //  NSLog(@"---------转化后的page is %@ +1后的 page is -------%@----",page,_page);
    } failure:^(NSError *error) {
        
        NSLog(@"-------产品搜索请求失败 error is%@----------",error);
    }];
    
    
    [hudView hide:YES];
    
}
    
    
    
    
    
- (void)profits:(NSInteger)sender {//利润2,1
        
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"FindProductProfitsClick" attributes:dict];
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    
    hudView.labelText = @"加载中...";
    [hudView show:YES];
  
//    if (self.profitOutlet.selected == NO) {
//        [self.profitOutlet setSelected:YES];
//        [self.cheapOutlet setSelected:NO];
//        [self.commondOutlet setSelected:NO];
      if (sender == 2) {
   
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic addEntriesFromDictionary:_conditionDic];//增加筛选条件
        
        [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
        
        [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];
        
        // [dic setObject:@"10" forKey:@"Substation"];
        [dic setObject:@"10" forKey:@"PageSize"];
        
        [dic setObject:@1 forKey:@"PageIndex"];
        self.selectIndex = [NSMutableString stringWithFormat:@"1"];
        [dic setObject:@"1" forKey:@"ProductSortingType"];
        //[self ProductSortingTypeWith:@"2"];
        [dic setObject:self.pushedSearchK forKey:@"SearchKey"];
        
        NSLog(@"---1----page2 请求的 dic  is %@-----",dic);
        
        [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
            
            [self.dataArr removeAllObjects];//移除
            
            NSMutableArray *dicArr = [NSMutableArray array];
            
            for (NSDictionary *dic in json[@"ProductList"]) {
                
                ProductModal *modal = [ProductModal modalWithDict:dic];
                
                [dicArr addObject:modal];
            }
            _dataArr = dicArr;
            
            
            [self.table reloadData];
            [self backToTop:nil];
            NSString *page = [NSString stringWithFormat:@"%@",_page];
            
            self.page = [NSMutableString stringWithFormat:@"%d",2];
            } failure:^(NSError *error) {
                NSLog(@"-------产品搜索请求失败 error is%@----------",error);
            }];
        
        }
//        if (sender == 2 && self.profitOutlet.selected == YES){
//        [self.profitOutlet setTitle:@"利润 ↓" forState:UIControlStateNormal];
    
        if (sender == 1){
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            [dic addEntriesFromDictionary:_conditionDic];//增加筛选条件
            
            [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
            
            [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];
            
            //  [dic setObject:@"10" forKey:@"Substation"];
            [dic setObject:@"10" forKey:@"PageSize"];
            
            [dic setObject:@1 forKey:@"PageIndex"];
            
            [dic setObject:@"2" forKey:@"ProductSortingType"];
            self.selectIndex = [NSMutableString stringWithFormat:@"2"];
            // [self ProductSortingTypeWith:@"1"];
            [dic setObject:self.pushedSearchK forKey:@"SearchKey"];
          
            [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
                
                [self.dataArr removeAllObjects];//移除
                
                NSMutableArray *dicArr = [NSMutableArray array];
                
                for (NSDictionary *dic in json[@"ProductList"]) {
                    
                    ProductModal *modal = [ProductModal modalWithDict:dic];
                    
                    [dicArr addObject:modal];
                }
                _dataArr = dicArr;
                
                
                [self.table reloadData];
                [self backToTop:nil];
                NSString *page = [NSString stringWithFormat:@"%@",_page];
                
                self.page = [NSMutableString stringWithFormat:@"%d",2];
                
                NSLog(@"----2-----转化后的page is %@ +1后的 page is -------%@----",page,_page);
            } failure:^(NSError *error) {
                
                NSLog(@"-------产品搜索请求失败 error is%@----------",error);
            }];
            
            
        }
        if (sender == 1 && self.profitOutlet.selected == YES){
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            [dic addEntriesFromDictionary:_conditionDic];//增加筛选条件
            
            [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
            
            [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];
            
            //  [dic setObject:@"10" forKey:@"Substation"];
            [dic setObject:@"10" forKey:@"PageSize"];
            
            [dic setObject:@1 forKey:@"PageIndex"];
            
            [dic setObject:@"1" forKey:@"ProductSortingType"];
            self.selectIndex = [NSMutableString stringWithFormat:@"1"];
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
                [self backToTop:nil];
                NSString *page = [NSString stringWithFormat:@"%@",_page];
                
                self.page = [NSMutableString stringWithFormat:@"%d",2];
                
                NSLog(@" gao  gao ---------转化后的page is %@ +1后的 page is -------%@----",page,_page);
            } failure:^(NSError *error) {
                
                NSLog(@"-------产品搜索请求失败 error is%@----------",error);
            }];
            
        }
        
        [hudView hide:YES];
        
}





- (void)cheap:(NSInteger)sender {//同行价4,3
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"FindProductPriceClick" attributes:dict];
    
    // dispatch_queue_t que = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    //  dispatch_sync(que, ^{
    // [self backToTop:nil];
    //   });
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    
    hudView.labelText = @"加载中...";
    
    [hudView show:YES];
    
    
    // [self backToTop:nil];
//    if (self.cheapOutlet.selected == NO) {
//        [self.cheapOutlet setSelected:YES];
//        [self.commondOutlet setSelected:NO];
//        [self.profitOutlet setSelected:NO];
       if (sender == 4) {
    
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic addEntriesFromDictionary:_conditionDic];//增加筛选条件
        
        [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
        
        [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];
        
        //[dic setObject:@"10" forKey:@"Substation"];
        
        [dic setObject:@"10" forKey:@"PageSize"];
        
        [dic setObject:@1 forKey:@"PageIndex"];
        
        [dic setObject:@"3" forKey:@"ProductSortingType"];
        self.selectIndex = [NSMutableString stringWithFormat:@"3"];
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
            [self backToTop:nil];
            NSString *page = [NSString stringWithFormat:@"%@",_page];
            
            self.page = [NSMutableString stringWithFormat:@"%d",2];
            
            //  NSLog(@"---------转化后的page is %@ +1后的 page is -------%@----",page,_page);
        } failure:^(NSError *error) {
            
            NSLog(@"-------产品搜索请求失败 error is%@----------",error);
            
        }];
        
        //    }else if (self.cheapOutlet.selected == YES && [self.cheapOutlet.titleLabel.text
        //                                                   isEqualToString:@"同行价 ↑"]){
    }

//    if (self.cheapOutlet.selected == YES && sender == 4){
//     [self.cheapOutlet setTitle:@"同行价 ↓" forState:UIControlStateNormal];
         if (sender == 3){
             
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            [dic addEntriesFromDictionary:_conditionDic];//增加筛选条件
            
            [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
            
            [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];
            
            //  [dic setObject:@"10" forKey:@"Substation"];
            
            [dic setObject:@"10" forKey:@"PageSize"];
            
            [dic setObject:@1 forKey:@"PageIndex"];
            
            [dic setObject:@"4" forKey:@"ProductSortingType"];
            self.selectIndex = [NSMutableString stringWithFormat:@"4"];
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
                [self backToTop:nil];
                NSString *page = [NSString stringWithFormat:@"%@",_page];
                
                self.page = [NSMutableString stringWithFormat:@"%d",2];
                //   NSLog(@"---------转化后的page is %@ +1后的 page is -------%@----",page,_page);
            } failure:^(NSError *error) {
                
                NSLog(@"-------产品搜索请求失败 error is%@----------",error);
            }];
            
        }
        if (self.cheapOutlet.selected == YES &&sender == 3){
            //        [self.cheapOutlet setTitle:@"同行价 ↑" forState:UIControlStateNormal];
            NSLog(@"ssss");
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            [dic addEntriesFromDictionary:_conditionDic];//增加筛选条件
            
            [dic setObject:[self jishi ] forKey:@"IsComfirmStockNow"];
            
            [dic setObject:[self jiafan ] forKey:@"IsPersonBackPrice"];
            
            // [dic setObject:@"10" forKey:@"Substation"];
            [dic setObject:@"10" forKey:@"PageSize"];
            
            [dic setObject:@1 forKey:@"PageIndex"];
            
            [dic setObject:@"3" forKey:@"ProductSortingType"];
            self.selectIndex = [NSMutableString stringWithFormat:@"3"];
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
                [self backToTop:nil];
                NSString *page = [NSString stringWithFormat:@"%@",_page];
                
                self.page = [NSMutableString stringWithFormat:@"%d",2];
                
                //   NSLog(@"---------转化后的page is %@ +1后的 page is -------%@----",page,_page);
            } failure:^(NSError *error) {
                
                NSLog(@"-------产品搜索请求失败 error is%@----------",error);
            }];
            
        }
    
    
    [hudView hide:YES];
}
    



- (IBAction)sunCancel:(id)sender {
    //   [UIView animateWithDuration:0.3 animations:^{
    //              self.subView.alpha = 0;
    //       self.subView.hidden = YES;
    //   }];
    //self.blackView.alpha = 0;
    
    [self editButtons];
    self.commondOutlet.selected = YES;
    [self initPullForResetAndCancel];
//    self.pageCountBtn.hidden = NO;
    [self.backToTopBtn addSubview:self.pageCountBtn];

//    

    
//  动画
//      [UIView transitionFromView:self.subView toView:nil duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom completion:^(BOOL finished) {
//                self.subView.transform = CGAffineTransformIdentity;
//        [self.coverView removeFromSuperview];
//            }];

    [UIView animateWithDuration:0.3 animations:^{
        self.subView.transform = CGAffineTransformIdentity;
//        CATransition *transition = [CATransition animation];
//        [transition setDuration:0.5];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromBottom;
//        [transition setFillMode:kCAFillModeBoth];
//        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        [self.subView.layer addAnimation:transition forKey:nil];
    } completion:^(BOOL finished) {
        
        [self.subView removeFromSuperview];
    }];

    
    
    [self scrollViewDidScroll:nil];
    
    
}

-(void)initPullForResetAndCancel
{
    //上啦刷新
    [self.table addFooterWithTarget:self action:@selector(footLoad)];
    //设置文字
    self.table.footerPullToRefreshText = @"加载更多";
    self.table.footerRefreshingText = @"正在刷新";
    //下拉
    [self.table addHeaderWithTarget:self action:@selector(headerPull)];
    self.table.headerPullToRefreshText =@"刷新内容";
    self.table.headerRefreshingText = @"正在刷新";
    
}

- (IBAction)subReset:(id)sender {
    
    self.conditionDic = nil;
    [self refereshSelectData];
    [self editButtons];
    
    NSMutableAttributedString *pric = [[NSMutableAttributedString alloc] initWithString:@"价格区间"];
    [self.priceBtnOutlet setAttributedTitle:pric forState:UIControlStateNormal];
    //[self.priceBtnOutlet setTitle:pric forState:UIControlStateNormal];
    
    NSArray *priceData = [NSArray arrayWithObject:@"价格区间"];
    [WriteFileManager saveData:priceData name:@"priceData"];
    
    [self.jishiSwitch setOn:NO];
    //[self jishi];
    self.jishi = [NSMutableString stringWithFormat:@"0"];
    self.jiafan = [NSMutableString stringWithFormat:@"0"];
    [self.jiafanSwitch setOn:NO];
    //[self jiafan];
    
    self.subIndicateDataArr1 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ",@" ",@" ", nil];
    
    self.subIndicateDataArr2 = [NSMutableArray arrayWithObjects:@" ",@" ",@" ",@" ", nil];
    
    self.goDateStart = [NSMutableString stringWithFormat:@""];
    self.goDateEnd = [NSMutableString stringWithFormat:@""];
    self.month = [NSMutableString stringWithFormat:@""];
    [self.subTable reloadData];
    
    
    [self initPullForResetAndCancel];
}




- (IBAction)subDone:(id)sender {
    
    
    // [self editButtons];//重新确认按钮状态
    
    //让推荐按钮被选中
    [UIView animateWithDuration:0.3 animations:^{
        
        self.subView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self.coverView removeFromSuperview];
        
        //        [self.commondOutlet setSelected:YES];
        //
        //        self.profitOutlet.selected = NO;
        //
        //        self.cheapOutlet.selected = NO;
    }];
    
    // [self.commondOutlet setSelected:YES];
    [self initPull];
    
    
    
    
    
}



- (IBAction)subMinMax:(id)sender {
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"FindProductPriceRangeSX" attributes:dict];
    
    MinMaxPriceSelectViewController *mm = [[MinMaxPriceSelectViewController alloc] init];
    
    mm.delegate = self;
    
   // self.subView.hidden = YES;
    
    [self.navigationController pushViewController:mm animated:YES];
}


//- (void)loadDataSourceWithCondition
//{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//
//    self.page = [NSMutableString stringWithFormat:@"1"];
//    //  [dic setObject:@"10" forKey:@"Substation"];
//    [dic setObject:@"10" forKey:@"PageSize"];
//    [dic setObject:_page forKey:@"PageIndex"];
//    [dic setObject:[self jishi] forKey:@"IsComfirmStockNow"];
//    [dic setObject:[self jiafan] forKey:@"IsPersonBackPrice"];
//
//    [dic setObject:_pushedSearchK forKey:@"SearchKey"];
//    [dic setObject:@"0" forKey:@"ProductSortingType"];
//    [dic addEntriesFromDictionary:[self conditionDic]];//增加筛选条件
//
//    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
//
//    hudView.labelText = @"加载中...";
//
//    [hudView show:YES];
//
//
//    [IWHttpTool WMpostWithURL:@"/Product/GetProductList" params:dic success:^(id json) {
//
//        NSLog(@"--------------json[condition is  %@------------]",json);
//        NSArray *arr = json[@"ProductList"];
//        NSLog(@"------------arr.cont is %lu---------",(unsigned long)arr.count);
////        [self.dataArr removeAllObjects];
//        if (arr.count==0) {
//
//            [self addANewFootViewWhenHaveNoProduct2];
//
//           // self.table.tableFooterView.hidden = YES;
//        }else if (arr.count>0){
//
//            for (NSDictionary *dic in json[@"ProductList"]) {
//                ProductModal *modal = [ProductModal modalWithDict:dic];
//                [self.dataArr addObject:modal];
//
//            }
//
//        }
//
//        NSMutableArray *conArr = [NSMutableArray array];
//
//        for(NSDictionary *dic in json[@"ProductConditionList"] ){
//            [conArr addObject:dic];
//        }
//
//
//        _conditionArr = conArr;//装载筛选条件数据
//
//        NSLog(@"---------!!!!!!dataArr is %@!!!!!! conditionArr is %@------",_dataArr,_conditionArr);
//
//
////        [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].delegate window] animated:YES];
//
//
//        NSString *page = [NSString stringWithFormat:@"%@",_page];
//        self.page = [NSMutableString stringWithFormat:@"%d",[page intValue]+1];
//
//        if (_dataArr != nil) {
//
//
//            [self.table reloadData];
//
//
//
//
//            [hudView hide:YES];
//            [self.table footerEndRefreshing];
//
//            
//        }
//        
//    } failure:^(NSError *error) {
//        NSLog(@"-------产品搜索请求失败 error is%@----------",error);
//    }];
//    
//}
//


- (IBAction)jiafanSwitchAction:(id)sender {
    [self changeJiaFan];
    
    //    BOOL isOn = [self.jiafanSwitch isOn];
    //    if (isOn) {
    //        self.jiafanSwitch.on = NO;
    //        self.jishi = [NSMutableString stringWithFormat:@"0"];
    //       
    //    }else if (!isOn){
    //        self.jiafanSwitch.on = YES;
    //        self.jishi = [NSMutableString stringWithFormat:@"1"];
    //    }
    NSLog(@"--------加返-------------%@-------------------被点击",_jiafan);
}

- (IBAction)jishiSwitchAction:(id)sender {
    [self changeJishi];
    //    BOOL isOn = [self.jishiSwitch isOn];
    //    if (isOn) {
    //        self.jiafanSwitch.on = NO;
    //        //self.jiafan = [NSMutableString stringWithFormat:@"0"];
    //        [self jishi];
    //    }else if (!isOn){
    //        self.jishiSwitch.on = YES;
    //       // self.jiafan = [NSMutableString stringWithFormat:@"1"];
    //        [self jiafan];
    //    }
    NSLog(@"----------及时------------%@------------------被点击",_jishi);
}


//让table回到顶部
- (IBAction)backToTop:(id)sender {
    
    [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (IBAction)listButton:(id)sender {
    if (self.shareFlag) {
        [ShareView cancleBtnClick];
        self.shareFlag = !self.shareFlag;
    }
    [self setBtnStateWith:2];
    if (self.flag == NO) {
        self.shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-self.gaosimohuView.frame.size.height)];
        _shadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.listTableView.hidden = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeListTableView:)];
        [self.shadeView addGestureRecognizer:tap];
        
        [UIView animateWithDuration:0.0 animations:^{
            self.listTableView.transform = CGAffineTransformMakeTranslation(0, self.gaosimohuView.frame.size.height+5);
        } completion:^(BOOL finished) {
            
        }];
        [self.view.window addSubview:self.shadeView];
        [self.view addSubview:_gaosimohuView];
        //    [self.shadeView addSubview:self.listTableView]
        [[[UIApplication sharedApplication].delegate window] addSubview:self.listTableView];
        self.flag = !self.flag;
    }else{
        [self close];
    }
}
- (IBAction)sharebutton:(id)sender {
    [self setBtnStateWith:3];
    if (self.flag) {
        [self close];
        [self setBtnStateWith:3];
    }

    if (self.shareFlag == NO) {
//        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
//        [postDic setObject:@"0" forKey:@"ShareType"];
//        if (self.shareInfo[@"Url"]) {
//            [postDic setObject:self.shareInfo[@"Url"]  forKey:@"ShareUrl"];
//        }
//        [postDic setObject: forKey:@"PageUrl"];
        NSDictionary *tmp = [StrToDic dicCleanSpaceWithDict:self.shareInfo];
        ProductModal *model = _dataArr[0];
        NSDictionary *temp = [StrToDic dicCleanSpaceWithDict:model.ShareInfo];
        NSLog(@"%@33%@", temp, tmp);

//        [[[UIAlertView alloc]initWithTitle:tmp[@"Desc"] message:tmp[@"Title"] delegate:nil cancelButtonTitle:tmp[@"Url"] otherButtonTitles:nil, nil]show];
        //构造分享内容
        id<ISSContent>publishContent = [ShareSDK content:tmp[@"Desc"]
                                          defaultContent:tmp[@"Desc"]
                                                   image:[ShareSDK imageWithUrl:tmp[@"Pic"]]
                                                   title:tmp[@"Title"]
                                                     url:tmp[@"Url"]                                             description:tmp[@"Desc"]
                                               mediaType:SSPublishContentMediaTypeNews];
        
        [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@",self.shareInfo[@"Url"]] image:nil];
        NSLog(@"%@444", self.shareInfo);
        [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", self.shareInfo[@"Url"]]];
        
        [ShareView shareWithContent:publishContent andUrl:tmp[@"Url"]];
    }else if(self.shareFlag == YES){
        [ShareView  cancleBtnClick];
        [self setBtnStateWith:0];
    }
    self.shareFlag = !self.shareFlag;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(reNotification:) name:@"zzm" object:nil];
    
}
- (void)closeListTableView:(UITapGestureRecognizer *)swipe{
    //    self.flag = !self.flag;
    [self close];
    
}

- (void)setBtnStateWith:(int)num
{
    if (num == 1) {
        self.chooseButton.selected = YES;
        self.paixuBtn.selected = NO;
        self.shareBtn.selected = NO;
    }else if (num == 2){
        self.chooseButton.selected = NO;
        self.paixuBtn.selected = YES;
        self.shareBtn.selected = NO;
    }else if (num == 3){
        self.chooseButton.selected = NO;
        self.paixuBtn.selected = NO;
        self.shareBtn.selected = YES;
    }else if (num == 0){
        self.chooseButton.selected = NO;
        self.paixuBtn.selected = NO;
        self.shareBtn.selected = NO;
    }
}
- (void)close{
    [self setBtnStateWith:0];
    //    在移除shadow之前 把需要的东西转移加到另一个view上
    [self.view addSubview:_listTableView];
    [self.shadeView removeFromSuperview];
    
    [UIView animateWithDuration:0.0 animations:^{
        self.listTableView.hidden = YES;
        //        [self.listTableView removeFromSuperview];
        
    } completion:^(BOOL finished) {
        
    }];
    self.flag = !self.flag;
    
}


- (void)reNotification:(NSNotification *)noti
{
    _shareFlag = 0;
}
    
@end
