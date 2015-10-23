//
//  RecomViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/5/25.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "RecomViewController.h"

#import "YesterdayViewController.h"
#import "RecentlyViewController.h"
#import "StationSelect.h"
#import "SearchProductViewController.h"
#import "WMAnimations.h"
#import "MobClick.h"
#import "RecommendViewController.h"
#import "HomeHttpTool.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface RecomViewController ()<UIScrollViewDelegate>

- (IBAction)todayAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *todayBtnOutlet;

- (IBAction)yesterdayAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *yesterdayBtnOutlet;

- (IBAction)recentlyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *recentlyBtnOutlet;

@property (weak, nonatomic) IBOutlet UIView *moveLine;
@property (nonatomic,assign) CGPoint normalPoint;

@property (weak, nonatomic) IBOutlet UIView *controllerView;

@property (strong,nonatomic) UIBarButtonItem *leftItem;
@property (strong,nonatomic) UIBarButtonItem *rightItem;
@property (weak, nonatomic) IBOutlet UIScrollView *scrolView;

//@property(nonatomic,strong) TodayViewController *todayVC;
@property(nonatomic,strong) YesterdayViewController *yesterdayVC;
@property(nonatomic,strong) RecentlyViewController *recentlyVC;
//@property (nonatomic,strong) RecommendViewController *todayVC;
@property(nonatomic,assign) NSInteger selectIndex;

@property(weak ,nonatomic)UIView *bugView;
@end

@implementation RecomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.todayBtnOutlet setSelected:YES];
    [self.view addSubview:self.todayVC.view];
    CGFloat lineFromX = self.moveLine.center.x;
    CGFloat lineFromY = self.moveLine.center.y;
    self.normalPoint = CGPointMake(lineFromX, lineFromY);
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    moreBtn.frame = CGRectMake(0, 0, 21, 7);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"gengduoann"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(setSubViewUp) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    self.navigationItem.rightBarButtonItem = moreItem;
    self.title = @"今日推荐";
    
   // [WMAnimations WMAnimationToScaleWithLayer:leftBtn.layer andFromValue:@1.0f andToValue:@2.0f];
    
    self.selectIndex = 0;
    [self addGes];
    
    [self judgeToTurnYesterDay];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yincang) name:@"yincang" object:nil];
}
-(void)yincang{
    leftView.alpha = 0;
    leftView.hidden = YES;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)judgeToTurnYesterDay
{
    NSDictionary *param = @{@"PageSize":@10,
                            @"PageIndex":@1,
                            @"DateRangeType":@"1"};
    
    [HomeHttpTool getRecommendProductListWithParam:param success:^(id json) {
              if (json) {
            NSLog(@"aaaaaaaa000  %@",json);
                  NSArray *arr = json[@"ProductList"];
                  if (arr.count == 0) {
                      [self yesterdayAction:nil];
                  }
              }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)addGes
{
    UISwipeGestureRecognizer *recognizerLeft;
    recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [self.view addGestureRecognizer:recognizerLeft];
    
    UISwipeGestureRecognizer *recognizerRight;
    recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self.view addGestureRecognizer:recognizerRight];
    
    
}


-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
        //如果往左滑
        
        if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
            if (self.selectIndex == 0 ) {
                [self yesterdayAction:nil];
                self.selectIndex = 1;
            }else if (self.selectIndex == 1){
                [self recentlyAction:nil];
                self.selectIndex = 2;
            }
           
            
            
        }else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight)
            //往右划
        {
            if (self.selectIndex == 2) {
                [self yesterdayAction:nil];
                self.selectIndex = 1;
            }else if (self.selectIndex == 1){
                [self todayAction:nil];
                self.selectIndex = 0;
            }
            
                  }
    leftView.alpha = 0;
    leftView.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    [MobClick beginLogPageView:@"ShouKeBaoRecomView"];
    
//    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    searchBtn.frame = CGRectMake(0, 0, 15, 15);
  //  [searchBtn setContentMode:UIViewContentModeScaleAspectFill]fdjForNav;
//    [searchBtn setBackgroundImage:[UIImage imageNamed:@"sousuoa"] forState:UIControlStateNormal];
//    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
//    
//    UIButton *stationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    stationBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    stationBtn.frame = CGRectMake(25, 0, 50, 30);
//    [stationBtn addTarget:self action:@selector(changeStation) forControlEvents:UIControlEventTouchUpInside];
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    NSString *stationName = [def objectForKey:@"SubstationName"];
//    [stationBtn setImage:[UIImage imageNamed:@"xialaa"] forState:UIControlStateNormal];
//    stationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0);
//    [stationBtn setTitle:[NSString stringWithFormat:@"%@",stationName]  forState:UIControlStateNormal];
//    stationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 10);
//    [stationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//   
//    UIBarButtonItem *stationItem = [[UIBarButtonItem alloc] initWithCustomView:stationBtn];
//    self.navigationItem.rightBarButtonItem = stationItem;
        //  [searchBtn setContentMode:UIViewContentModeScaleAspectFill]fdjForNav;
          //self.leftItem = searchItem;
    //self.rightItem = stationItem;
