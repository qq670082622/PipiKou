//
//  messageDetailViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/3.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "messageDetailViewController.h"

@interface messageDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIView *subView;
- (IBAction)pushAction:(id)sender;

@end

@implementation messageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"活动";
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
