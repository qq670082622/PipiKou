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
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.saveBtn.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:1 andNeedShadow:YES];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.cancleBtn.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:1 andNeedShadow:YES];

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
    [self.delegate passTheMinPrice:self.minPrice.text AndMaxPrice:self.maxPrice.text];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancle:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
@end