//
   

    //self.navigationItem.leftBarButtonItems = @[stationBtn,searchBtn];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    leftView = [[UIView alloc] initWithFrame:CGRectMake(kScreenSize.width-140, 0, 130, 68)];
    leftView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lansedia"]];
    UIButton *stationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    stationBtn.frame = CGRectMake(40, 5, 100, 30);
    [stationBtn addTarget:self action:@selector(changeStation) forControlEvents:UIControlEventTouchUpInside];
    [stationBtn setImage:[UIImage imageNamed:@"qiehuana"] forState:UIControlStateNormal];
    stationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 10);
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *stationName = [def objectForKey:@"SubstationName"];
    
    [stationBtn setTitle:[NSString stringWithFormat:@"切换分站(%@)",stationName]  forState:UIControlStateNormal];
    stationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 10);
    [stationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(40, 40, 80, 30);
    //[searchBtn setContentMode:UIViewContentModeScaleAspectFill]fdjForNav;
    [searchBtn setImage:[UIImage imageNamed:@"bigsousuo"] forState:UIControlStateNormal];
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -59, 0, 10);
    [searchBtn setTitle:@"查找产品" forState:UIControlStateNormal];
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -45, 0, 10);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    [leftView addSubview:searchBtn];
    [leftView addSubview:stationBtn];
    leftView.alpha = 0;
    leftView.hidden = YES;
    [self.view addSubview:leftView];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super   viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaoRecomView"];
}
//
-(void)changeStation
{
    [leftView removeFromSuperview];
    StationSelect * station =[ [StationSelect alloc] init];
    station.delegate = self;
    [self.navigationController pushViewController:station animated:YES];
}

