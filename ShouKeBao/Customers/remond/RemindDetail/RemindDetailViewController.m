//
//  RemindDetailViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/1.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "RemindDetailViewController.h"
#import "WriteFileManager.h"
#import "remondModel.h"
#import "NSDate+Category.h"
@interface RemindDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteLebel;

@end

@implementation RemindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 查看过的提醒从本地去除
    NSArray *remindArr = [WriteFileManager readData:@"remindData"];
    NSMutableArray *muta = [NSMutableArray arrayWithArray:remindArr];
    for (remondModel *remind in remindArr) {
        if ([remind.ID isEqualToString:self.remindId]) {
            [muta removeObject:remind];
        }}
    
    [WriteFileManager saveData:muta name:@"remindData"];
    
    self.noteLebel.text = [NSString stringWithFormat:@"%@",self.note];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[self.time doubleValue]];
    self.timeLabel.text = [NSString stringWithFormat:@" %@",[createDate formattedTime]];
   
    

    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLookUpRemind)]) {
        [self.delegate didLookUpRemind];
    }
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
