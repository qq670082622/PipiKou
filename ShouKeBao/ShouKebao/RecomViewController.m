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
@interface RecomViewController ()

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
@property (nonatomic,strong) RecommendViewController *todayVC;
@property(nonatomic,assign) NSInteger selectIndex;
@end

@implementation RecomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.todayBtnOutlet setSelected:YES];
    [self.view addSubview:self.todayVC.view];
    
    CGFloat lineFromX = self.moveLine.center.x;
    CGFloat lineFromY = self.moveLine.center.y;
    self.normalPoint = CGPointMake(lineFromX, lineFromY);

  
    
    self.title = @"今日推荐";
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
    self.selectIndex = 0;
    [self addGes];
    
   
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShouKeBaoRecomView"];

    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    searchBtn.frame = CGRectMake(0, 0, 15, 15);
  //  [searchBtn setContentMode:UIViewContentModeScaleAspectFill];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"fdjForNav"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    UIButton *stationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    stationBtn.frame = CGRectMake(25, 0, 50, 30);
    [stationBtn addTarget:self action:@selector(changeStation) forControlEvents:UIControlEventTouchUpInside];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *stationName = [def objectForKey:@"SubstationName"];
    [stationBtn setTitle:[NSString stringWithFormat:@"%@﹀",stationName]  forState:UIControlStateNormal];
    UIBarButtonItem *stationItem = [[UIBarButtonItem alloc] initWithCustomView:stationBtn];
   
   
      self.leftItem = searchItem;
    self.rightItem = stationItem;
    
    
    [self.navigationItem setRightBarButtonItems:@[searchItem,stationItem] animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super   viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaoRecomView"];

}
-(void)changeStation
{
    [self.navigationController pushViewController:[[StationSelect alloc] init] animated:YES];
}

-(void)searchAction
{
    [self.navigationController pushViewController:[[SearchProductViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(RecommendViewController *)todayVC
{
    if (_todayVC == nil) {
        self.todayVC = [[RecommendViewController alloc] init];
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
   

    CGFloat lineToX = self.todayBtnOutlet.frame.size.width/2;
    CGFloat lineToY = CGRectGetMaxY(self.todayBtnOutlet.frame)+1;
   CGPoint to = CGPointMake(lineToX,lineToY);
   
    [WMAnimations WMAnimationToMoveWithTableLayer:self.moveLine.layer andFromPiont:self.normalPoint ToPoint:to];
   
     self.normalPoint = to;
    NSLog(@"from:%@------to:%@",NSStringFromCGPoint(self.normalPoint),NSStringFromCGPoint(to));
    
    
}

- (IBAction)yesterdayAction:(id)sender {
    
    
    self.selectIndex = 1;
   
     [self.yesterdayBtnOutlet setSelected:YES];
    [self.todayBtnOutlet setSelected:NO];
    [self.recentlyBtnOutlet setSelected:NO];
    
    [self.view addSubview:self.yesterdayVC.view];
    [self.todayVC.view removeFromSuperview];
    [self.recentlyVC.view removeFromSuperview];
    
    self.title = @"昨日推荐";
    
    
    CGFloat lineToX = self.yesterdayBtnOutlet.frame.origin.x + self.yesterdayBtnOutlet.frame.size.width/2;
    CGFloat lineToY = CGRectGetMaxY(self.yesterdayBtnOutlet.frame)+1;
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
    
    
    self.selectIndex = 2;
        [self.recentlyBtnOutlet setSelected:YES];
    [self.todayBtnOutlet setSelected:NO];
    [self.yesterdayBtnOutlet setSelected:NO];
    
    [self.view addSubview:self.recentlyVC.view];
    [self.todayVC.view removeFromSuperview];
    [self.yesterdayVC.view removeFromSuperview];
    
    self.title = @"最近推荐";
    
    
    CGFloat lineToX = self.recentlyBtnOutlet.frame.origin.x + self.recentlyBtnOutlet.frame.size.width/2;
    CGFloat lineToY = CGRectGetMaxY(self.recentlyBtnOutlet.frame)+1;
    CGPoint from = self.normalPoint;
    CGPoint to = CGPointMake(lineToX,lineToY);
    [WMAnimations WMAnimationToMoveWithTableLayer:self.moveLine.layer andFromPiont:from ToPoint:to];
   
    self.normalPoint = to;
     NSLog(@"from:%@------to:%@",NSStringFromCGPoint(from),NSStringFromCGPoint(to));

}
@end
