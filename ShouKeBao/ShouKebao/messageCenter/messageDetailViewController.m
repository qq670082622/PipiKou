//
//  messageDetailViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "messageDetailViewController.h"
#import "HomeHttpTool.h"
@interface messageDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *messgeTitle;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIView *subView;
- (IBAction)pushAction:(id)sender;

@end

@implementation messageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"活动";
    [self loadData];
}





-(void)loadData{
    NSMutableDictionary *dic = [NSMutableDictionary  dictionary];
    
    [dic setObject:self.ID forKey:@"ActivitiesNoticeID"];
    
    [HomeHttpTool getActivitiesNoticeDetailWithParam:dic success:^(id json) {
        NSLog(@"公告详细消息%@",json);
        NSDictionary *dic =  json[@"ActivitiesNotice"];
        
        self.messgeTitle.text = dic[@"Title"];
        self.time.text = dic[@"CreatedDate"];
        self.content.text = dic[@"Content"];
    } failure:^(NSError *error) {
        NSLog(@"公告详细消息失败%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*

 便签
*/

- (IBAction)pushAction:(id)sender {
    
}
@end
