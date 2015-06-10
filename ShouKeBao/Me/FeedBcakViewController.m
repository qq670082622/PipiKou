//
//  FeedBcakViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/6/8.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "FeedBcakViewController.h"
#define K_bounds [UIScreen mainScreen].bounds
#define K_left 30
#define K_between 30
#define K_top 60
#define BGColor(A, B, C) [UIColor colorWithRed:A / 255.0 green:B / 255.0 blue:C / 255.0 alpha:1.0]

@interface FeedBcakViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *suggestTextView;
@property (strong, nonatomic) IBOutlet UILabel *pleaseholderLabel;
@property (strong, nonatomic) IBOutlet UIButton *submitBT;
@property (strong, nonatomic) IBOutlet UIButton *goodBT;
@property (strong, nonatomic) IBOutlet UIButton *badBT;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *goodBT_W;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *goodBT_H;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *badBT_H;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *badBT_W;
@end

@implementation FeedBcakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fitScreen];
    [self setNav];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - FitScreen

- (void)fitScreen{
    self.view.backgroundColor = BGColor(220, 229, 238);
    self.suggestTextView.delegate = self;
    self.title = @"意见反馈";
    self.goodBT_W.constant  = (K_bounds.size.width - K_left * 2) / 2.0;
    self.badBT_W.constant  = (K_bounds.size.width - K_left * 2) / 2.0;
    [self.goodBT setBackgroundImage:[UIImage imageNamed:@"zan.png"] forState:UIControlStateNormal];
    [self.badBT setBackgroundImage:[UIImage imageNamed:@"cai.png"] forState:UIControlStateNormal];
}
- (IBAction)submitSuggest:(UIButton *)sender {
    [self.suggestTextView resignFirstResponder];
    if ([self.suggestTextView.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"亲！啥都不写这算啥" delegate:nil cancelButtonTitle:@"再来" otherButtonTitles:nil];
        [alert show];
    }else{
        UIView *thinksView = [[UIView alloc]initWithFrame:K_bounds];
        [self.view addSubview:thinksView];
        UIImageView *thinksFace = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, K_bounds.size.width - 200, K_bounds.size.width - 200)];
        thinksView.backgroundColor = [UIColor whiteColor];
        thinksFace.image = [UIImage imageNamed:@"xiaolian.png"];
        UILabel *thinksLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(thinksFace.frame) + 5, K_bounds.size.width - 100, 80)];
        thinksLabel.font = [UIFont systemFontOfSize:18];
        thinksLabel.textAlignment = NSTextAlignmentCenter;
        thinksLabel.text = @"感谢您的反馈！";
        [self.view addSubview:thinksFace];
        [self.view addSubview:thinksLabel];
    }
  
}
- (IBAction)goodClick:(UIButton *)sender {
    [self.suggestTextView resignFirstResponder];
    [self.goodBT setBackgroundImage:[UIImage imageNamed:@"zan2.png"] forState:UIControlStateNormal];
    [self.badBT setBackgroundImage:[UIImage imageNamed:@"cai.png"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        self.submitBT.alpha = 00;
        self.suggestTextView.alpha = 0;
        self.pleaseholderLabel.alpha = 0;
    }];
 
}
- (IBAction)badClick:(UIButton *)sender {
    [self.suggestTextView resignFirstResponder];
    [self.goodBT setBackgroundImage:[UIImage imageNamed:@"zan.png"] forState:UIControlStateNormal];
    [self.badBT setBackgroundImage:[UIImage imageNamed:@"cai2.png"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        self.submitBT.alpha = 1.0;
        self.suggestTextView.alpha = 1.0;
        self.pleaseholderLabel.alpha = 1.0;
    }];
}
- (void)setNav
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem= leftItem;
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.pleaseholderLabel.alpha = 0;
    return YES;
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
