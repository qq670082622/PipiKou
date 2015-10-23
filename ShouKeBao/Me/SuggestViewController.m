//
//  SuggestViewController.m
//  ShouKeBao
//
//  Created by 金超凡 on 15/4/1.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SuggestViewController.h"
#import "MBProgressHUD+MJ.h"

@interface SuggestViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *holderLab;

@property (weak, nonatomic) IBOutlet UITextView *adviceTextView;

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor colorWithRed:220/255.0 green:229/255.0 blue:238/255.0 alpha:1];
    [self setNav];
    
    [self setBackButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endInput:)];
    [self.view addGestureRecognizer:tap];
    
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

- (void)setNav
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,60,20)];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateHighlighted];
    
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(-1, -10, 0, 50);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-48, 0, 0);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setBackButton
{
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    CGFloat backX = (self.view.frame.size.width - 250) * 0.5;
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(backX, 20, 250, 45)];
    [back setBackgroundImage:[UIImage imageNamed:@"fanhui_bg"] forState:UIControlStateNormal];
    [back setTitle:@"发  送" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor colorWithRed:63/255.0 green:114/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    
    [cover addSubview:back];
    self.tableView.tableFooterView = cover;
}

- (void)send:(UIButton *)btn
{
    if (self.adviceTextView.text.length) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"发送成功" toView:self.view.window];
        });
    }else{
        [MBProgressHUD showError:@"别不说话啊~ 我已经饥渴难耐了"];
    }
}

- (void)endInput:(UITapGestureRecognizer *)ges
{
    [self.view endEditing:YES];
}

#pragma mark - scrollviewdelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
