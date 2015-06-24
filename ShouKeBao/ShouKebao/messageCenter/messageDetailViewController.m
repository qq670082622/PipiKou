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
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
   // [self.delegate toReferesh];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
     [_indicator startAnimation];
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
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
