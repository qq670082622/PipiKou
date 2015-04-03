//
//  Register.m
//  ShouKeBao
//
//  Created by David on 15/3/16.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "Register.h"

@interface Register ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UITextField *mail;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *rePassWord;
@property (weak, nonatomic) IBOutlet UITextField *company;
@property (weak, nonatomic) IBOutlet UITextField *personName;
@property (weak, nonatomic) IBOutlet UITextField *telPhone;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
- (IBAction)registerBtnAction:(id)sender;

@end

@implementation Register

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"旅行社/分销商注册";
    self.view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.view1.layer.borderWidth = 0.5;
    self.view1.layer.cornerRadius = 5;
    self.view1.layer.masksToBounds = YES;
    
    self.view2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.view2.layer.borderWidth = 0.5;
    self.view2.layer.cornerRadius = 5;
    self.view2.layer.masksToBounds = YES;
    
    self.registerBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    self.registerBtn.layer.borderWidth = 0.5;
    self.registerBtn.layer.cornerRadius = 6;
    self.registerBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)registerBtnAction:(id)sender {
}
@end
