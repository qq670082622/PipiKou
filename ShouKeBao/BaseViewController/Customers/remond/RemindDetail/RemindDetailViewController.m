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
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
