//
//  SuggestViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/1.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SuggestViewController.h"

@interface SuggestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *holderLab;

@property (weak, nonatomic) IBOutlet UITextView *adviceTextView;

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:238/255.0 alpha:1];
    
    [self setBackButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:self.adviceTextView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChange:(NSNotification *)noty
{
    UITextView *textView = (UITextView *)noty.object;
    
    self.holderLab.hidden = textView.text.length;
}

- (void)setBackButton
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    CGFloat backX = (self.view.frame.size.width - 250) * 0.5;
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(backX, 20, 250, 45)];
    [back setBackgroundImage:[UIImage imageNamed:@"fasong"] forState:UIControlStateNormal];
    [back setTitle:@"发送" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor colorWithRed:63/255.0 green:114/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    
    [cover addSubview:back];
    self.tableView.tableFooterView = cover;
}

- (void)send:(UIButton *)btn
{
//    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
