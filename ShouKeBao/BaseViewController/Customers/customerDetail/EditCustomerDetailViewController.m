//
//  EditCustomerDetailViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "EditCustomerDetailViewController.h"
#import "IWHttpTool.h"
@interface EditCustomerDetailViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *tele;
@property (weak, nonatomic) IBOutlet UITextField *wechat;
@property (weak, nonatomic) IBOutlet UITextField *QQ;
@property (weak, nonatomic) IBOutlet UITextView *note;
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveOutlet;

@end

@implementation EditCustomerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    self.saveOutlet.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.saveOutlet.layer.borderWidth = 1;
    self.saveOutlet.layer.cornerRadius = 4;
    self.saveOutlet.layer.masksToBounds = YES;
    self.name.text = self.nameStr;
    self.tele.text = self.teleStr;
    self.wechat.text = self.wechatStr;
    self.QQ.text = self.QQStr;
    self.note.text = self.noteStr;
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,20,20)];
    
    [leftBtn setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem= leftItem;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKey)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideKey
{
    
    
    [self.name resignFirstResponder];
    
    [self.tele resignFirstResponder];
    
    [self.wechat resignFirstResponder];
    
    [self.QQ resignFirstResponder];
    
    [self.note resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.wechat resignFirstResponder];
    [self.QQ resignFirstResponder];
    [self.note resignFirstResponder];
    [self.tele resignFirstResponder];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.note resignFirstResponder];
        return NO;
    }
    return YES;
    
}

- (IBAction)save:(id)sender {
    if (self.name.text.length>0 && self.tele.text.length>6) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.name.text forKey:@"Name"];
        [dic setObject:self.tele.text forKey:@"Mobile"];
        [dic setObject:self.wechat.text forKey:@"WeiXinCode"];
        [dic setObject:self.QQ.text forKey:@"QQCode"];
        [dic setObject:self.note.text forKey:@"Remark"];
        [dic setObject:self.ID forKey:@"ID"];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:dic];
        
        NSMutableDictionary *secondDic = [NSMutableDictionary dictionary];
        [secondDic setObject:arr forKey:@"CustomerList"];
        
        [IWHttpTool WMpostWithURL:@"/Customer/CreateCustomerList" params:secondDic success:^(id json) {
            NSLog(@"---- b编辑单个客户成功 %@------",json);
            [self.delegate refreshCustomerInfoWithName:self.name.text andQQ:self.QQ.text andWeChat:self.wechat.text andPhone:self.tele.text andNote:self.note.text];
        } failure:^(NSError *error) {
            NSLog(@"-----创建单个客户失败 %@-----",error);
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(self.name.text.length == 0 && self.tele.text.length<7){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法保存" message:@"您的客户资料非法，若不想保存请点击“管客户”按钮返回" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }

    
}
@end