-(void)searchAction
{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"RecommendSearchClick" attributes:dict];
    [leftView removeFromSuperview];
    [self.navigationController pushViewController:[[SearchProductViewController alloc] init] animated:YES];
}
//此处 添加 动画效果
-(void)setSubViewUp
{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"CustomAddClick" attributes:dict];
    
    if (leftView.hidden == YES) {
        [UIView animateWithDuration:0.6 animations:^{
            leftView.alpha = 0;
           leftView.alpha = 1;
            //leftView.hidden = NO;
            leftView.hidden = NO;
            [self.view bringSubviewToFront:leftView];
        }];

    }else if (leftView.hidden == NO){
        [UIView animateWithDuration:0.6 animations:^{
           leftView.alpha = 1;
            leftView.alpha = 0;
            leftView.hidden = YES;
        }];
       
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(RecommendViewController *)todayVC
{
    if (_todayVC == nil) {
        self.todayVC = [[RecommendViewController alloc] init];
        NSLog(@"——————%d", self.isFromEmpty);
        self.todayVC.isFromEmpty = self.isFromEmpty;
        [self addChildViewController:_todayVC];
//        CGFloat viewW = [[UIScreen mainScreen] bounds].size.width;
//        CGFloat viewH = self.controllerView.frame.size.height;
//        CGFloat viewY = self.controllerView.frame.origin.y;
//        self.todayVC.view.frame = CGRectMake(0, viewY, viewW, viewH);
//        [self.view addSubview:self.todayVC.view];
        self.todayVC.view.frame = self.controllerView.frame;
  
    }
    return _todayVC;
}

-(YesterdayViewController *)yesterdayVC
{
    if (_yesterdayVC == nil) {
        self.yesterdayVC = [[YesterdayViewController alloc] init];
        [self addChildViewController:_yesterdayVC];
        self.yesterdayVC.view.frame = self.controllerView.frame;
        self.yesterdayVC.isFromEmpty = self.isFromEmpty;
//        self.yesterdayVC.markUrl = self.markStr;
        
//        CGFloat viewW = [[UIScreen mainScreen] bounds].size.width;
//        CGFloat viewH = self.controllerView.frame.size.height;
//        CGFloat viewY = self.controllerView.frame.origin.y;
//      
//        self.yesterdayVC.view.frame = CGRectMake(viewW, viewY, viewW, viewH);
    //        [self.view addSubview:self.yesterdayVC.view];
       

    }
    return _yesterdayVC;
}

-(RecentlyViewController *)recentlyVC
{
    if (_recentlyVC == nil) {
        self.recentlyVC = [[RecentlyViewController alloc] init];
        [self addChildViewController:_recentlyVC];
//        CGFloat viewW = [[UIScreen mainScreen] bounds].size.width;
//        CGFloat viewH = self.controllerView.frame.size.height;
//        CGFloat viewY = self.controllerView.frame.origin.y;
//        self.recentlyVC.view.frame = CGRectMake(2*viewW, viewY, viewW, viewH);
//       
//        [self.view addSubview:self.recentlyVC.view];
        
        self.recentlyVC.view.frame = self.controllerView.frame;
    }
    return _recentlyVC;
}

- (IBAction)todayAction:(id)sender {
    
   
    [self.yesterdayBtnOutlet setSelected:NO];
    [self.recentlyBtnOutlet setSelected:NO];
    [self.todayBtnOutlet setSelected:YES];
    
   
    [self.view addSubview:self.todayVC.view];
    [self.yesterdayVC.view removeFromSuperview];
    [self.recentlyVC.view removeFromSuperview];
        self.selectIndex = 0;
    self.title = @"今日推荐";
    leftView.alpha = 0;
    leftView.hidden = YES;

    CGFloat lineToX = self.todayBtnOutlet.frame.size.width/2;
    CGFloat lineToY = CGRectGetMaxY(self.todayBtnOutlet.frame)+2;
   CGPoint to = CGPointMake(lineToX,lineToY);
   
    [WMAnimations WMAnimationToMoveWithTableLayer:self.moveLine.layer andFromPiont:self.normalPoint ToPoint:to];
   
     self.normalPoint = to;
    NSLog(@"from:%@------to:%@",NSStringFromCGPoint(self.normalPoint),NSStringFromCGPoint(to));
    
    
}

- (IBAction)yesterdayAction:(id)sender {
    
//    self.isFromEmpty = 0;
    self.selectIndex = 1;
   
     [self.yesterdayBtnOutlet setSelected:YES];
    [self.todayBtnOutlet setSelected:NO];
    [self.recentlyBtnOutlet setSelected:NO];
    
    [self.view addSubview:self.yesterdayVC.view];
    [self.todayVC.view removeFromSuperview];
    [self.recentlyVC.view removeFromSuperview];
    
    self.title = @"昨日推荐";
    
    leftView.alpha = 0;
    leftView.hidden = YES;
    
    CGFloat lineToX = self.yesterdayBtnOutlet.frame.origin.x + self.yesterdayBtnOutlet.frame.size.width/2;
    CGFloat lineToY = CGRectGetMaxY(self.yesterdayBtnOutlet.frame)+2;
    CGPoint from =  self.normalPoint;
    CGPoint to = CGPointMake(lineToX,lineToY);
    [WMAnimations WMAnimationToMoveWithTableLayer:self.moveLine.layer andFromPiont:from ToPoint:to];
    
    self.normalPoint = to;
 NSLog(@"from:%@------to:%@",NSStringFromCGPoint(from),NSStringFromCGPoint(to));
}

- (IBAction)recentlyAction:(id)sender {
 //   if (_selectIndex == 0) {
//        [UIView animateWithDuration:0.5 animations:^{
//            
//            self.controllerView.transform = CGAffineTransformMakeTranslation(-2*[[UIScreen mainScreen] bounds].size.width, 0);
//        }];
//
//    }else if (_selectIndex == 1){
//        [UIView animateWithDuration:0.5 animations:^{
//                       self.controllerView.transform = CGAffineTransformMakeTranslation(-[[UIScreen mainScreen] bounds].size.width, 0);
//        }];
//
//    }
    
    leftView.alpha = 0;
    leftView.hidden = YES;
    self.selectIndex = 2;
        [self.recentlyBtnOutlet setSelected:YES];
    [self.todayBtnOutlet setSelected:NO];
    [self.yesterdayBtnOutlet setSelected:NO];
    
    [self.view addSubview:self.recentlyVC.view];
    [self.todayVC.view removeFromSuperview];
    [self.yesterdayVC.view removeFromSuperview];
    
    self.title = @"近期推荐";
    
    
    CGFloat lineToX = self.recentlyBtnOutlet.frame.origin.x + self.recentlyBtnOutlet.frame.size.width/2;
    CGFloat lineToY = CGRectGetMaxY(self.recentlyBtnOutlet.frame)+2;
    CGPoint from = self.normalPoint;
    CGPoint to = CGPointMake(lineToX,lineToY);
    [WMAnimations WMAnimationToMoveWithTableLayer:self.moveLine.layer andFromPiont:from ToPoint:to];
   
    self.normalPoint = to;
     NSLog(@"from:%@------to:%@",NSStringFromCGPoint(from),NSStringFromCGPoint(to));

}
@end
