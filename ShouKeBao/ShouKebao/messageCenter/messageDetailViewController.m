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
    self.navigationController.title = @"消息";
    [self loadData];
    [self.web loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_messageURL]]];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.delegate toReferesh];
    
}

-(void)loadData{
//    NSMutableDictionary *dic = [NSMutableDictionary  dictionary];
//    
//    [dic setObject:self.ID forKey:@"ActivitiesNoticeID"];
//    
//    [HomeHttpTool getActivitiesNoticeDetailWithParam:dic success:^(id json) {
//        NSLog(@"公告详细消息%@",json);
//        NSDictionary *dic =  json[@"ActivitiesNotice"];
//        
//        self.messgeTitle.text = dic[@"Title"];
//        self.time.text = dic[@"CreatedDate"];
//        self.content.text = dic[@"Content"];
//    } failure:^(NSError *error) {
//        NSLog(@"公告详细消息失败%@",error);
//    }];
    self.messgeTitle.text = self.title;
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[self.createDate doubleValue]];
    self.time.text = [createDate formattedTime];
    [self.web loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:_messageURL]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*

 便签
*/


@end
