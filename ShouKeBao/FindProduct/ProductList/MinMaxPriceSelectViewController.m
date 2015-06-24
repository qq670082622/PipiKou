//
//  MinMaxPriceSelectViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/4/2.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "MinMaxPriceSelectViewController.h"
#import "WMAnimations.h"

@interface MinMaxPriceSelectViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *minPrice;
@property (weak, nonatomic) IBOutlet UITextField *maxPrice;
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
- (IBAction)cancle:(id)sender;

@end

@implementation MinMaxPriceSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"价格区间";
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.saveBtn.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:1 andNeedShadow:YES];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.cancleBtn.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:1 andNeedShadow:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.maxPrice resignFirstResponder];
    [self.minPrice resignFirstResponder];
    return YES;
}


- (IBAction)save:(id)sender {
   // [self.delegate passTheMinPrice:self.minPrice.text AndMaxPrice:self.maxPrice.text];
    BOOL minBool = [self isPureInt:self.minPrice.text];
    BOOL maxBool = [self isPureInt:self.maxPrice.text];
    long minPrice = [self.minPrice.text longLongValue];
    long maxPrice = [self.maxPrice.text longLongValue];
    BOOL minBiger = minPrice>maxPrice;
    
    if (minBool  && maxBool && !minBiger) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(!minBool || !maxBool ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"您的输入并非纯数字，请重新输入" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        self.minPrice.text = @"";
        self.maxPrice.text = @"";
    }else if (minBiger){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"您输入的最小价格大于最大价格，请重新输入" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        self.minPrice.text = @"";
        self.maxPrice.text = @"";
    }else if (minPrice == 0 || maxPrice == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"价格不能为0，请重新输入" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        self.minPrice.text = @"";
        self.maxPrice.text = @"";
    }
        
    
}
#pragma  - mark 判断字符串内容是否为纯数字
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.delegate passTheMinPrice:self.minPrice.text AndMaxPrice:self.maxPrice.text];
   
}

- (IBAction)cancle:(id)sender {
    self.minPrice.text = @"";
    self.maxPrice.text = @"";
}
@end
