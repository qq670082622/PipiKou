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
@interface messageDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *messgeTitle;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIWebView *web;

@end

@implementation messageDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"消息详情";
    
    [self loadData];
    
    [self.web loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_messageURL]]];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;

}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.delegate toReferesh];
    
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
