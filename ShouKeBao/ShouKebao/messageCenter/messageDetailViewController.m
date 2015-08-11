//
//  messageDetailViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "messageDetailViewController.h"
#import "HomeHttpTool.h"
#import "NSDate+Category.h"

#import "YYAnimationIndicator.h"
#import "BeseWebView.h"
#import "MobClick.h"
@interface messageDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *messgeTitle;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet BeseWebView *web;
@property (nonatomic,strong) YYAnimationIndicator *indicator;
@end

@implementation messageDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    CGFloat x = ([UIScreen mainScreen].bounds.size.width/2) - 60;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height/2) - 130;
    self.indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(x, y, 130, 130)];
    [_indicator setLoadText:@"拼命加载中..."];
    [self.view addSubview:_indicator];

    
    [self.web scalesPageToFit];
    [self.web.scrollView setShowsVerticalScrollIndicator:NO];
    [self.web.scrollView setShowsHorizontalScrollIndicator:NO];
    
    self.title = @"消息详情";
    
    [self loadData];
    
    [self.web loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_messageURL]]];
    
    [self setNav];

}
- (void)setNav{

    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,15)];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateHighlighted];
    
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(-1, -10, 0, 50);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-40, 0, 0);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    UIButton *turnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    turnOff.titleLabel.font = [UIFont systemFontOfSize:16];
    turnOff.frame = CGRectMake(0, 0, 30, 10);
    [turnOff addTarget:self action:@selector(turnOff) forControlEvents:UIControlEventTouchUpInside];
    [turnOff setTitle:@"关闭"  forState:UIControlStateNormal];
    turnOff.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    [turnOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    turnOffItem = [[UIBarButtonItem alloc] initWithCustomView:turnOff];
    if (self.m == 0) {
         self.navigationItem.leftBarButtonItems = @[leftItem,turnOffItem];
    }else if(self.m == 1){
        self.navigationItem.leftBarButtonItem = leftItem;
    }
   
}
-(void)turnOff
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShouKeBaomessageDetailView"];

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBaomessageDetailView"];

}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   // [self.delegate toReferesh];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
     [_indicator startAnimation];
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.m == 0) {
        
    }else if(self.m == 1){
        if ([self.web canGoBack]) {
            self.navigationItem.leftBarButtonItem = nil;
            [self.navigationItem setLeftBarButtonItems:@[leftItem,turnOffItem] animated:NO];
        }else{
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = leftItem;
            
        }

    }
    
    [_indicator stopAnimationWithLoadText:@"加载完成" withType:YES];
   
    
}
-(void)loadData{

    self.messgeTitle.text = self.title;
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[self.createDate doubleValue]];
    self.time.text = [createDate formattedTime];
    [self.web loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:_messageURL]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
