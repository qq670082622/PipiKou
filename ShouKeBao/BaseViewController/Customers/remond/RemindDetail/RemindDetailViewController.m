//
//  RemindDetailViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/1.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "RemindDetailViewController.h"

@interface RemindDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLebel;

@end

@implementation RemindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noteLebel.text = [NSString stringWithFormat:@"⏰提醒内容:%@",self.note];
    self.timeLabel.text = [NSString stringWithFormat:@"⌚️提醒时间:%@",self.time];
    
    self.noteLebel.layer.cornerRadius = 4;
    self.noteLebel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.noteLebel.layer.borderWidth = 0.5;
    self.noteLebel.layer.masksToBounds = YES;
    
    self.timeLabel.layer.cornerRadius = 4;
    self.timeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.timeLabel.layer.borderWidth = 0.5;
    self.timeLabel.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
