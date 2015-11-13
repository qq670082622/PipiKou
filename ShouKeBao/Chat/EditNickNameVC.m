//
//  EditNickNameVC.m
//  TravelConsultant
//
//  Created by 冯坤 on 15/11/11.
//  Copyright (c) 2015年 冯坤. All rights reserved.
//

#import "EditNickNameVC.h"
#define MaxTextLength 10

@interface EditNickNameVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField * textField;
@property (nonatomic, strong)UILabel * remindLab;

@end

@implementation EditNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:245/255.0 blue:246/255.0 alpha:1];
    [self setTextAndLable];
    [self setNavItem];
}

- (void)setNavItem{
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(commitEdit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}
- (void)commitEdit{
    NSLog(@"提交");
}
- (void)setTextAndLable{
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.font = [UIFont systemFontOfSize:19];
    self.textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textField];
    self.textField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
    CGFloat remindLabY = CGRectGetMaxY(self.textField.frame) + 5;
    self.remindLab = [[UILabel alloc]initWithFrame:CGRectMake(0, remindLabY, [UIScreen mainScreen].bounds.size.width - 10, 20)];
    self.remindLab.backgroundColor = [UIColor clearColor];
    self.remindLab.textAlignment = NSTextAlignmentRight;
    self.remindLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.remindLab];
}
// 监听输入
- (void)textFieldTextChange:(NSNotification *)noty
{
    UITextField *field = (UITextField *)noty.object;
    if (field.text.length<=10) {
        self.remindLab.text = [NSString stringWithFormat:@"您还可以输入%lu个字", MaxTextLength-field.text.length];
    }else{
        self.textField.text = [self.textField.text substringToIndex:MaxTextLength];
    }
}

@end
